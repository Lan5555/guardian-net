import 'package:flutter/material.dart';
import 'package:guardian_net/modules/history/views/history_screen.dart';
import 'package:guardian_net/modules/home_screen/views/home_screen.dart';
import 'package:guardian_net/modules/profile/views/profile_screen.dart';
import 'package:guardian_net/modules/trust/views/trust_screen.dart';
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
      _isSidebarOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SizedBox.expand(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 243, 241, 241),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_isSidebarOpen ? 40 : 0),
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
                        const SizedBox(height: 50),
                        // App Header
                        _buildAppHeader(_isSidebarOpen),
                        // Main Screens
                        Expanded(
                          child: IndexedStack(
                            index: _currentIndex,
                            children: _screens,
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: GestureDetector(
          onTap: _toggleSidebar,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isSidebarOpen ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _isSidebarOpen ? Icons.close : Icons.menu,
              size: 20,
              color: _isSidebarOpen ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
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
    padding: EdgeInsets.only(
        left: isSidebarOpen ? 10 : 24, right: 24, top: 8, bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'GuardianNet',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -1),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(6)),
                  child: const Text('LIVE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900)),
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<SessionProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFF8FAFC), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha:0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF334155)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: Color(0xFFFBBF24), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('COMMUNITY REPUTATION',
                            style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5)),
                        Row(
                          children: [
                            Text('${provider.user?.reputationCount ?? 0}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A))),
                            const SizedBox(width: 4),
                            const Text('Trust Points',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: Color(0xFFCBD5E1)),
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