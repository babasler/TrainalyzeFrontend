import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 255,
      color: Colors.grey[500],
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 8.0)),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          _buildNavItem(
            context,
            "/dashboard",
            Icons.home,
            "Dashboard",
            location,
          ),
          _buildNavItem(
            context,
            "/new/exercise",
            Icons.settings,
            "Neue Übung",
            location,
          ),
          _buildNavItem(
            context,
            "/new/workout",
            Icons.info,
            "Neues Workout",
            location,
          ),
          _buildNavItem(
            context,
            "/new/plan",
            Icons.plus_one,
            "Neuer Trainingsplan",
            location,
          ),
          _buildNavItem(context, "/profile", Icons.person, "Profil", location),
          _buildNavItem(
            context,
            "statistics",
            Icons.info,
            "Statistiken",
            location,
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
  ) {
    final bool selected = location == path;
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.purple : Colors.grey[800]),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.purple : Colors.grey[800],
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: selected ? Colors.deepPurple : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      onTap: () => context.go(path),
    );
  }
}
