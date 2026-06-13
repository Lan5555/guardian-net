// lib/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home, label: 'Home', index: 0, currentIndex: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.history, label: 'History', index: 1, currentIndex: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.trending_up, label: 'Trust', index: 2, currentIndex: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.person, label: 'Profile', index: 3, currentIndex: currentIndex, onTap: onTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavItem({required this.icon, required this.label, required this.index, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}