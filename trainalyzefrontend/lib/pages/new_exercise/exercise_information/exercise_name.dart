import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

class ExerciseName extends StatefulWidget {
  final Function(String)? onNameChanged; // Callback für Parent-Komponente
  final String? initialValue; // Optionaler Anfangswert
  
  const ExerciseName({
    super.key,
    this.onNameChanged,
    this.initialValue,
  });

  @override
  State<ExerciseName> createState() => _ExerciseNameState();
}

class _ExerciseNameState extends State<ExerciseName> {
  final TextEditingController _exerciseNamecontroller = TextEditingController();

  // Getter für den aktuellen Namen
  String get exerciseName => _exerciseNamecontroller.text;

  @override
  void initState() {
    super.initState();
    // Setze Anfangswert falls vorhanden
    if (widget.initialValue != null) {
      _exerciseNamecontroller.text = widget.initialValue!;
    }
    
    // Listener für Textänderungen
    _exerciseNamecontroller.addListener(() {
      if (widget.onNameChanged != null) {
        widget.onNameChanged!(_exerciseNamecontroller.text);
      }
    });
  }

  @override
  void dispose() {
    _exerciseNamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: _exerciseNamecontroller,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          labelText: 'Übungsname',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary, // Farbe wenn nicht fokussiert
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary, // Farbe wenn fokussiert
              width: 2.0,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary, // Fallback
              width: 1.0,
            ),
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary, // Label-Farbe angepasst
          ),
        ),
      ),
    );
  }
}
