import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainalyzefrontend/services/auth/auth_service.dart';
import 'package:trainalyzefrontend/pages/login/widgets/pin_input.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _pinKey = GlobalKey();
  final GlobalKey _confirmPinKey = GlobalKey();

  bool _isLoading = false;
  int _currentStep = 0; // 0: Username, 1: PIN, 2: PIN bestätigen
  String? _errorMessage;
  String _enteredPin = '';
  String _confirmedPin = '';

  final List<String> _stepTitles = [
    'Benutzername wählen',
    'PIN festlegen',
    'PIN bestätigen',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
        _errorMessage = null;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _errorMessage = null;
      });
    }
  }

  void _onUsernameSubmitted() {
    if (_formKey.currentState?.validate() ?? false) {
      _nextStep();
    }
  }

  void _onPinCompleted(String pin) {
    setState(() {
      _enteredPin = pin;
    });
    _nextStep();
  }

  void _onPinChanged(String pin) {
    setState(() {
      _enteredPin = pin;
      if (_errorMessage != null) {
        _errorMessage = null;
      }
    });
  }

  void _onConfirmPinCompleted(String pin) {
    setState(() {
      _confirmedPin = pin;
    });

    if (_enteredPin == _confirmedPin) {
      _performRegistration();
    } else {
      setState(() {
        _errorMessage = 'PINs stimmen nicht überein';
        _confirmedPin = '';
      });
      PinInput.clear(_confirmPinKey);
    }
  }

  void _onConfirmPinChanged(String pin) {
    setState(() {
      _confirmedPin = pin;
      if (_errorMessage != null &&
          _errorMessage!.contains('PINs stimmen nicht überein')) {
        _errorMessage = null;
      }
    });
  }

  Future<void> _performRegistration() async {
    if (_usernameController.text.isEmpty ||
        _enteredPin.length != 4 ||
        _confirmedPin.length != 4 ||
        _enteredPin != _confirmedPin) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await AuthService.register(
        username: _usernameController.text.trim(),
        pin: _enteredPin,
      );

      if (response.success) {
        // Registrierung erfolgreich - zur Dashboard weiterleiten
        if (mounted) {
          context.go('/dashboard');
        }
      } else {
        // Registrierung fehlgeschlagen
        setState(() {
          _errorMessage = response.error ?? 'Registrierung fehlgeschlagen';
        });

        // Zurück zum ersten Schritt bei Username-Konflikt
        if (response.error?.contains('bereits vergeben') == true ||
            response.error?.contains('bereits existiert') == true) {
          setState(() {
            _currentStep = 0;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Netzwerkfehler: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Registrieren',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        leading: _currentStep > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: _isLoading ? null : _previousStep,
              )
            : IconButton(
                icon: Icon(Icons.close, color: AppColors.textPrimary),
                onPressed: _navigateToLogin,
              ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width > 600 ? 400 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Fortschritts-Anzeige
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / 3,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),

                  const SizedBox(height: 24),

                  // Schritt-Titel
                  Text(
                    _stepTitles[_currentStep],
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Schritt ${_currentStep + 1} von 3',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Dev-Modus Hinweis
                  if (AppConfig.isDevelopmentMode) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        border: Border.all(color: Colors.orange, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.developer_mode,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DEV-MODUS',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 48),

                  // Schritt-Inhalt
                  if (_currentStep == 0) ...[
                    // Username Input
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              labelText: 'Benutzername',
                              labelStyle: TextStyle(
                                color: AppColors.textPrimary,
                              ),
                              helperText: 'Mindestens 3 Zeichen',
                              helperStyle: TextStyle(
                                color: AppColors.textPrimary.withOpacity(0.7),
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppColors.textPrimary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Bitte Benutzername eingeben';
                              }
                              if (value.trim().length < 3) {
                                return 'Benutzername zu kurz (mind. 3 Zeichen)';
                              }
                              if (value.trim().length > 20) {
                                return 'Benutzername zu lang (max. 20 Zeichen)';
                              }
                              if (!RegExp(
                                r'^[a-zA-Z0-9_]+$',
                              ).hasMatch(value.trim())) {
                                return 'Nur Buchstaben, Zahlen und _ erlaubt';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _onUsernameSubmitted(),
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton(
                            onPressed: _isLoading ? null : _onUsernameSubmitted,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Weiter',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (_currentStep == 1) ...[
                    // PIN festlegen
                    Text(
                      'Wähle eine 4-stellige PIN für dein Konto',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    PinInput(
                      key: _pinKey,
                      length: 4,
                      onCompleted: _onPinCompleted,
                      onChanged: _onPinChanged,
                    ),
                  ] else if (_currentStep == 2) ...[
                    // PIN bestätigen
                    Text(
                      'Gib deine PIN erneut ein um sie zu bestätigen',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    PinInput(
                      key: _confirmPinKey,
                      length: 4,
                      onCompleted: _onConfirmPinCompleted,
                      onChanged: _onConfirmPinChanged,
                      errorText: _errorMessage,
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _isLoading || _confirmedPin.length != 4
                          ? null
                          : () => _onConfirmPinCompleted(_confirmedPin),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Konto erstellen',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Login Link
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Bereits ein Konto? ',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          TextSpan(
                            text: 'Anmelden',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Fehlermeldung (nur bei Schritt 0 und allgemeine Fehler)
                  if (_errorMessage != null &&
                      (_currentStep == 0 ||
                          !_errorMessage!.contains(
                            'PINs stimmen nicht überein',
                          ))) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
