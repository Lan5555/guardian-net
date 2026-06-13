// lib/screens/trust_screen.dart
import 'package:flutter/material.dart';

class TrustScreen extends StatelessWidget {
  const TrustScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionTitle(icon: Icons.people_alt, title: 'Your Community'),
          const SizedBox(height: 8),
          _CommunityCard(),
          const SizedBox(height: 16),
          const SectionTitle(icon: Icons.shield, title: 'Personal Impact'),
          const SizedBox(height: 8),
          Row(
            children: [
              _ImpactCard(icon: Icons.straighten, value: '1.2km', label: 'Active Radius'),
              const SizedBox(width: 12),
              _ImpactCard(icon: Icons.people, value: '24', label: 'Nearby Guardians'),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle(icon: Icons.bolt, title: 'Emergency Channels'),
          const SizedBox(height: 8),
          const _EmergencyChannel(
            icon: Icons.account_balance, color: Color(0xFF2563EB), title: 'Local Precinct', subtitle: 'Direct SMS Link Active',
          ),
          const SizedBox(height: 8),
          const _EmergencyChannel(
            icon: Icons.local_hospital, color: Color(0xFFEF4444), title: 'Medical Response', subtitle: 'Priority Dispatch Enabled',
          ),
          const SizedBox(height: 8),
          const _EmergencyChannel(
            icon: Icons.visibility, color: Color(0xFFF59E0B), title: 'Neighborhood Watch', subtitle: 'Community Verification Mesh',
          ),
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
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2563EB)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
      ],
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Downtown Central', style: TextStyle(fontSize: 16, color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                  Text('Sector 4 · Verified Zone', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StatRow(label: 'Total Members', value: '1,240 Guardians'),
          _StatRow(label: 'Safety Rating', value: 'Excellent (4.8/5)'),
          _StatRow(label: 'Active Patrols', value: '6 Units Live'),
          const SizedBox(height: 12),
          Row(
            children: [
              _Avatar('JD', const Color(0xFF3B82F6)),
              _Avatar('SK', const Color(0xFF10B981)),
              _Avatar('TR', const Color(0xFFF59E0B)),
              _Avatar('+1k', const Color(0xFF64748B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _Avatar(String text, Color color) {
    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

  Widget _StatRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF))),
        ],
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _ImpactCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF2563EB))),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}

class _EmergencyChannel extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _EmergencyChannel({required this.icon, required this.color, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }
}