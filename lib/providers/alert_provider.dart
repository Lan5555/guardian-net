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
      await sendSmsToAll(message!, communityId, context);
      notifyListeners();
    } else {
      if (kDebugMode) {
        print(res.message);
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendSmsToAll(
    String message,
    int communityId,
    BuildContext context,
  ) async {
    final payload = {"message": message};
    final res = await _service.sendBulkSms(communityId, payload);
    if (res.success) {
      notifyListeners();
    } else {
      showToast(context, res.message);
    }
  }

  Future<void> triggerPanic(BuildContext context) async {
    final user = context.read<SessionProvider>().user;
    if (user == null) return;
    await sendNewUserAlert(
      'PANIC',
      message: 'PANIC Emergency has been reported in your area.',
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
    VoidCallback? callback,
  }) async {
    isLoading = true;
    final user = context.read<SessionProvider>().user;
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
      await sendSmsToAll(
        'Emergency Alert successfully confirmed.',
        user!.communityId!,
        context,
      );
      if (callback != null) {
        callback();
      }
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
    final user = context.read<SessionProvider>().user;
    if (res.success) {
      isLoading = false;
      //showFeedBack(context, res.message);
      await sendSmsToAll(
        'Emergency Alert flagged as false',
        user!.communityId!,
        context,
      );
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      showFeedBack(context, res.message, isError: true);
    }
  }
}
