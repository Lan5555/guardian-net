// lib/screens/trust_screen.dart
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:guardian_net/modules/trust/controller/trust_controller.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';

class TrustScreen extends StatefulWidget {
  const TrustScreen({super.key});

  @override
  State<TrustScreen> createState() => _TrustScreenState();
}

class _TrustScreenState extends State<TrustScreen> {
  late TrustController controller;

  @override
  void initState() {
    super.initState();
    controller = TrustController(context: context);
    controller.addListener(() => setState(() {}));
    controller.fetchCommunityData();
  }

  @override
  Widget build(BuildContext context) {
    return controller.isLoading
        ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          )
        : Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                const _TrustHeader(),
                const SizedBox(height: 24),
                _CommunityCard(controller: controller),
                const SizedBox(height: 24),
                const SectionTitle(
                  icon: Icons.shield_outlined,
                  title: 'Safety Protocol',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: const [
                      _GuidelineTile(
                        icon: Icons.verified_user_outlined,
                        title: 'Verification',
                        text:
                            'Always verify alerts before confirming to maintain network integrity.',
                      ),
                      _GuidelineTile(
                        icon: Icons.location_searching,
                        title: 'Active Tracking',
                        text:
                            'Keep location services active to ensure rapid response during SOS.',
                      ),
                      _GuidelineTile(
                        icon: Icons.gpp_good_outlined,
                        title: 'Trust Score',
                        text:
                            'Reporting false alarms impacts your community reputation score.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionTitle(
                  icon: Icons.sensors,
                  title: 'Network Infrastructure',
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(
                      child: _StatusItem(
                        icon: Icons.wifi_tethering,
                        color: Color(0xFF10B981),
                        title: 'Mesh Node',
                        status: 'Active',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatusItem(
                        icon: Icons.satellite_alt,
                        color: Color(0xFF2563EB),
                        title: 'GPS Sync',
                        status: 'Stable',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
  }
}

class _TrustHeader extends StatelessWidget {
  const _TrustHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Community Hub',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'View your local safety network and community.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0F172A)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final TrustController controller;
  const _CommunityCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, session, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.userCommunity?.name ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(
                              Icons.verified,
                              color: Color(0xFF3B82F6),
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Verified Safety Zone',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.qr_code_2, color: Colors.white70, size: 32),
                ],
              ),
              const SizedBox(height: 24),
              _StatRow(
                label: 'Primary Location',
                value: controller.userCommunity?.location ?? 'Detecting...',
              ),
              _StatRow(label: 'Community Status', value: 'Secure'),
              _StatRow(
                label: 'Trust Level',
                value:
                    'Level ${((session.user?.reputationCount ?? 0) / 100).floor() + 1}',
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your community is currently monitored by 24 active responders.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () => controller.showCommunityDetails(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _StatRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidelineTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _GuidelineTile({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF10B981)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String status;
  const _StatusItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
