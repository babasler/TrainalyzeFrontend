import 'package:flutter/material.dart';

/// Globale Umgebungsvariablen und Konstanten für die App
class AppConfig {
  // Development-Modus (setzt auf true für lokale Entwicklung ohne Backend)
  static const bool isDevelopmentMode = false;

  // API-Konfiguration
  static const String baseUrl = 'http://localhost:8084/trainalyze';

  // Dev-Mode Login-Daten (werden nur im Development-Modus verwendet)
  static const String devUsername = 'dev';
  static const String devPin = '1234';

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

  static BorderRadiusGeometry borderRadiusSmall = BorderRadiusGeometry.circular(
    8.0,
  );
  static BorderRadiusGeometry borderRadiusMedium =
      BorderRadiusGeometry.circular(12.0);
  static BorderRadiusGeometry borderRadiusLarge = BorderRadiusGeometry.circular(
    16.0,
  );

  static const double chartWidth = 300.0;
  static const double chartHeight = 500.0;
}

/// Responsive Hilfsfunktionen für einheitliche Bildschirmberechnungen
class AppResponsive {
  /// Ermittelt den Gerätetyp basierend auf Bildschirmbreite
  static DeviceType getDeviceType(double screenWidth) {
    if (screenWidth < AppDimensions.mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (screenWidth < AppDimensions.tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Prüft ob das Gerät im Querformat ist
  static bool isLandscape(double screenWidth, double screenHeight) {
    return screenWidth > screenHeight;
  }

  /// Prüft ob die Sidebar kompakt angezeigt werden soll
  static bool shouldUseCompactSidebar(double screenWidth, double screenHeight) {
    return getDeviceType(screenWidth) == DeviceType.mobile &&
        isLandscape(screenWidth, screenHeight);
  }

  /// Ermittelt die optimale Sidebar-Breite
  static double getSidebarWidth(double screenWidth) {
    switch (getDeviceType(screenWidth)) {
      case DeviceType.mobile:
        return AppDimensions.sidebarWidthMobile;
      case DeviceType.tablet:
        return AppDimensions.sidebarWidthTablet;
      case DeviceType.desktop:
        return AppDimensions.sidebarWidthDesktop;
    }
  }

  /// Ermittelt die optimale Logo-Größe
  static double getLogoSize(double screenWidth, double screenHeight) {
    final bool isLandscapeMode = isLandscape(screenWidth, screenHeight);

    switch (getDeviceType(screenWidth)) {
      case DeviceType.mobile:
        return isLandscapeMode ? 30 : 40;
      case DeviceType.tablet:
        return isLandscapeMode ? 60 : 80;
      case DeviceType.desktop:
        return isLandscapeMode ? 90 : 120;
    }
  }

  /// Ermittelt den optimalen Top-Padding
  static double getTopPadding(double screenWidth, double screenHeight) {
    final bool isLandscapeMode = isLandscape(screenWidth, screenHeight);

    switch (getDeviceType(screenWidth)) {
      case DeviceType.mobile:
        return isLandscapeMode ? 16 : 32;
      case DeviceType.tablet:
        return isLandscapeMode ? 24 : 48;
      case DeviceType.desktop:
        return isLandscapeMode ? 32 : 64;
    }
  }

  /// Ermittelt die verfügbare Inhaltsbreite (ohne Sidebar)
  static double getContentWidth(double screenWidth) {
    return screenWidth - getSidebarWidth(screenWidth);
  }

  /// Ermittelt ob Text oder nur Icons in der Navigation angezeigt werden sollen
  static bool shouldShowNavigationLabels(
    double screenWidth,
    double screenHeight,
  ) {
    return !shouldUseCompactSidebar(screenWidth, screenHeight);
  }
}

/// Gerätetyp-Enum für bessere Typsicherheit
enum DeviceType { mobile, tablet, desktop }

/// Asset Paths
class AppAssets {
  static const String imagePath = 'assets/images/';
  static const String logoPath = '${imagePath}logo.png';
  static const String iconPath = 'assets/icons/';
}
