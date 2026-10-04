import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardian_net/modules/notification/controller/notification_controller.dart';
import 'package:guardian_net/modules/onboarding/views/onboarding_screen.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:guardian_net/providers/socket_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationController.init();

  // // ⭐ Get the token and register it with your server
  // final token = await NotificationController.getToken();
  // if (token != null) {
  //   // await yourApi.registerFcmToken(token);
  // }

  // NotificationController.listenToTokenRefresh((newToken) async {
  //   // await yourApi.registerFcmToken(newToken);
  // });
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocketProvider()),
        ChangeNotifierProvider(create: (context) => AlertProvider()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
      ],
      child: const GuardianNetApp(),
    ),
  );
}

class GuardianNetApp extends StatelessWidget {
  const GuardianNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuardianNet',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
