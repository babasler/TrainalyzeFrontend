import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'sidebar.dart';

class LayoutPage extends StatelessWidget {
  final Widget child;
  const LayoutPage({super.key, required this.child});

  void _startTraining(BuildContext context) {
    context.go('/training');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Row(
            children: [
              const Sidebar(),
              Expanded(child: child),
            ],
          ),
          // Floating Training Button - oben rechts
          Positioned(
            top: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () => _startTraining(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.play_arrow, size: 20),
              label: const Text(
                'Training starten',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
