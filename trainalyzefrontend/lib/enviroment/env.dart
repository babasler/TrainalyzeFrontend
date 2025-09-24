import 'package:flutter/material.dart';

/// Globale Umgebungsvariablen und Konstanten für die App
class AppConfig {
  // API-Konfiguration
  static const String baseUrl = 'http://trainalyze.com';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration requestTimeout = Duration(seconds: 15);
}

/// Globale Farbkonstanten für die App
class AppColors {
  // Primary Colors
  static const Color primary = Colors.purple; // Deep Purple
  static const Color primaryVariant = Colors.deepPurpleAccent;
  
  // Background Colors
  static const Color background = Color(0xFF424242);
  static const Color surface = Color.fromARGB(255, 129, 129, 129);
  static const Color sidebarBackground = Color(0xFF757575); // Colors.grey[500]
  
  // Error Colors
  static const Color error = Color(0xFFBA1A1A);

  static const Color textPrimary = Color(0x99FFFFFF);

}

/// Globale Größen und Abstände
class AppDimensions {
  // Padding & Margins
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  
  // Sidebar Dimensionen
  static const double sidebarWidthMobile = 80.0;
  static const double sidebarWidthTablet = 230.0;
  static const double sidebarWidthDesktop = 255.0;

  static BorderRadiusGeometry borderRadiusSmall = BorderRadiusGeometry.circular(8.0);
  static BorderRadiusGeometry borderRadiusMedium = BorderRadiusGeometry.circular(12.0);
  static BorderRadiusGeometry borderRadiusLarge = BorderRadiusGeometry.circular(16.0);

  static const double chartWidth = 300.0;
  static const double chartHeight = 500.0;

}
  
/// Asset Paths
class AppAssets {
  static const String imagePath = 'assets/images/';
  static const String logoPath = '${imagePath}logo.png';
  static const String iconPath = 'assets/icons/';
}
