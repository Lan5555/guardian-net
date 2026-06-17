// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardian_net/helpers/helpers.dart';
import 'package:guardian_net/home/layout.dart';
import 'package:guardian_net/models/community_model.dart';
import 'package:guardian_net/modules/admin/views/admin_screen.dart';
import 'package:guardian_net/modules/auth/services/auth_service.dart';
import 'package:guardian_net/service/core_service.dart';

class AuthController extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool agreeToTerms = false;
  bool isPasswordVisible = false;
  CommunityModel? selectedCommunity;
  List<CommunityModel> communities = [];
  bool isLoading = false;

  final AuthService _service = AuthService();
  final BuildContext context;

  AuthController({required this.context});

  Future<void> handleAdminLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showToast(context, "Please fill in all fields", isError: true);
      return;
    }

    isLoading = true;
    notifyListeners();

    final payload = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final res = await _service.loginAdmin(payload);

    isLoading = false;
    notifyListeners();

    if (res.success) {
      showToast(context, "Admin Access Granted");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } else {
      showToast(context, res.message, isError: true);
    }
  }

  Future<void> handleUserLogin() async {
    isLoading = true;
    notifyListeners();

    final payload = {
      'email': loginEmailController.text,
      'password': loginPasswordController.text,
    };

    final res = await _service.loginUser(payload);

    if (res.success) {
      showToast(context, res.message);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
      isLoading = false;
      notifyListeners();
    } else {
      showToast(context, res.message, isError: true);
    }
  }

  Future<void> handleRegister() async {
    isLoading = true;
    notifyListeners();


    if (registerPasswordController.text != confirmPasswordController.text) {
      showToast(context, 'Passwords do not match', isError: true);
      return;
    }
    if (!agreeToTerms) {
      showToast(
        context,
        'Please agree to the terms and conditions',
        isError: true,
      );
      return;
    }

    final payload = {
      'name': nameController.text,
      'email': registerEmailController.text,
      'password': registerEmailController.text,
      'community_id': selectedCommunity?.id ?? 0,
    };
    NetResponse res = await _service.registerUser(payload);
    if (res.success) {
      showToast(context, res.message);
      isLoading = false;
      notifyListeners();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      showToast(context, res.message, isError: true);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCommunities() async {
    NetResponse res = await _service.fetchAllCommunities();
    if (res.success) {
      final List<dynamic> data = res.data;

      communities = data.map((json) => CommunityModel.fromJson(json)).toList();
      notifyListeners();
    } else {
      showToast(context, res.message, isError: true);
      if (kDebugMode) {
        print(res.message);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
