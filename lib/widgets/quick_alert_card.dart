// lib/widgets/quick_alert_cards.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

class QuickAlertCards extends StatelessWidget {
  const QuickAlertCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _AlertCard(icon: Icons.masks, label: 'Robbery', type: 'Robbery', color: const Color(0xFFF97316))),
        const SizedBox(width: 14),
        Expanded(child: _AlertCard(icon: Icons.local_fire_department, label: 'Fire', type: 'Fire', color: const Color(0xFFEF4444))),
        const SizedBox(width: 14),
        Expanded(child: _AlertCard(icon: Icons.car_crash, label: 'Accident', type: 'Accident', color: const Color(0xFFF59E0B))),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String type;
  final Color color;
  const _AlertCard({required this.icon, required this.label, required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<AppStateProvider>(context, listen: false).sendNewUserAlert(type);
        _showToast(context, '🚨 $label alert sent! Nearby users & responders notified.');
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}