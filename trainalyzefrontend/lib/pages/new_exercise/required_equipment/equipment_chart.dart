import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

class EquipmentChart extends StatefulWidget {
  final Function(String)? onEquipmentChanged;

  const EquipmentChart({
    super.key,
    this.onEquipmentChanged,
  });

  @override
  State<EquipmentChart> createState() => _EquipmentChartState();
}

class _EquipmentChartState extends State<EquipmentChart> {
  int _selectedIndex= -1;

  final equipmentItems = [
    {'icon': FontAwesomeIcons.dumbbell, 'text': 'Kurzhantel'},
    {'icon': FontAwesomeIcons.weightHanging, 'text': 'Langhantel'},
    {'icon': FontAwesomeIcons.bowlingBall, 'text': 'Kettlebell'},
    {'icon': FontAwesomeIcons.cableCar, 'text': 'Kabelzug'},
    {'icon': FontAwesomeIcons.gear, 'text': 'Maschine'},
    {'icon': FontAwesomeIcons.user, 'text': 'Eigengewicht'},
    {'icon': FontAwesomeIcons.ellipsis, 'text': 'Sonstiges'},
  ];
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
                    'Benötigte Ausrüstung',
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
                  child: ListView.builder(
                    itemCount: equipmentItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(equipmentItems[index]['icon'] as IconData),
                        title: Text(equipmentItems[index]['text'] as String),
                        selected: _selectedIndex == index, // ✅ markiert Auswahl
                        selectedColor: AppColors.primary,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index; // 👈 Nur ein Element akiv
                          });
                          if(widget.onEquipmentChanged != null) {
                            widget.onEquipmentChanged!(equipmentItems[_selectedIndex]['text'] as String);
                          }
                        },
                      );
                    },
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
