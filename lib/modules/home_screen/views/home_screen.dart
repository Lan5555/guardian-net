// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:guardian_net/widgets/channel_pills.dart';
import 'package:guardian_net/widgets/community_alert_lists.dart';
import 'package:guardian_net/widgets/location_share_card.dart';
import 'package:guardian_net/widgets/panic_button.dart';
import 'package:guardian_net/widgets/quick_alert_card.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          PanicWrapper(),
          SizedBox(height: 24),
          SectionTitle(icon: Icons.bolt, title: 'Quick Alert'),
          QuickAlertCards(),
          SizedBox(height: 16),
          ChannelPills(),
          SizedBox(height: 24),
          FeedHeader(),
          CommunityAlertsList(),
          SizedBox(height: 24),
          LocationShareCard(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class PanicWrapper extends StatelessWidget {
  const PanicWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF2F2), Color(0xFFFFF1F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFEE2E2), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Emergency SOS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF991B1B), letterSpacing: -0.5)),
                SizedBox(height: 4),
                Text('Tap for immediate assistance from nearby guardians', style: TextStyle(fontSize: 11, color: Color(0xFFB91C1C), height: 1.2)),
              ],
            ),
          ),
          const PanicButton(),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2563EB)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}

class FeedHeader extends StatelessWidget {
  const FeedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: SectionTitle(icon: Icons.people, title:  'Community Alerts')),
          VerifiedBadge(),
        ],
      ),
    );
  }
}

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, size: 10, color: Color(0xFF2563EB)),
          SizedBox(width: 4),
          Text('verification system', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}