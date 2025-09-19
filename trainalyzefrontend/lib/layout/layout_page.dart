import 'package:flutter/material.dart';
import 'sidebar.dart';

class LayoutPage extends StatelessWidget {
  final Widget child;
  const LayoutPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(), // eigene Komponente
          Expanded(child: child), // hier erscheinen die Seiten
        ],
      ),
    );
  }
}
