import 'package:flutter/material.dart';
import 'sidebar.dart';

class LayoutPage extends StatelessWidget {
  final Widget child;
  const LayoutPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Row(
        children: [
          const Sidebar(),
          Expanded(child: child), 
        ],
      ),
    );
  }
}
