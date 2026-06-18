// lib/widgets/location_share_card.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';

class LocationShareCard extends StatefulWidget {
  const LocationShareCard({super.key});

  @override
  State<LocationShareCard> createState() => _LocationShareCardState();
}

class _LocationShareCardState extends State<LocationShareCard> {
  bool _isSharing = false;

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
            children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xFF2563EB)),
              const SizedBox(width: 4),
              const Text(
                'Live location:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Downtown, 5th & Main',
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _isSharing
                ? null
                : () async {
                    setState(() => _isSharing = true);
                    final user = context.read<SessionProvider>().user;
                    final locationDetails = context.read<SessionProvider>();
                    await locationDetails.initLiveLocation();
                    if (user != null && user.communityId != null) {
                      await context
                          .read<AlertProvider>()
                          .sendNewUserAlert(
                            'LOCATION_SHARE',
                            communityId: user.communityId!,
                            userId: user.id,
                            userName: user.name,
                            context: context,
                            message: locationDetails.liveLocation,
                          )
                      .then((_) async {
                        await context.read<SessionProvider>().shareLocation();
                        if (context.mounted) {
                          _showToast(
                            context,
                            '📍 Location shared with responders & nearby verified users (SMS + push).',
                          );
                        }
                      });
                    }
                    setState(() => _isSharing = false);
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color:
                    _isSharing ? const Color(0xFF64748B) : const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x330F172A),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isSharing
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.share, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'Share with responders',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '📍 Notifying nearby users (1.5km radius)',
            style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
