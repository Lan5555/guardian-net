// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:guardian_net/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:guardian_net/widgets/channel_pills.dart';
import 'package:guardian_net/widgets/community_alert_lists.dart';
import 'package:guardian_net/widgets/custom_alert.dart';
import 'package:guardian_net/widgets/location_share_card.dart';
import 'package:guardian_net/widgets/panic_button.dart';
import 'package:guardian_net/widgets/quick_alert_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenController controller;
  @override
  void initState() {
    super.initState();
    controller = HomeScreenController(context: context);
    controller.addListener(() {
      setState(() {});
    });
    controller.requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const _WelcomeHeader(),
          const SizedBox(height: 20),
          const PanicWrapper(),
          const SizedBox(height: 24),
          SectionTitle(icon: Icons.bolt, title: 'Quick Alert'),
          const QuickAlertCards(),
          const SizedBox(height: 16),
          const ChannelPills(),
          const SizedBox(height: 24),
          SectionTitle(icon: Icons.edit_notifications, title: 'Custom Alert'),
          const CustomAlertInput(),
          const SizedBox(height: 24),
          const FeedHeader(),
          const CommunityAlertsList(),
          const SizedBox(height: 24),
          const LocationShareCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, session, _) {
        final name = session.user?.name?.split(' ').first ?? 'Guardian';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stay Safe, $name',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const Text(
              'Your community is active and monitored.',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        );
      },
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
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Emergency SOS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap for immediate assistance from nearby guardians',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    height: 1.2,
                  ),
                ),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
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
          Expanded(
            child: SectionTitle(icon: Icons.people, title: 'Community Alerts'),
          ),
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
          Text(
            'verification system',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
