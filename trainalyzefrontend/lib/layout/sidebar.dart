import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Prüfe ob Querformat (weniger Höhe verfügbar)
    final bool isLandscape = screenWidth > screenHeight;
    
    // Responsive Sidebar-Breite basierend auf Display-Typ
    double sidebarWidth;
    double logoSize;
    double topPadding;
    
    if (screenWidth < AppDimensions.mobileBreakpoint) {
      // iPhone/Smartphone: Schmale Sidebar
      sidebarWidth = AppDimensions.sidebarWidthMobile;
      logoSize = isLandscape ? 30 : 40; // Kleineres Logo im Querformat
      topPadding = isLandscape ? 16 : 32; // Weniger Padding im Querformat
    } else if (screenWidth < AppDimensions.tabletBreakpoint) {
      // iPad/Tablet: Mittlere Sidebar (bleibt gleich in beiden Orientierungen)
      sidebarWidth = AppDimensions.sidebarWidthTablet;
      logoSize = isLandscape ? 60 : 80;
      topPadding = isLandscape ? 24 : 48;
    } else {
      // Desktop/große Tablets: Volle Sidebar (bleibt gleich in beiden Orientierungen)
      sidebarWidth = AppDimensions.sidebarWidthDesktop;
      logoSize = isLandscape ? 90 : 120;
      topPadding = isLandscape ? 32 : 64;
    }
    
    // Kompakte Sidebar NUR für iPhone im Querformat
    final bool isCompact = screenWidth < AppDimensions.mobileBreakpoint && isLandscape;

    return Container(
      width: sidebarWidth,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          // Logo-Bereich (immer sichtbar)
          Padding(padding: EdgeInsets.fromLTRB(0.0, topPadding, 0.0, 8.0)),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: isCompact ? 8 : 16),
          // Scrollbare Navigation
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _buildNavItem(
                    context,
                    "/dashboard",
                    Icons.home,
                    "Dashboard",
                    location,
                    isCompact,
                  ),
                  _buildNavItem(
                    context,
                    "/new/exercise",
                    Icons.settings,
                    "Neue Übung",
                    location,
                    isCompact,
                  ),
                  _buildNavItem(
                    context,
                    "/new/workout",
                    Icons.info,
                    "Neues Workout",
                    location,
                    isCompact,
                  ),
                  _buildNavItem(
                    context,
                    "/new/plan",
                    Icons.plus_one,
                    "Neuer Trainingsplan",
                    location,
                    isCompact,
                  ),
                  _buildNavItem(context, "/profile", Icons.person, "Profil", location, isCompact),
                  _buildNavItem(
                    context,
                    "/statistics",
                    Icons.info,
                    "Statistiken",
                    location,
                    isCompact,
                  ),
                  // Zusätzlicher Platz am Ende für besseres Scrolling
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String path,
    IconData icon,
    String label,
    String location,
    bool isCompact,
  ) {
    final bool selected = location == path;
    
    if (isCompact) {
      // Kompakte Ansicht: Nur Icon mit Tooltip
      return Tooltip(
        message: label,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: IconButton(
            icon: Icon(
              icon, 
              color: selected ? AppColors.primary : AppColors.textPrimary,
              size: 24,
            ),
            onPressed: () => context.go(path),
            style: IconButton.styleFrom(
              backgroundColor: selected ? AppColors.primaryVariant : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );
    } else {
      // Normale Ansicht: Icon + Text
      return ListTile(
        leading: Icon(icon, color: selected ? AppColors.primary: AppColors.textPrimary),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tileColor: selected ? AppColors.primaryVariant : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        onTap: () => context.go(path),
      );
    }
  }
}
