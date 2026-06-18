import 'package:flutter/material.dart';
import 'package:guardian_net/models/community_model.dart';
import 'package:guardian_net/modules/auth/services/auth_service.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';

class TrustController extends ChangeNotifier {
  final BuildContext context;
  final AuthService _authService = AuthService();

  TrustController({required this.context});

  List<CommunityModel> communities = [];
  bool isLoading = false;
  CommunityModel? userCommunity;

  Future<void> fetchCommunityData() async {
    isLoading = true;
    notifyListeners();

    final res = await _authService.fetchAllCommunities();
    if (res.success) {
      final List<dynamic> data = res.data;
      communities = data.map((json) => CommunityModel.fromJson(json)).toList();
      
      final session = context.read<SessionProvider>();
      if (session.user?.communityId != null) {
        userCommunity = communities.firstWhere(
          (c) => c.id == session.user!.communityId,
          orElse: () => communities.first,
        );
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void showCommunityDetails() {
    if (userCommunity == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              userCommunity!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            _detailItem(Icons.location_on, 'Address', userCommunity!.location),
            _detailItem(Icons.explore, 'Coordinates', '${userCommunity!.latitude}, ${userCommunity!.longitude}'),
            const SizedBox(height: 24),
            const Text(
              'This community is a verified safety zone. All alerts sent within this perimeter are broadcasted to local responders and verified residents.',
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}