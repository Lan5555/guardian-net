// lib/widgets/sidebar.dart
import 'package:flutter/material.dart';
import 'package:guardian_net/modules/auth/views/login.dart';

class Sidebar extends StatelessWidget {
  final bool isOpen;
  final int currentIndex;
  final Function(int) onItemSelected;

  const Sidebar({super.key, required this.isOpen, required this.currentIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();
    return Container(
      width: 60,
      color: Color.fromARGB(255, 216, 213, 213),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          _SidebarIcon(icon: Icons.shield, index: 0, currentIndex: currentIndex, onTap: () => onItemSelected(0)),
          const SizedBox(height: 25),
          _SidebarIcon(icon: Icons.people, index: 2, currentIndex: currentIndex, onTap: () => onItemSelected(2)),
          const SizedBox(height: 25),
          _SidebarIcon(icon: Icons.list, index: 1, currentIndex: currentIndex, onTap: () => onItemSelected(1)),
          const SizedBox(height: 25),
          _SidebarIcon(icon: Icons.settings, index: 3, currentIndex: currentIndex, onTap: () => onItemSelected(3)),
          const SizedBox(height: 25),
          _SidebarIcon(icon: Icons.logout, index: 4, currentIndex: currentIndex, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()))),

        ],
      ),
    );
  }
}

class _SidebarIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _SidebarIcon({required this.icon, required this.index, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
      ),
    );
  }
}