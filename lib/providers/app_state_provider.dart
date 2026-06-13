// lib/providers/app_state_provider.dart
import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class AppStateProvider extends ChangeNotifier {
  int _trustScore = 82;
  int _userVerificationsGiven = 0;
  List<AlertModel> _alerts = [];
  List<AlertModel> _userReports = [];

  int get trustScore => _trustScore;
  int get userVerificationsGiven => _userVerificationsGiven;
  List<AlertModel> get alerts => _alerts;
  List<AlertModel> get userReports => _userReports;

  AppStateProvider() {
    _initSampleData();
  }

  void _initSampleData() {
    _alerts = [
      AlertModel(
        id: 'a1',
        type: 'Fire',
        description: 'Apartment fire near Oak St, smoke visible',
        timestamp: '5 min ago',
        location: 'Oak Street',
        verified: true,
        trustVotes: 14,
        reporter: 'neighbor1',
      ),
      AlertModel(
        id: 'a2',
        type: 'Robbery',
        description: 'Suspicious activity at gas station',
        timestamp: '18 min ago',
        location: 'Elm Road',
        verified: false,
        trustVotes: 2,
        reporter: 'userXYZ',
      ),
      AlertModel(
        id: 'a3',
        type: 'Accident',
        description: 'Car crash at intersection, injuries reported',
        timestamp: '32 min ago',
        location: 'Main & 10th',
        verified: true,
        trustVotes: 27,
        reporter: 'responderA',
      ),
    ];
    _userReports = [];
  }

  void verifyCommunityAlert(String alertId) {
    final alertIndex = _alerts.indexWhere((a) => a.id == alertId);
    if (alertIndex != -1 && !_alerts[alertIndex].verified) {
      _alerts[alertIndex] = _alerts[alertIndex].copyWith(verified: true);
      _trustScore = (_trustScore + 5).clamp(0, 100);
      _userVerificationsGiven++;
      notifyListeners();
    }
  }

  void flagAlertAsFalse(String alertId) {
    final alertIndex = _alerts.indexWhere((a) => a.id == alertId);
    if (alertIndex != -1 && !_alerts[alertIndex].verified) {
      _alerts.removeAt(alertIndex);
      _trustScore = (_trustScore - 3).clamp(0, 100);
      notifyListeners();
    }
  }

  void sendNewUserAlert(String alertType) {
    const locations = ['Maple Avenue', 'Cedar Street', 'Downtown Square', 'Riverside Dr'];
    final randomLoc = locations[DateTime.now().millisecondsSinceEpoch % locations.length];
    final newAlert = AlertModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      type: alertType,
      description: '$alertType reported by you! Urgent attention near $randomLoc.',
      timestamp: 'Just now',
      location: randomLoc,
      verified: false,
      trustVotes: 0,
      reporter: 'currentUser',
    );
    _alerts.insert(0, newAlert);
    _userReports.insert(0, newAlert);
    _trustScore = (_trustScore + 1).clamp(0, 100);
    notifyListeners();
  }

  void triggerPanic() {
    final panicAlert = AlertModel(
      id: 'panic_${DateTime.now().millisecondsSinceEpoch}',
      type: '🚨 PANIC',
      description: 'PANIC BUTTON ACTIVATED! Immediate help required, live location shared.',
      timestamp: 'Just now',
      location: 'Your Current Location (5th & Main)',
      verified: true,
      trustVotes: 99,
      reporter: 'currentUser',
    );
    _alerts.insert(0, panicAlert);
    _userReports.insert(0, panicAlert);
    _trustScore = (_trustScore + 2).clamp(0, 100);
    notifyListeners();
  }

  void boostTrustScore() {
    _trustScore = (_trustScore + 8).clamp(0, 100);
    notifyListeners();
  }
}