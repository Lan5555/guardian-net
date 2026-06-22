import 'package:flutter/material.dart';
import 'package:guardian_net/helpers/helpers.dart';
import 'package:guardian_net/modules/auth/controllers/auth_controller.dart';
import 'package:guardian_net/modules/auth/views/forgot_password.dart';
import 'package:guardian_net/modules/auth/views/register.dart';
import 'package:guardian_net/modules/auth/views/admin_auth.dart';
import 'package:guardian_net/modules/onboarding/controller/onboarding_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthController _authController;
  late Onboardingcontroller _onboardingcontroller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authController = AuthController(context: context);
    _onboardingcontroller = Onboardingcontroller(context: context);
    _authController.addListener(() {
      setState(() {});
    });
    _onboardingcontroller.addListener(() {
      setState(() {});
    });
    _onboardingcontroller.pingServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 44,
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
          ),
          backgroundColor: const Color(0xFF0F172A),
          elevation: 2,
          icon: const Icon(
            Icons.admin_panel_settings,
            color: Colors.white,
            size: 18,
          ),
          label: const Text(
            "Admin Portal",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.shield, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to\nGuardianNet',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Secure your community with verified alerts.',
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    _buildTextField(
                      controller: _authController.loginEmailController,
                      label: 'Email Address',
                      hint: 'alex@example.com',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _authController.loginPasswordController,
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: !_onboardingcontroller.hasLoaded
                      ? () {
                          showToast(context, 'Server still loading...');
                        }
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _authController.handleUserLogin();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _onboardingcontroller.hasLoaded ?  const Color(0xFF0F172A) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _authController.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !_authController.isPasswordVisible,
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _authController.isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: const Color(0xFF94A3B8),
                    ),
                    onPressed: () => setState(
                      () => _authController.isPasswordVisible =
                          !_authController.isPasswordVisible,
                    ),
                  )
                : null,
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            return null;
          },
        ),
      ],
    );
  }
}
