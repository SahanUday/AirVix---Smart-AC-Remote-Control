import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xFF0F172A),
      selectedItemColor: const Color(0xFF1E88E5),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.smartphone),
          label: 'Smart Control',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Geofencing',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
      ],
    );
  }
}
