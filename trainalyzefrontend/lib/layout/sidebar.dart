import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/services/auth/auth_service.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Verwende zentralisierte Responsive-Berechnungen
    final double sidebarWidth = AppResponsive.getSidebarWidth(screenWidth);
    final double logoSize = AppResponsive.getLogoSize(
      screenWidth,
      screenHeight,
    );
    final double topPadding = AppResponsive.getTopPadding(
      screenWidth,
      screenHeight,
    );
    final bool isCompact = AppResponsive.shouldUseCompactSidebar(
      screenWidth,
      screenHeight,
    );

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
                    FontAwesomeIcons.dumbbell,
                    "Neue Übung",
                    location,
                    isCompact,
                  ),
                  _buildNavItem(
                    context,
                    "/new/workout",
                    FontAwesomeIcons.fire,
                    "Neues Workout",
                    location,
                    isCompact,
                  ),
                  _buildNavItem(
                    context,
                    "/new/plan",
                    FontAwesomeIcons.clipboardList,
                    "Neuer Trainingsplan",
                    location,
                    isCompact,
                  ),
                  _buildNavItem(
                    context,
                    "/profile",
                    Icons.person,
                    "Profil",
                    location,
                    isCompact,
                  ),
                  _buildNavItem(
                    context,
                    "/statistics",
                    Icons.info,
                    "Statistiken",
                    location,
                    isCompact,
                  ),

                  // Logout Button
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildLogoutButton(context, isCompact),

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
        leading: Icon(
          icon,
          color: selected ? AppColors.primary : AppColors.textPrimary,
        ),
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

  Widget _buildLogoutButton(BuildContext context, bool isCompact) {
    if (isCompact) {
      // Kompakte Ansicht: Nur Icon mit Tooltip
      return Tooltip(
        message: 'Abmelden',
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: IconButton(
            icon: Icon(Icons.logout, color: AppColors.error),
            onPressed: () => _showLogoutDialog(context),
          ),
        ),
      );
    } else {
      // Normale Ansicht: Icon + Text
      return ListTile(
        leading: Icon(Icons.logout, color: AppColors.error),
        title: Text(
          'Abmelden',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        onTap: () => _showLogoutDialog(context),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Abmelden'),
          content: const Text('Möchtest du dich wirklich abmelden?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthService.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: Text(
                'Abmelden',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
