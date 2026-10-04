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

    // ⭐ Null check instead of `!` — fixes the crash
    final userCoordinates = context.read<SessionProvider>().userLocation;
    if (userCoordinates == null) {
      isLoading = false;
      notifyListeners();
      showFeedBack(
        context,
        'Location unavailable. Please enable GPS and try again.',
        isError: true,
      );
      return;
    }

    final location = await context.read<SessionProvider>().getLocationName(
      userCoordinates,
    );

    // ⭐ Compute the fallback message once and reuse it
    final resolvedMessage = message ??
        '${type.toLowerCase() == 'robbery' ? 'An' : 'A'} $type has been reported in your area.';

    final data = {
      'subject': type,
      'title': '$type Alert',
      'message': resolvedMessage,
      'community_id': communityId,
      'location': location,
      'reporter': userName ?? 'Anonymous',
      'reported_id': userId ?? 0,
    };

    final res = await _service.sendAlert(data);
    isLoading = false;

    if (res.success) {
      // ⭐ Use the resolved message instead of `message!`
      await sendSmsToAll(resolvedMessage, communityId, context);
    } else {
      if (kDebugMode) {
        print(res.message);
      }
    }
    notifyListeners();
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

    // ⭐ Guard against null communityId
    final communityId = user.communityId;
    if (communityId == null) {
      showFeedBack(
        context,
        'No community is assigned to your account.',
        isError: true,
      );
      return;
    }

    await sendNewUserAlert(
      'PANIC',
      message: 'PANIC Emergency has been reported in your area.',
      communityId: communityId,
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

    // ⭐ Guard against null user / communityId
    if (user == null || user.communityId == null) {
      isLoading = false;
      notifyListeners();
      showFeedBack(
        context,
        'Session expired. Please log in again.',
        isError: true,
      );
      return;
    }

    if (setModalState != null) {
      setModalState.call(() {});
    }
    notifyListeners();

    final res = await _service.comfirmAlert(reportedId, alertId);
    isLoading = false;

    if (res.success) {
      final alertIndex = alerts.indexWhere((alert) => alert.id == alertId);
      if (alertIndex != -1) {
        alerts[alertIndex] = alerts[alertIndex].copyWith(isVerified: true);
      }
      showFeedBack(context, res.message);
      await sendSmsToAll(
        'Emergency Alert successfully confirmed.',
        user.communityId!,
        context,
      );
      if (callback != null) {
        callback();
      }
    } else {
      showFeedBack(context, res.message, isError: true);
    }

    if (setModalState != null) {
      setModalState.call(() {});
    }
    notifyListeners();
  }

  Future<void> flagAlertAsFalse(int alertId, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final user = context.read<SessionProvider>().user;

    // ⭐ Guard against null user / communityId
    if (user == null || user.communityId == null) {
      isLoading = false;
      notifyListeners();
      showFeedBack(
        context,
        'Session expired. Please log in again.',
        isError: true,
      );
      return;
    }

    final res = await _service.flagAsFalse(alertId);
    isLoading = false;

    if (res.success) {
      await sendSmsToAll(
        'Emergency Alert flagged as false',
        user.communityId!,
        context,
      );
    } else {
      showFeedBack(context, res.message, isError: true);
    }
    notifyListeners();
  }
}