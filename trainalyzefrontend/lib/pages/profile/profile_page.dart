import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/entities/profile/bodyweight.dart';
import 'package:trainalyzefrontend/entities/profile/profile.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/services/auth/jwt_service.dart';
import 'package:trainalyzefrontend/services/profile/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Aktueller User
  String? _username;

  // Loading State
  bool _isLoading = true;

  // Profil-Parameter
  Profile? _userProfile;

  // Dropdown-Optionen
  final List<String> _weightIncreaseTypes = ['range', 'absolute'];

  final List<String> _workoutSelectionOptions = ['plan', 'select'];

  final List<String> _handleMissingWorkoutOptions = [
    'skip',
    'postpone',
  ];

  //TODO:API Nutzen
  final List<String> _availableTrainingsplans = [
    'Push/Pull/Legs',
    'Upper/Lower',
    'Full Body',
    'Bro Split',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadCurrentUser();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await ProfileService().fetchProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil konnte nicht geladen werden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      // Token holen und Username extrahieren
      final token = await JwtService.getToken();
      if (token != null) {
        final tokenData = JwtService.getUserFromToken(token);
        if (tokenData != null && mounted) {
          // Username aus Token (entweder 'username' oder 'sub')
          final username = tokenData['username'] ?? tokenData['sub'];
          setState(() {
            _username = username;
          });
        }
      }
    } catch (e) {
      print('Error loading username: $e');
    }
  }

  Future<void> _saveProfile() async {
    final success = await ProfileService().updateProfile(_userProfile!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil erfolgreich gespeichert'),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Speichern des Profils'),
          backgroundColor: Colors.red,
        ),
      );
    }
    _loadUserProfile();
  }

  Future<void> _saveBodyWeight(double newWeight) async {
    final bodyWeight = BodyWeight(
      weight: newWeight,
      date: DateTime.now(),
    );
    final success = await ProfileService().safeBodyWeight(bodyWeight);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gewicht erfolgreich gespeichert'),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Speichern des Gewichts'),
          backgroundColor: Colors.red,
        ),
      );
    }
    _loadUserProfile();
  }

  String _getDisplayText(String key, String value) {
    switch (key) {
      case 'weightIncreaseType':
        return value == 'range' ? 'Bereich' : 'Absolut';
      case 'workoutSelection':
        switch (value) {
          case 'plan':
            return 'Nach Plan';
          case 'select':
            return 'Auswählen';
          default:
            return value;
        }
      case 'handleMissingWorkout':
        switch (value) {
          case 'skip':
            return 'Überspringen';
          case 'replace':
            return 'Ersetzen';
          case 'notify':
            return 'Benachrichtigen';
          default:
            return value;
        }
      default:
        return value;
    }
  }

  String _getKeyForTitle(String title) {
    switch (title) {
      case 'Steigerungsart':
        return 'weightIncreaseType';
      case 'Workout-Auswahl':
        return 'workoutSelection';
      case 'Fehlende Workouts':
        return 'handleMissingWorkout';
      default:
        return title.toLowerCase();
    }
  }


  Future<void> _showWeightEntryDialog() async {
    final TextEditingController weightController = TextEditingController(
      text: _userProfile!.bodyWeight.toString(),
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Neues Gewicht eintragen',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Gewicht (kg)',
                  labelStyle: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Datum: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                style: TextStyle(
                  color: AppColors.textPrimary.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Abbrechen',
                style: TextStyle(color: AppColors.textPrimary.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final double? newWeight = double.tryParse(
                  weightController.text,
                );
                _saveBodyWeight(newWeight!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showHeightEntryDialog() async {
    final TextEditingController heightController = TextEditingController(
      text: _userProfile!.bodyHeight.toString(),
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Körpergröße eintragen',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Größe (cm)',
                  labelStyle: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Abbrechen',
                style: TextStyle(color: AppColors.textPrimary.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final double? newHeight = double.tryParse(
                  heightController.text,
                );
                if (newHeight != null && newHeight > 50 && newHeight < 250) {
                  setState(() {
                    _userProfile!.bodyHeight = newHeight;
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Profil wird geladen...',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : _userProfile == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Profil konnte nicht geladen werden',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUserProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Erneut versuchen'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      _username?.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _username ?? 'Lädt...',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Trainingseinstellungen',
                          style: TextStyle(
                            color: AppColors.textPrimary.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Körpergewicht und BMI Sektion
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Körperdaten & BMI',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _showHeightEntryDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: Icon(Icons.height, size: 16),
                              label: Text('Größe'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _showWeightEntryDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: Icon(Icons.monitor_weight, size: 16),
                              label: Text('Gewicht'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Körpergröße',
                                style: TextStyle(
                                  color: AppColors.textPrimary.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_userProfile!.bodyHeight.toStringAsFixed(0)} cm',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Aktuelles Gewicht',
                                style: TextStyle(
                                  color: AppColors.textPrimary.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_userProfile!.bodyWeight.toStringAsFixed(1)} kg',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'BMI',
                                style: TextStyle(
                                  color: AppColors.textPrimary.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userProfile!.bmi.toStringAsFixed(1),
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Trainingseinstellungen
              _buildSectionTitle('Gewichtssteigerung'),

              _buildDropdownCard(
                title: 'Steigerungsart',
                value: _userProfile!.weightIncreaseType,
                items: _weightIncreaseTypes,
                displayText: _getDisplayText(
                  'weightIncreaseType',
                  _userProfile!.weightIncreaseType,
                ),
                onChanged: (value) =>
                    setState(() => _userProfile!.weightIncreaseType = value!),
              ),

              _buildNumberCard(
                title: 'Steigerung (kg)',
                value: _userProfile!.increaseWeight,
                unit: 'kg',
                onChanged: (value) => setState(() => _userProfile!.increaseWeight = value),
              ),

              _buildNumberCard(
                title: 'Steigern bei Wiederholungen',
                value: _userProfile!.increaseAtReps.toDouble(),
                unit: 'Reps',
                onChanged: (value) =>
                    setState(() => _userProfile!.increaseAtReps = value.round()),
                isInteger: true,
              ),

              const SizedBox(height: 24),

              // Workout-Einstellungen
              _buildSectionTitle('Workout-Verwaltung'),

              _buildDropdownCard(
                title: 'Workout-Auswahl',
                value: _userProfile!.workoutSelection,
                items: _workoutSelectionOptions,
                displayText: _getDisplayText(
                  'workoutSelection',
                  _userProfile!.workoutSelection,
                ),
                onChanged: (value) {
                  setState(() {
                    _userProfile!.workoutSelection = value!;
                    // Setze Trainingsplan und Fehlende Workouts auf "NONE", wenn "Auswählen" gewählt wird
                    if (value == 'select') {
                      _userProfile!.selectedTrainingsplan = 'NONE';
                      _userProfile!.handleMissingWorkout = 'NONE';
                    }
                  });
                },
              ),

              if (_userProfile!.workoutSelection == 'plan') ...[
                _buildDropdownCard(
                  title: 'Trainingsplan',
                  value: _userProfile!.selectedTrainingsplan == 'NONE' 
                      ? null 
                      : _userProfile!.selectedTrainingsplan,
                  items: _availableTrainingsplans,
                  displayText: _userProfile!.selectedTrainingsplan == 'NONE'
                      ? ''
                      : _userProfile!.selectedTrainingsplan,
                  onChanged: (value) =>
                      setState(() => _userProfile!.selectedTrainingsplan = value ?? 'NONE'),
                  allowNull: true,
                ),
                _buildDropdownCard(
                  title: 'Fehlende Workouts',
                  value: _userProfile!.handleMissingWorkout == 'NONE'
                      ? null
                      : _userProfile!.handleMissingWorkout,
                  items: _handleMissingWorkoutOptions,
                  displayText: _userProfile!.handleMissingWorkout == 'NONE'
                      ? ''
                      : _getDisplayText(
                          'handleMissingWorkout',
                          _userProfile!.handleMissingWorkout,
                        ),
                  onChanged: (value) =>
                      setState(() => _userProfile!.handleMissingWorkout = value ?? 'NONE'),
                ),
              ],

              const SizedBox(height: 32),

              // Speichern Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Einstellungen speichern',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDropdownCard({
    required String title,
    required String? value,
    required List<String> items,
    required String displayText,
    required void Function(String?) onChanged,
    bool allowNull = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: items.contains(value) ? value : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            dropdownColor: AppColors.surface,
            style: TextStyle(color: AppColors.textPrimary),
            items: items
                .toSet() // Entferne Duplikate
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(_getDisplayText(_getKeyForTitle(title), item)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberCard({
    required String title,
    required double value,
    required String unit,
    required void Function(double) onChanged,
    bool isInteger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value.clamp(
                    isInteger ? 1.0 : 0.5,
                    isInteger ? 20.0 : 10.0,
                  ),
                  min: isInteger ? 1 : 0.5,
                  max: isInteger ? 20 : 10,
                  divisions: isInteger
                      ? 19
                      : 19, // 0.5 bis 10 in 0.5er Schritten = 19 Schritte
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primary.withValues(alpha: 0.3),
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Text(
                  '${isInteger ? value.round() : value.toStringAsFixed(1)} $unit',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
