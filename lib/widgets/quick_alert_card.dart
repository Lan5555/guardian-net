// lib/widgets/quick_alert_cards.dart
import 'package:flutter/material.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';

class QuickAlertCards extends StatelessWidget {
  const QuickAlertCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AlertCard(
            icon: Icons.security,
            label: 'Robbery',
            type: 'Robbery',
            color: const Color(0xFFF97316),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _AlertCard(
            icon: Icons.local_fire_department,
            label: 'Fire',
            type: 'Fire',
            color: const Color(0xFFEF4444),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _AlertCard(
            icon: Icons.minor_crash,
            label: 'Accident',
            type: 'Accident',
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String type;
  final Color color;
  const _AlertCard({
    required this.icon,
    required this.label,
    required this.type,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleAlert(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _handleAlert(BuildContext context) {
    final currentUser = context.read<SessionProvider>().user;
    if (currentUser?.communityId == null) {
      _showToast(context, 'Invalid Community Id');
      return;
    }
    Provider.of<AlertProvider>(
      context,
      listen: false,
    ).sendNewUserAlert(type, communityId: currentUser!.communityId!, userId: currentUser.id, userName: currentUser.name!, context: context);
    _showToast(
      context,
      '🚨 $label alert sent! Nearby users & responders notified.',
    );
  }
}
