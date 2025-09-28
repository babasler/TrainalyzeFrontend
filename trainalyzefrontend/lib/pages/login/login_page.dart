import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainalyzefrontend/services/auth/auth_service.dart';
import 'package:trainalyzefrontend/pages/login/widgets/pin_input.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _pinKey = GlobalKey();

  bool _isLoading = false;
  bool _showPinInput = false;
  String? _errorMessage;
  String _enteredPin = '';

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onUsernameSubmitted() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _showPinInput = true;
        _errorMessage = null;
      });
    }
  }

  void _onPinCompleted(String pin) {
    setState(() {
      _enteredPin = pin;
    });
    _performLogin();
  }

  void _onPinChanged(String pin) {
    setState(() {
      _enteredPin = pin;
      if (_errorMessage != null) {
        _errorMessage = null; // Fehler zurücksetzen wenn PIN geändert wird
      }
    });
  }

  Future<void> _performLogin() async {
    if (_usernameController.text.isEmpty || _enteredPin.length != 4) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await AuthService.login(
        username: _usernameController.text.trim(),
        pin: _enteredPin,
      );

      if (response.success) {
        // Login erfolgreich - zur Dashboard weiterleiten
        if (mounted) {
          context.go('/dashboard');
        }
      } else {
        // Login fehlgeschlagen
        setState(() {
          _errorMessage = response.error ?? 'Login fehlgeschlagen';
          _enteredPin = '';
        });

        // PIN-Input zurücksetzen
        PinInput.clear(_pinKey);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Netzwerkfehler: ${e.toString()}';
        _enteredPin = '';
      });

      PinInput.clear(_pinKey);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetToUsername() {
    setState(() {
      _showPinInput = false;
      _errorMessage = null;
      _enteredPin = '';
    });
  }

  void _navigateToRegister() {
    context.go('/register');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                  // Logo
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        50,
                      ), // Vollständig rund
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.surface.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit
                              .cover, // Ändere zu cover für bessere Rundung
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _showPinInput ? 'PIN eingeben' : 'Willkommen zurück',
                    style: theme.textTheme.bodyLarge?.copyWith(
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

                  // Login Form
                  if (!_showPinInput) ...[
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
                              return null;
                            },
                            onFieldSubmitted: (_) => _onUsernameSubmitted(),
                          ),

                          const SizedBox(height: 24),

                          // Weiter Button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _onUsernameSubmitted,
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Weiter',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // PIN Input
                  if (_showPinInput) ...[
                    // Benutzername anzeigen
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _usernameController.text,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _resetToUsername,
                            icon: Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // PIN Input
                    PinInput(
                      key: _pinKey,
                      length: 4,
                      onCompleted: _onPinCompleted,
                      onChanged: _onPinChanged,
                      errorText: _errorMessage,
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    ElevatedButton(
                      onPressed: _isLoading || _enteredPin.length != 4
                          ? null
                          : _performLogin,
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
                              'Anmelden',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Registrierung Link
                  TextButton(
                    onPressed: _navigateToRegister,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Noch kein Konto? ',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          TextSpan(
                            text: 'Registrieren',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Fehlermeldung (nur bei Username-Eingabe)
                  if (_errorMessage != null && !_showPinInput) ...[
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
