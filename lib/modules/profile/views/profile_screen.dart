// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:guardian_net/modules/privacy/views/privacy_screen.dart';
import 'package:guardian_net/modules/profile/controller/profile_controller.dart';
import 'package:guardian_net/modules/trust/controller/trust_controller.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController controller;
  late TrustController trustController;

  @override
  void initState() {
    super.initState();
    controller = ProfileController(context: context);
    trustController = TrustController(context: context);
    controller.addListener(() => setState(() {}));
    trustController.addListener(() => setState(() {}));
    trustController.fetchCommunityData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, auth, child) {
       
        return Container(
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SectionTitle(
                icon: Icons.account_circle,
                title: 'Account Settings',
              ),
              const SizedBox(height: 16),
              _RfidCard(userName: auth.user?.name, communityName: trustController.userCommunity?.name),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x332563EB),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          (auth.user?.name?.isNotEmpty ?? false) ? auth.user!.name!.substring(0, 2).toUpperCase() : 'GN',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      auth.user?.name ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Verified Resident · ${trustController.userCommunity?.name ?? 'Loading...'}',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SettingsTile(
                onclick: () {},
                icon: Icons.emergency_share_outlined,
                label: 'Emergency Contacts',
                trailing: const Text(
                  '3 Active',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ),
              _SettingsTile(
                onclick: () {},
                icon: Icons.history_toggle_off_rounded,
                label: 'Alert History',
                trailing: const Icon(
                  Icons.chevron_right,
                  size: 12,
                  color: Color(0xFFCBD5E1),
                ),
              ),
              _SettingsTile(
                onclick: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacySecurityScreen(),
                  ),
                ),
                icon: Icons.shield,
                label: 'Privacy & Security',
                trailing: const Icon(
                  Icons.chevron_right,
                  size: 12,
                  color: Color(0xFFCBD5E1),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  _showToast(
                    context,
                    '🔒 Security protocols are up to date.',
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF334155)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_outlined, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'System Security Audit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
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

class _RfidCard extends StatelessWidget {
  final String? userName;
  final String? communityName;

  const _RfidCard({this.userName, this.communityName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: 20,
            top: 20,
            child: Icon(Icons.wifi, color: Colors.white54, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 40, height: 30, color: const Color(0xFFFBBF24)),
              const SizedBox(height: 15),
              const Text(
                'Digital Identity Token',
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
              const Text(
                'RFID-8829-XM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Linked to: ${userName ?? 'User'} · ${communityName ?? 'Precinct'}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final Function() onclick;
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onclick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: label == 'Emergency Contacts'
                    ? const Color(0xFFEFF6FF)
                    : (label == 'Alert History'
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 16,
                color: label == 'Emergency Contacts'
                    ? const Color(0xFF2563EB)
                    : (label == 'Alert History'
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF64748B)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
