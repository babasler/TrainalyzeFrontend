import 'package:flutter/material.dart';

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
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(16), // Abgerundete Ecken
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: _exerciseNamecontroller,
                decoration: const InputDecoration(
                  labelText: 'Übungsname',
                  border: OutlineInputBorder(),
              ),
              )
            )
          ],
        )
      ),
    );
  }
}