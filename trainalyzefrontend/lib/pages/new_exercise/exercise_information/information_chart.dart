import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

class InformationChart extends StatefulWidget {
  const InformationChart({super.key});

  @override
  State<InformationChart> createState() => _InformationChartState();
}

class _InformationChartState extends State<InformationChart> {
  final TextEditingController _exerciseNamecontroller = TextEditingController();

  @override
  void dispose() {
    _exerciseNamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 500,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.borderRadiusLarge, // Abgerundete Ecken
      ),
      child: Center(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0)),
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: _exerciseNamecontroller,
                style: const TextStyle(color: AppColors.textPrimary,fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Übungsname',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              )
            )
          ],
        )
      ),
    );
  }
}