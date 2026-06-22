import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_net/modules/auth/views/login.dart';
import 'package:guardian_net/modules/onboarding/controller/onboarding_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Onboardingcontroller controller;
  
  @override
  void initState() {
    super.initState();
    controller = Onboardingcontroller(context: context);
    controller.addListener(_onControllerChanged);
    controller.checkOnBoardingStatus(context);
    controller.pingServer();
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
    controller.removeListener(_onControllerChanged);
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        await pref.setString('has_viewed', 'true');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.withValues(alpha: .7),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              ),

              // Page View
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: const [
                    OnboardingPage(
                      title: 'Instant Emergency\nAlerts',
                      description:
                          'Real-time notifications when accidents occur. Every second counts, and Guard Net keeps you informed instantly.',
                      icon: Icons.notifications_active_rounded,
                      color: Color(0xFFEF4444),
                    ),
                    OnboardingPage(
                      title: 'Smart Accident\nDetection',
                      description:
                          'Advanced sensors detect crashes automatically. Quick response protocols help save lives and minimize damage.',
                      icon: Icons.sensors_rounded,
                      color: Color(0xFFF59E0B),
                    ),
                    OnboardingPage(
                      title: 'Help on The\nWay',
                      description:
                          'Share your exact location with emergency services. Get live updates and peace of mind knowing help is coming.',
                      icon: Icons.location_on_rounded,
                      color: Color(0xFF3B82F6),
                    ),
                  ],
                ),
              ),

              // Bottom section with glass effect
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.grey.withValues(alpha: .05),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Custom page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: _currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF0A0E1A)
                                : Colors.grey.withValues(alpha: .4),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: _currentPage == index
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF0A0E1A).withValues(alpha: .2),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action buttons row
                    Row(
                      children: [
                        // Login button (outlined)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final pref =
                                  await SharedPreferences.getInstance();
                              await pref.setString('has_viewed', 'true');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0A0E1A),
                              side: BorderSide(
                                color: const Color(0xFF0A0E1A).withValues(alpha: .2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Get Started button (filled)
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_currentPage < 2) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                );
                              } else {
                                final pref =
                                    await SharedPreferences.getInstance();
                                await pref.setString('has_viewed', 'true');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A0E1A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: Text(
                              _currentPage == 2 ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container with glow
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: .1),
                  color.withValues(alpha: .02),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: .2), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: .15),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, size: 72, color: color),
          ),
          const SizedBox(height: 56),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0A0E1A),
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey.withValues(alpha: .8),
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}