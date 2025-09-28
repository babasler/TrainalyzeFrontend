import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final Widget content;
  final IconData? icon;
  final Color? accentColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              accentColor?.withOpacity(0.5) ??
              AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: accentColor ?? AppColors.primary, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }
}
