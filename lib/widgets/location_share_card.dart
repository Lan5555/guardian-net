// lib/widgets/location_share_card.dart
import 'package:flutter/material.dart';

class LocationShareCard extends StatelessWidget {
  const LocationShareCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, size: 14, color: Color(0xFF2563EB)),
              SizedBox(width: 4),
              Text('Live location:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(width: 4),
              Text('Downtown, 5th & Main', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showToast(context, '📍 Location shared with responders & nearby verified users (SMS + push).'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Color(0x330F172A), blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Share with responders', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('📍 Notifying nearby users (1.5km radius)', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}