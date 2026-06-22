// lib/modules/auth/views/register.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:guardian_net/helpers/helpers.dart';
import 'package:guardian_net/models/community_model.dart';
import 'package:guardian_net/modules/auth/controllers/auth_controller.dart';
import 'package:guardian_net/modules/auth/views/login.dart';
import 'package:guardian_net/modules/onboarding/controller/onboarding_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AuthController _controller;
  late Onboardingcontroller _onboardingcontroller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AuthController(context: context);
    _onboardingcontroller = Onboardingcontroller(context: context);
    _controller.addListener(_onControllerChanged);
    _controller.fetchCommunities();
    if (!_onboardingcontroller.hasLoaded) {
      _onboardingcontroller.pingServer();
    }
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Enhanced header text
              const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create your\nGuardian Account',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join the network of verified community responders.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
              // Form fields with enhanced styling
              _buildTextField(
                controller: _controller.nameController,
                label: 'Full Name',
                hint: 'Alex Morgan',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controller.registerEmailController,
                label: 'Email Address',
                hint: 'alex@example.com',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controller.registerPasswordController,
                label: 'Password',
                hint: 'Create a strong password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controller.confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controller.phoneController,
                label: 'Phone Number',
                hint: '09010000000',
                icon: Icons.phone,
                isPassword: false,
              ),
              const SizedBox(height: 24),
              // Enhanced community dropdown
              const Text(
                'Primary Community',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CommunityModel>(
                    value: _controller.selectedCommunity,
                    hint: const Text(
                      'Select Community',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF94A3B8),
                    ),
                    items: _controller.communities.map((CommunityModel value) {
                      return DropdownMenuItem<CommunityModel>(
                        value: value,
                        child: Text(
                          value.name,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _controller.selectedCommunity = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'You will receive alerts based on this location.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Enhanced terms checkbox
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _controller.agreeToTerms,
                      onChanged: (val) => setState(
                        () => _controller.agreeToTerms = val ?? false,
                      ),
                      activeColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: const BorderSide(
                        color: Color(0xFFCBD5E1),
                        width: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'I agree to the Community Safety Guidelines and Privacy Policy',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Enhanced create account button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: !_onboardingcontroller.hasLoaded
                      ? () {
                          showToast(context, 'Server still loading...');
                        }
                      : (_controller.agreeToTerms
                            ? _controller.handleRegister
                            : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _onboardingcontroller.hasLoaded
                        ? const Color(0xFF0F172A)
                        : Colors.grey.shade400,
                    disabledBackgroundColor: const Color(0xFFE2E8F0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    shadowColor: const Color(0xFF0F172A).withValues(alpha: .2),
                  ),
                  child: _controller.isLoading
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
                              'Create Account',
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
              const SizedBox(height: 24),
              // Enhanced sign in section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: const Text(
                      'Sign In',
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
          controller: controller,
          obscureText: isPassword && !_controller.isPasswordVisible,
          style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _controller.isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: const Color(0xFF94A3B8),
                    ),
                    onPressed: () => setState(
                      () => _controller.isPasswordVisible =
                          !_controller.isPasswordVisible,
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
               borderSide: BorderSide(width: 0.1)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
               borderSide: BorderSide(width: 0.1)
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
        ),
      ],
    );
  }
}
