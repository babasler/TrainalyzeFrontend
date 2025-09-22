import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';

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
    this.selectedColor = Colors.lightBlueAccent,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header mit Titel und Clear Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Beanspruchte Muskeln',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: _clearSelection,
                  tooltip: 'Auswahl löschen',
                ),
              ],
            ),
          ),
          
          // Muscle Picker
          InteractiveViewer(
            scaleEnabled: true,
            panEnabled: true,
            constrained: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: widget.width ?? 300,
                height: widget.height ?? 400,
                child: MusclePickerMap(
                  key: _mapKey,
                  width: widget.width ?? 300,
                  height: widget.height ?? 400,
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
          
          // Info über ausgewählte Muskeln
          if (selectedMuscles != null && selectedMuscles!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ausgewählte Muskeln:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedMuscles!.map((muscle) {
                      return Chip(
                        label: Text(
                          muscle.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: widget.selectedColor.withOpacity(0.2),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            selectedMuscles!.remove(muscle);
                          });
                          _onMusclesChanged(selectedMuscles);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}