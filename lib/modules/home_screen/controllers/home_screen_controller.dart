// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:guardian_net/modules/home_screen/services/home_screen_service.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreenController extends ChangeNotifier {
  final BuildContext context;
  HomeScreenController({required this.context});
  final _service = HomeScreenService();
  bool isLoading = false;

  Future<void> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    context.read<SessionProvider>().startTracking();
  }

  Future<void> sendAlert(dynamic data) async {
    isLoading = true;
    notifyListeners();
    final res = await _service.sendAlert(data);
    if (res.success) {
      context.read<AlertProvider>().addAlert(data);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
  
}
