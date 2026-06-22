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
  //final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _authController = AuthController(context: context);
    _onboardingcontroller = Onboardingcontroller(context: context);
    _authController.addListener(_onControllerChanged);
    _onboardingcontroller.addListener(_onControllerChanged);
    _onboardingcontroller.pingServer();
    _authController.checkIfContainsCredentials();
  }

  // Extracted listener method
  void _onControllerChanged() {
    // Check if widget is still mounted before calling setState
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    _authController.removeListener(_onControllerChanged);
    _onboardingcontroller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 44,
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
          ),
          backgroundColor: const Color(0xFF0F172A),
          elevation: 2,
          child: const Icon(
            Icons.admin_panel_settings,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Enhanced logo with gradient
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: .3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.shield, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 32),
              // Enhanced welcome text
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sign in to\nGuardianNet',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Secure your community with verified alerts.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
              // Form with enhanced styling
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                      hint: 'Enter your password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Forgot password with better styling
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Enhanced sign in button
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
                    backgroundColor: _onboardingcontroller.hasLoaded
                        ? const Color(0xFF0F172A)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    shadowColor: const Color(0xFF0F172A).withValues(alpha: .2),
                  ),
                  child: _authController.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Divider with "or" text
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey.withValues(alpha: .3),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey.withValues(alpha: .6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.withValues(alpha: .3),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Enhanced sign up section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          //focusNode: _focusNode,
          controller: controller,
          obscureText: isPassword && !_authController.isPasswordVisible,
          style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
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
            hintStyle: TextStyle(
              color: Colors.grey.withValues(alpha: .5),
              fontSize: 15,
            ),
            prefixIcon: Icon(icon, size: 22, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(width: 0.1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(width: 0.1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            if (label == 'Email Address' && !value.contains('@')) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }
}
