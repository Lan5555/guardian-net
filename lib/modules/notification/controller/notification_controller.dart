import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ⭐ MUST be a top-level function (outside any class).
/// This runs in a separate isolate when the app is in background/terminated.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.data}');
  await NotificationController.showFromRemoteMessage(message);
}

class NotificationController extends ChangeNotifier {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Android notification channel ID (must match when creating channel and displaying notification)
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDesc = 'Used for custom sound notifications';

  /// Initialize notification service + Firebase Messaging
  static Future<void> init() async {
    // ---- Local notifications setup ----
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createAndroidChannel();

    // ---- Firebase Messaging setup ----
    await _initFirebaseMessaging();
  }

  /// Configure FCM listeners and register background handler
  static Future<void> _initFirebaseMessaging() async {
    // 1. Request permission (Android 13+)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Register the background handler
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // 3. Foreground messages — FCM won't show a notification automatically
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message: ${message.data}');
      showFromRemoteMessage(message);
    });

    // 4. User tapped a notification while app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped (background): ${message.data}');
      _handleNotificationNavigation(message);
    });

    // 5. App was launched from a terminated state via a notification tap
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App launched from notification: ${initialMessage.data}');
      _handleNotificationNavigation(initialMessage);
    }
  }

  /// Callback when a local notification is tapped (foreground display)
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        debugPrint('Parsed payload: $data');
        // TODO: navigate using navigatorKey
      } catch (e) {
        debugPrint('Failed to parse payload: $e');
      }
    }
  }

  /// Navigate based on the message — customize to your routing
  static void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    debugPrint('Navigate with data: $data');
    // Example:
    // navigatorKey.currentState?.pushNamed('/alert', arguments: data);
  }

  /// ⭐ Get the FCM token — send this to your server
  static Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }

  /// Listen for token refreshes and update your server
  static void listenToTokenRefresh(
    Future<void> Function(String token) onNewToken,
  ) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM token refreshed: $newToken');
      onNewToken(newToken);
    });
  }

  /// Convert a RemoteMessage into a local notification with custom sound
  static Future<void> showFromRemoteMessage(RemoteMessage message) async {
    final data = message.data;

    // Server sends `title` and `message` (see NestJS payload)
    final title = data['title'] ?? message.notification?.title ?? 'New Alert';
    final body = data['message'] ??
        message.notification?.body ??
        'An alert has been reported.';

    // Prefer the alert ID from the payload; fall back to a positive timestamp
    final alertId = int.tryParse(data['id'] ?? '') ?? 0;
    final notificationId = alertId > 0
        ? alertId
        : DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await showNotification(
      id: notificationId,
      title: title,
      body: body,
      payload: jsonEncode(data),
    );
  }

  /// Create Android notification channel (with custom sound)
  static Future<void> _createAndroidChannel() async {
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('warning'),
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final existingChannels = await androidPlugin?.getNotificationChannels();
    final channelExists =
        existingChannels?.any((ch) => ch.id == _channelId) ?? false;

    if (!channelExists) {
      await androidPlugin?.createNotificationChannel(androidChannel);
    }
  }

  /// Request notification permission (Android 13+)
  static Future<void> requestPermissions() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  /// Display notification with custom sound
  static Future<void> showNotification({
    int id = 0,
    String title = 'Notification Title',
    String body = 'This is a notification with custom sound',
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('warning'),
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id:id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}