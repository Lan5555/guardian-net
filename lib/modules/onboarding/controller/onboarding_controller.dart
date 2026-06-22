import 'package:flutter/material.dart';
import 'package:guardian_net/modules/auth/views/login.dart';
import 'package:guardian_net/modules/onboarding/service/onboarding_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboardingcontroller extends ChangeNotifier {
  BuildContext context;
  Onboardingcontroller({required this.context});
  bool hasLoaded = false;
  final OnboardingService _service = OnboardingService();
  void checkOnBoardingStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasViewed = prefs.getString('has_viewed');
    if (hasViewed == 'true') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void> pingServer() async {
    final res = await _service.pingServer();
    if (res.success) {
      hasLoaded = true;
      notifyListeners();
    } else {
      hasLoaded = false;
      notifyListeners();
    }
  }
}
