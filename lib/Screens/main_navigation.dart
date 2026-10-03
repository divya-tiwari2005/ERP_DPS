import 'package:flutter/material.dart';
import '../Services/storage_service.dart';
import 'attendance_screen.dart';
import 'auth/login__screens.dart';
import 'home.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      const _AcademicsScreen(),
      const AttendanceScreen(),
      const _ProfileScreen(),
    ];
  }

  void _selectNavigationItem(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      drawer: _buildDrawer(),

      // ---------------------------------------------------------------
      // BOTTOM NAVIGATION
      // ---------------------------------------------------------------
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        backgroundColor: const Color(0xFF173B5E),

        indicatorColor: const Color(0xFFE39B2E),

        elevation: 8,

        height: 68,

        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: Color(0xFF173B5E),
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.menu_book_rounded,
              color: Color(0xFF173B5E),
            ),
            label: 'Academics',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.fact_check_outlined,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.fact_check_rounded,
              color: Color(0xFF173B5E),
            ),
            label: 'Attendance',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: Color(0xFF173B5E),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,

      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                22,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF173B5E),
                    Color(0xFF0F2942),
                  ],
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFF173B5E),
                      size: 28,
                    ),
                  ),

                  SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'School ERP',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    title: 'Home',
                    index: 0,
                    selected: _currentIndex == 0,
                  ),

                  _buildAcademicsExpansion(),

                  _buildDrawerItem(
                    icon: Icons.fact_check_outlined,
                    title: 'Attendance',
                    index: 2,
                    selected: _currentIndex == 2,
                  ),

                  _buildDrawerItem(
                    icon: Icons.event_available_outlined,
                    title: 'Leave',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Fees',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.directions_bus_outlined,
                    title: 'Transport',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.campaign_outlined,
                    title: 'Notices',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.forum_outlined,
                    title: 'Communication',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.local_library_outlined,
                    title: 'Library',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.photo_library_outlined,
                    title: 'Events & Gallery',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.description_outlined,
                    title: 'Documents',
                    onTap: () {},
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: Divider(
                      height: 1,
                      color: Color(0xFFE1E5E9),
                    ),
                  ),

                  _buildDrawerItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Profile',
                    index: 3,
                    selected: _currentIndex == 3,
                  ),

                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    onTap: () {},
                  ),

                  _buildDrawerItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    iconColor: const Color(0xFFD9534F),
                    titleColor: const Color(0xFFD9534F),
                    onTap: () {
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicsExpansion() {
    return ExpansionTile(
      leading: const Icon(
        Icons.menu_book_outlined,
        color: Color(0xFF246BCE),
      ),

      title: const Text(
        'Academics',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF17202A),
        ),
      ),

      tilePadding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),

      childrenPadding: const EdgeInsets.only(
        left: 54,
        right: 12,
      ),

      children: [
        _buildSubItem(
          icon: Icons.assignment_outlined,
          title: 'Homework',
        ),

        _buildSubItem(
          icon: Icons.schedule_outlined,
          title: 'Timetable',
        ),

        _buildSubItem(
          icon: Icons.menu_book_outlined,
          title: 'Syllabus',
        ),

        _buildSubItem(
          icon: Icons.event_note_outlined,
          title: 'Exams',
        ),

        _buildSubItem(
          icon: Icons.grade_outlined,
          title: 'Results',
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    int? index,
    bool selected = false,
    VoidCallback? onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      dense: true,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),

      leading: Icon(
        icon,
        size: 22,
        color: selected
            ? const Color(0xFF087F70)
            : iconColor ?? const Color(0xFF66717D),
      ),

      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight:
          selected ? FontWeight.w800 : FontWeight.w600,
          color: selected
              ? const Color(0xFF087F70)
              : titleColor ?? const Color(0xFF17202A),
        ),
      ),

      selected: selected,

      selectedTileColor: const Color(0xFFEAF5F3),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      onTap: onTap ??
          (index != null
              ? () => _selectNavigationItem(index)
              : null),
    );
  }

  Widget _buildSubItem({
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      dense: true,

      leading: Icon(
        icon,
        size: 18,
        color: const Color(0xFF66717D),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF17202A),
          fontWeight: FontWeight.w500,
        ),
      ),

      onTap: () {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$title will be available soon.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  void _showLogoutDialog() {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),

          content: const Text(
            'Are you sure you want to logout?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD9534F),
              ),

              onPressed: () async {
                await StorageService.clearToken();

                if (!mounted) return;

                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const LoginScreen(),
                  ),
                      (route) => false,
                );
              },

              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// TEMPORARY ACADEMICS SCREEN
// -----------------------------------------------------------------------------

class _AcademicsScreen extends StatelessWidget {
  const _AcademicsScreen();

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderScreen(
      title: 'Academics',
      icon: Icons.menu_book_rounded,
      color: Color(0xFF246BCE),
      message: 'Academic modules will appear here.',
    );
  }
}

// -----------------------------------------------------------------------------
// TEMPORARY PROFILE SCREEN
// -----------------------------------------------------------------------------

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderScreen(
      title: 'Profile',
      icon: Icons.person_rounded,
      color: Color(0xFF7652B8),
      message: 'Your profile will appear here.',
    );
  }
}

// -----------------------------------------------------------------------------
// PLACEHOLDER SCREEN
// -----------------------------------------------------------------------------

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String message;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF17202A),
            fontWeight: FontWeight.w800,
          ),
        ),

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Color(0xFF17202A),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [
              Container(
                width: 72,
                height: 72,

                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 34,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF17202A),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF66717D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}