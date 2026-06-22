import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _SecurityHeader(),
          const SizedBox(height: 24),
          _ToggleTile(
            title: 'Incognito Reporting',
            subtitle: 'Hide your identity when submitting alerts',
            value: true,
            onChanged: (val) {},
          ),
          _ToggleTile(
            title: 'Biometric Lock',
            subtitle: 'Require FaceID/Fingerprint for Panic Button',
            value: false,
            onChanged: (val) {},
          ),
          _ToggleTile(
            title: 'Location Obfuscation',
            subtitle: 'Add 50m noise to non-emergency location sharing',
            value: true,
            onChanged: (val) {},
          ),
          const SizedBox(height: 24),
          const Text('DATA MANAGEMENT', 
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B), letterSpacing: 1)),
          const SizedBox(height: 12),
          _ActionTile(
            icon: Icons.delete_forever,
            label: 'Clear Activity History',
            color: Color(0xFFEF4444),
            onTap: () {},
          ),
          _ActionTile(
            icon: Icons.download,
            label: 'Export My Data',
            color: Color(0xFF2563EB),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SecurityHeader extends StatelessWidget {
  const _SecurityHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: Color(0xFF10B981), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('End-to-End Encrypted', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                Text('Your reports and location data are secured using AES-256.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleTile({required this.title, required this.subtitle, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFF2563EB),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color, size: 20),
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
      trailing: const Icon(Icons.chevron_right, size: 16),
    );
  }
}