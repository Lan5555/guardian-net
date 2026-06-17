import 'package:flutter/material.dart';
import 'package:guardian_net/modules/history/views/history_screen.dart';
import 'package:guardian_net/modules/home_screen/views/home_screen.dart';
import 'package:guardian_net/modules/profile/views/profile_screen.dart';
import 'package:guardian_net/modules/trust/views/trust_screen.dart';
import 'package:guardian_net/providers/app_state_provider.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:guardian_net/widgets/bottom_nav_bar.dart';
import 'package:guardian_net/widgets/sidebar.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int _currentIndex = 0;
  bool _isSidebarOpen = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const TrustScreen(),
    const ProfileScreen(),
  ];

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF1E293B),
      body: Center(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
            color: Colors.white,
            
          ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Row(
                children: [
                  // Sidebar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isSidebarOpen ? 60 : 0,
                    child: Sidebar(
                      isOpen: _isSidebarOpen,
                      currentIndex: _currentIndex,
                      onItemSelected: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  // Main Content
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        // App Header
                        _buildAppHeader(_isSidebarOpen),
                        // Main Screens
                        Expanded(
                          child: IndexedStack(
                            index: _currentIndex,
                            children: _screens,
                          ),
                        ),
                        // Bottom Navigation
                        
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: _toggleSidebar,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.menu, size: 18, color: Color(0xFF0F172A)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  
  Widget _buildAppHeader(bool isSidebarOpen) {
    return Padding(
      padding: EdgeInsets.only(left: isSidebarOpen ? 10 : 24, right: 24, top: 8, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GuardianNet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const Text(
            'neighbourhood emergency · community verified',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          Consumer<SessionProvider>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.wind_power, color: Color(0xFF38BDF8), size: 16),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Guardian Reputation', style: TextStyle(fontSize: 10, color: Color(0xFF0369A1), fontWeight: FontWeight.w700)),
                        Row(
                          children: [
                            Text('${provider.user?.reputationCount}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                            const SizedBox(width: 4),
                            const Text('XP', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}