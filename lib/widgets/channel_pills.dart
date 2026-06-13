// lib/widgets/channel_pills.dart
import 'package:flutter/material.dart';

class ChannelPills extends StatelessWidget {
  const ChannelPills({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Pill(icon: Icons.notifications, label: 'App Alert'),
          SizedBox(width: 12),
          _Pill(icon: Icons.sms, label: 'SMS Active'),
          SizedBox(width: 12),
          _Pill(icon: Icons.memory, label: 'RFID Ready'),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}