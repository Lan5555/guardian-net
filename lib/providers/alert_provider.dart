// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_net/helpers/helpers.dart';
import 'package:guardian_net/models/alert_model.dart';
import 'package:guardian_net/modules/home_screen/services/home_screen_service.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';

class AlertProvider extends ChangeNotifier {
  final List<AlertModel> alerts = [];
  final HomeScreenService _service = HomeScreenService();
  bool isLoading = false;

  void addAlert(AlertModel alert) {
    alerts.insert(0, alert);
    notifyListeners();
  }

  void removeAlert(AlertModel targetId) {
    alerts.removeWhere((alert) => alert.id == targetId.id);
    notifyListeners();
  }

  Future<void> sendNewUserAlert(
    String type, {
    required int communityId,
    int? userId,
    String? userName,
    required BuildContext context,
    String? message,
  }) async {
    isLoading = true;
    notifyListeners();
    Position userCoordinates = context.read<SessionProvider>().userLocation!;
    final location = await context.read<SessionProvider>().getLocationName(
      userCoordinates,
    );
    final data = {
      'subject': type,
      'title': '$type Alert',
      'message':
          message ??
          '${type.toLowerCase() == 'robbery' ? 'An' : 'A'} $type has been reported in your area.',
      'community_id': communityId,
      'location': location,
      'reporter': userName ?? 'Anonymous',
      'reported_id': userId ?? 0,
    };

    final res = await _service.sendAlert(data);
    if (res.success) {
      isLoading = false;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print(res.message);
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> triggerPanic(BuildContext context) async {
    final user = context.read<SessionProvider>().user;
    if (user == null) return;
    await sendNewUserAlert(
      'PANIC',
      communityId: user.communityId!,
      userId: user.id,
      userName: user.name,
      context: context,
    );
  }

  Future<void> verifyCommunityAlert(
    int reportedId,
    int alertId,
    BuildContext context, {
    StateSetter? setModalState,
  }) async {
    isLoading = true;
    if (setModalState != null) {
      setModalState.call(() {});
    }
    notifyListeners();
    final res = await _service.comfirmAlert(reportedId, alertId);
    if (res.success) {
      isLoading = false;
      final alertIndex = alerts.indexWhere((alert) => alert.id == alertId);
      if (alertIndex != -1) {
        alerts[alertIndex].copyWith(isVerified: true);
      }
      showFeedBack(context, res.message);
      if (setModalState != null) {
        setModalState.call(() {});
      }
      notifyListeners();
    } else {
      isLoading = false;
      if (setModalState != null) {
        setModalState.call(() {});
      }
      showFeedBack(context, res.message, isError: true);
      notifyListeners();
    }
  }

  Future<void> flagAlertAsFalse(int alertId, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final res = await _service.flagAsFalse(alertId);
    if (res.success) {
      isLoading = false;
      //showFeedBack(context, res.message);
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      showFeedBack(context, res.message, isError: true);
    }
  }
}
