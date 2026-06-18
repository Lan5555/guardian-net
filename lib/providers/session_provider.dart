import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_net/models/user_model.dart';
import 'package:share_plus/share_plus.dart';

class SessionProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  StreamSubscription<Position>? locationStream;
  Position? userLocation;

  void setUser(UserModel? user) {
    _user = user;
    _isLoggedIn = user != null;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void startTracking() {
    locationStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          userLocation = position;
          notifyListeners();
        });
  }

  Future<String> getLocationName(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;

    String locationName =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

    return locationName;
  }

  Future<String> createGoogleMapsLink() async {
    Position pos = await Geolocator.getCurrentPosition();

    final url =
        "https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}";

    return url;
  }

  Future<void> shareLocation() async {
    Position pos = await Geolocator.getCurrentPosition();

    final message =
        "Here is my location:\n"
        "https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}";

    SharePlus.instance.share(ShareParams(text: message));
  }

  @override
  void dispose() {
    locationStream?.cancel();
    super.dispose();
  }
}
