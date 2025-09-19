import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 220,
      color: Colors.grey[500],
      child: ListView(
        children: [
          const SizedBox(height: 16),
          _buildNavItem(context, "/dashboard", Icons.home, "Dashboard", location),
          _buildNavItem(context, "/new/exercise", Icons.settings, "Neue Übung", location),
          _buildNavItem(context, "/new/workout", Icons.info, "Neues Workout", location),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String path, IconData icon, String label, String location) {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => context.go(path),
    );
  }
}
