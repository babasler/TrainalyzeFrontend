import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

/// Komponente zur Auswahl von Muskeln für Übungen
class MuscleSelector extends StatefulWidget {
  final Set<Muscle>? initialSelectedMuscles;
  final Function(Set<Muscle>?)? onMusclesChanged;
  final double? width;
  final double? height;
  final Color selectedColor;
  final Color strokeColor;
  final Color dotColor;
  final bool actAsToggle;
  final bool isEditing;

  const MuscleSelector({
    super.key,
    this.initialSelectedMuscles,
    this.onMusclesChanged,
    this.width,
    this.height,
    this.selectedColor = AppColors.primary,
    this.strokeColor = Colors.black,
    this.dotColor = Colors.black,
    this.actAsToggle = true,
    this.isEditing = false,
  });

  @override
  State<MuscleSelector> createState() => _MuscleSelectorState();
}

class _MuscleSelectorState extends State<MuscleSelector> {
  Set<Muscle>? selectedMuscles;
  final GlobalKey<MusclePickerMapState> _mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedMuscles = widget.initialSelectedMuscles;
  }

  void _clearSelection() {
    _mapKey.currentState?.clearSelect();
    setState(() {
      selectedMuscles = null;
    });
    if (widget.onMusclesChanged != null) {
      widget.onMusclesChanged!(null);
    }
  }

  void _onMusclesChanged(Set<Muscle>? muscles) {
    setState(() {
      selectedMuscles = muscles;
    });
    if (widget.onMusclesChanged != null) {
      widget.onMusclesChanged!(muscles);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive Größen basierend auf verfügbarem Platz
        final double containerWidth = constraints.maxWidth.clamp(
          200.0,
          AppDimensions.chartWidth,
        );
        final double containerHeight = constraints.maxHeight.clamp(
          300.0,
          AppDimensions.chartHeight,
        );

        return Center(
          // Zentriere den gesamten Container im verfügbaren Raum
          child: Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppDimensions.borderRadiusLarge,
            ),
            child: Column(
              children: [
                // Überschrift
                Padding(
                  padding: EdgeInsets.only(
                    top: containerHeight * 0.03,
                    bottom: containerHeight * 0.02,
                  ),
                  child: Text(
                    'Muskelgruppen auswählen',
                    style: TextStyle(
                      fontSize: containerWidth * 0.06,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: 'SF Pro Display', // Neutrale Schriftart
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Chart-Bereich
                Expanded(
                  child: Stack(
                    children: [
                      // Hauptinhalt
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(containerWidth * 0.03),
                          child: Center(
                            child: Transform.translate(
                              offset: Offset(
                                -containerWidth * 0.04,
                                containerHeight * 0.05,
                              ),
                              child: SizedBox(
                                width: containerWidth,
                                height:
                                    containerHeight *
                                    0.8, // Angepasst für Überschrift
                                child: MusclePickerMap(
                                  key: _mapKey,
                                  width: containerWidth,
                                  height: containerHeight * 0.8,
                                  map: Maps.BODY,
                                  isEditing: widget.isEditing,
                                  onChanged: _onMusclesChanged,
                                  actAsToggle: widget.actAsToggle,
                                  dotColor: widget.dotColor,
                                  selectedColor: widget.selectedColor,
                                  strokeColor: widget.strokeColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
