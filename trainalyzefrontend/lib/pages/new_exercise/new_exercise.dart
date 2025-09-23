import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/pages/new_exercise/exercise_information/information_chart.dart';
import 'package:trainalyzefrontend/pages/new_exercise/used_muscles/muscle_selector.dart';

class NewExercise extends StatelessWidget {
  const NewExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Prüfe das Verhältnis: Hochformat vs Querformat
          final bool isLandscape = constraints.maxWidth > constraints.maxHeight;
          
          if (isLandscape) {
            // Querformat: Nebeneinander (Row)
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InformationChart(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: MuscleSelector(),
                  ),
                ),
              ],
            );
          } else {
            // Hochformat: Untereinander (Column)
            return SingleChildScrollView(
              child: Column(
                children: [
                  InformationChart(),
                  const SizedBox(height: 16),
                  MuscleSelector(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
