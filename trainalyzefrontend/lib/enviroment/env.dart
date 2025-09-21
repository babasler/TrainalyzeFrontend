import 'package:flutter/material.dart';

/// Globale Umgebungsvariablen und Konstanten für die App
class AppConfig {
  // API-Konfiguration
  static const String baseUrl = 'https://api.trainalyze.com';
  static const String apiVersion = 'v1';
  static const String fullApiUrl = '$baseUrl/api/$apiVersion';
  
  // App-Informationen
  static const String appName = 'Trainalyze';
  static const String appVersion = '1.0.0';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration requestTimeout = Duration(seconds: 15);
}

/// Globale Farbkonstanten für die App
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6750A4); // Deep Purple
  static const Color primaryVariant = Color(0xFF4F378B);
  static const Color onPrimary = Colors.white;
  
  // Secondary Colors
  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Colors.white;
  
  // Background Colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color surface = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = Color(0xFF1C1B1F);
  
  // Error Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Colors.white;
  
  // Custom Colors für Ihre App
  static const Color sidebarBackground = Color(0xFF757575); // Colors.grey[500]
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  
  // Exercise Type Colors
  static const Color kraftColor = Color(0xFFE53935);     // Rot für Kraft
  static const Color ausdauerColor = Color(0xFF1E88E5);  // Blau für Ausdauer
  static const Color cardioColor = Color(0xFF43A047);    // Grün für Cardio
}

/// Globale Größen und Abstände
class AppDimensions {
  // Padding & Margins
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  
  // Sidebar
  static const double sidebarWidth = 255.0;
  
  // Card Sizes
  static const double cardElevation = 2.0;
  static const double cardMaxWidth = 400.0;
}

/// Text Styles
class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );
}

/// Asset Paths
class AppAssets {
  static const String imagePath = 'assets/images/';
  static const String logoPath = '${imagePath}logo.png';
  static const String iconPath = 'assets/icons/';
}

/// Animation Durations
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}