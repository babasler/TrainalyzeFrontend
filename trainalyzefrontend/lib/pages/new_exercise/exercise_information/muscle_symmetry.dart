import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/entities/exercise/exercise.dart';

class MuscleSymmetrySelector extends StatefulWidget {
  final Function(MotionSymmetry?)? onSymmetryChanged;

  const MuscleSymmetrySelector({super.key, this.onSymmetryChanged});

  @override
  State<MuscleSymmetrySelector> createState() => _MuscleSymmetrySelectorState();
}

class _MuscleSymmetrySelectorState extends State<MuscleSymmetrySelector> {
  @override
  Widget build(BuildContext context) {
    return MuscleSymmetrieTypeList(onSymmetryChanged: widget.onSymmetryChanged);
  }
}

class MuscleSymmetrieTypeList extends StatefulWidget {
  final Function(MotionSymmetry?)? onSymmetryChanged;

  const MuscleSymmetrieTypeList({super.key, this.onSymmetryChanged});

  @override
  State<MuscleSymmetrieTypeList> createState() =>
      _MuscleSymmetrieTypeListState();
}

class _MuscleSymmetrieTypeListState extends State<MuscleSymmetrieTypeList> {
  MotionSymmetry? _selectedType = MotionSymmetry.bilateral;

  // Getter für den aktuell ausgewählten Typ
  MotionSymmetry? get selectedMuscleSymmetry => _selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          RadioGroup<MotionSymmetry>(
            groupValue: _selectedType,
            onChanged: (MotionSymmetry? value) {
              setState(() {
                _selectedType = value;
              });
              // Callback an Parent-Komponente
              if (widget.onSymmetryChanged != null) {
                widget.onSymmetryChanged!(value);
              }
            },
            child: Column(
              children: <Widget>[
                RadioListTile<MotionSymmetry>(
                  value: MotionSymmetry.bilateral,
                  title: Text('Bilateral'),
                  fillColor: WidgetStateProperty.all(AppColors.primary),
                  subtitle: Text('Zwei Seiten werden gleichzeitig trainiert'),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 0.0,
                  ),
                  dense: true,
                ),
                RadioListTile<MotionSymmetry>(
                  value: MotionSymmetry.unilateral,
                  title: Text('Unilateral'),
                  fillColor: WidgetStateProperty.all(AppColors.primary),
                  subtitle: Text('Einseitige Übung'),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 0.0,
                  ),
                  dense: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
