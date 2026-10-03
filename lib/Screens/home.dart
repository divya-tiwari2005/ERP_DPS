import 'package:flutter/material.dart';
import '../Services/auth_services.dart';
import '../Services/storage_service.dart';
import '../models/student_model.dart';
import '../widgets/common_app_header.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onMenuPressed;

  const HomeScreen({
    super.key,
    this.onMenuPressed,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StudentModel? student;
  bool isLoading = true;
  String? errorMessage;

  static const Color background = Color(0xFFF5F6F8);
  static const Color navy = Color(0xFF173B5E);
  static const Color darkNavy = Color(0xFF0F2942);
  static const Color teal = Color(0xFF087F70);
  static const Color darkTeal = Color(0xFF075E56);
  static const Color blue = Color(0xFF246BCE);
  static const Color darkBlue = Color(0xFF174D99);
  static const Color orange = Color(0xFFE58A18);
  static const Color darkOrange = Color(0xFFB96808);
  static const Color green = Color(0xFF16805B);
  static const Color darkGreen = Color(0xFF0D6043);
  static const Color purple = Color(0xFF7652B8);
  static const Color darkPurple = Color(0xFF54378A);
  static const Color red = Color(0xFFD9534F);
  static const Color textPrimary = Color(0xFF17202A);
  static const Color textSecondary = Color(0xFF66717D);
  static const Color border = Color(0xFFE1E5E9);

  @override
  void initState() {
    super.initState();
    _loadStudentProfile();
  }

  Future<void> _loadStudentProfile() async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication session not found.');
      }

      final profile = await ApiService.getMyProfile(token);

      if (!mounted) return;

      setState(() {
        student = profile;
        isLoading = false;
        errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            error.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: RefreshIndicator(
          color: teal,
          backgroundColor: Colors.white,
          onRefresh: _loadStudentProfile,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  22,
                  18,
                  32,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [

                      _buildSectionTitle(
                        'Today',
                        'Your school day at a glance',
                        teal,
                      ),

                      const SizedBox(height: 12),

                      _buildAttendanceCard(),

                      const SizedBox(height: 12),

                      _buildTimetableCard(),

                      const SizedBox(height: 30),

                      _buildSectionTitle(
                        'Learning',
                        'Stay on top of your academics',
                        orange,
                      ),

                      const SizedBox(height: 12),

                      _buildHomeworkCard(),

                      const SizedBox(height: 30),

                      _buildSectionTitle(
                        'School Updates',
                        'Important information from school',
                        purple,
                      ),

                      const SizedBox(height: 12),

                      _buildAnnouncementsCard(),

                      const SizedBox(height: 12),

                      _buildUpcomingExamsCard(),

                      const SizedBox(height: 30),

                      _buildSectionTitle(
                        'Quick Access',
                        'Frequently used modules',
                        blue,
                      ),

                      const SizedBox(height: 12),

                      _buildQuickAccessGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // header / app bar original , do not remove until everything is fixed
  // Widget _buildHeader() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(
  //       20,
  //       18,
  //       20,
  //       25,
  //     ),
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           navy,
  //           darkNavy,
  //         ],
  //       ),
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(30),
  //         bottomRight: Radius.circular(30),
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withValues(alpha: 0.12),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: IconButton(
  //                 onPressed: widget.onMenuPressed,
  //                 icon: const Icon(
  //                   Icons.menu_rounded,
  //                   color: Colors.white,
  //                 ),
  //                 tooltip: 'Menu',
  //               ),
  //             ),
  //
  //             const SizedBox(width: 12),
  //
  //             _buildProfileImage(),
  //
  //             const SizedBox(width: 14),
  //
  //             Expanded(
  //               child: isLoading
  //                   ? _buildLoadingHeader()
  //                   : Column(
  //                 crossAxisAlignment:
  //                 CrossAxisAlignment.start,
  //                 children: [
  //                   const Text(
  //                     'Good morning 👋',
  //                     style: TextStyle(
  //                       color: Colors.white70,
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //
  //                   const SizedBox(height: 3),
  //
  //                   Text(
  //                     student?.name ?? 'Student',
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 21,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //
  //                   const SizedBox(height: 4),
  //
  //                   Text(
  //                     student == null
  //                         ? 'Student profile'
  //                         : '${student!.className ?? ''}'
  //                         '${student!.sectionName != null ? ' - ${student!.sectionName}' : ''}'
  //                         '${student!.studentId.isNotEmpty ? '  •  ${student!.studentId}' : ''}',
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: const TextStyle(
  //                       color: Colors.white70,
  //                       fontSize: 12,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withValues(alpha: 0.12),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: IconButton(
  //                 onPressed: () {},
  //                 icon: const Icon(
  //                   Icons.notifications_none_rounded,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //         if (errorMessage != null) ...[
  //           const SizedBox(height: 12),
  //
  //           Container(
  //             width: double.infinity,
  //             padding: const EdgeInsets.all(10),
  //             decoration: BoxDecoration(
  //               color: red.withValues(alpha: 0.20),
  //               borderRadius: BorderRadius.circular(12),
  //               border: Border.all(
  //                 color: Colors.white.withValues(alpha: 0.10),
  //               ),
  //             ),
  //             child: Text(
  //               errorMessage!,
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHeader() {
    return CommonAppHeader(
      student: student,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onMenuPressed: widget.onMenuPressed,
      onNotificationPressed: () {
        // Notifications will be connected later.
      },
    );
  }

  Widget _buildProfileImage() {
    final imageUrl = student?.profileImageUrl;

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.95),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.person,
              size: 30,
              color: navy,
            );
          },
        )
            : const Icon(
          Icons.person,
          size: 30,
          color: navy,
        ),
      ),
    );
  }

  Widget _buildLoadingHeader() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildSectionTitle(
      String title,
      String subtitle,
      Color color,
      ) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            teal,
            darkTeal,
          ],
        ),
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: teal.withValues(alpha: 0.22),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Attendance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Your attendance summary',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              _HeaderPill(
                text: 'TODAY',
                color: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: 17),

          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: _ColoredInfoItem(
                    value: '--',
                    label: 'Status',
                  ),
                ),

                _WhiteDivider(),

                const Expanded(
                  child: _ColoredInfoItem(
                    value: '--',
                    label: 'This Month',
                  ),
                ),

                _WhiteDivider(),

                const Expanded(
                  child: _ColoredInfoItem(
                    value: '--',
                    label: 'Present',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableCard() {
    return _DashboardCard(
      accentColor: blue,
      darkAccent: darkBlue,
      icon: Icons.schedule_outlined,
      title: 'Today\'s Timetable',
      subtitle: 'Your classes for today',
      trailing: _ViewAllButton(
        color: blue,
        onTap: () {},
      ),
      child: Column(
        children: [
          _ScheduleRow(
            period: '01',
            title: 'Class schedule',
            subtitle: 'Timetable will appear here',
            color: blue,
            icon: Icons.access_time_rounded,
            isFirst: true,
          ),

          const SizedBox(height: 8),

          _ScheduleRow(
            period: '02',
            title: 'Next class',
            subtitle: 'Coming soon',
            color: blue,
            icon: Icons.arrow_forward_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard() {
    return _DashboardCard(
      accentColor: orange,
      darkAccent: darkOrange,
      icon: Icons.menu_book_outlined,
      title: 'Homework & School Diary',
      subtitle: 'Stay updated with your tasks',
      trailing: _ViewAllButton(
        color: orange,
        onTap: () {},
      ),
      child: _HomeworkEmptyState(
        color: orange,
      ),
    );
  }

  Widget _buildAnnouncementsCard() {
    return _DashboardCard(
      accentColor: green,
      darkAccent: darkGreen,
      icon: Icons.campaign_outlined,
      title: 'Announcements',
      subtitle: 'Latest school communication',
      trailing: _ViewAllButton(
        color: green,
        onTap: () {},
      ),
      child: _AnnouncementEmptyState(
        color: green,
      ),
    );
  }

  Widget _buildUpcomingExamsCard() {
    return _DashboardCard(
      accentColor: purple,
      darkAccent: darkPurple,
      icon: Icons.event_note_outlined,
      title: 'Upcoming Exams',
      subtitle: 'Keep track of important dates',
      trailing: _ViewAllButton(
        color: purple,
        onTap: () {},
      ),
      child: _ExamEmptyState(
        color: purple,
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    final items = [
      const _QuickAccessItem(
        icon: Icons.fact_check_outlined,
        title: 'Attendance',
        color: teal,
      ),
      const _QuickAccessItem(
        icon: Icons.menu_book_outlined,
        title: 'Homework',
        color: orange,
      ),
      const _QuickAccessItem(
        icon: Icons.schedule_outlined,
        title: 'Timetable',
        color: blue,
      ),
      const _QuickAccessItem(
        icon: Icons.assignment_outlined,
        title: 'Exams',
        color: purple,
      ),
      const _QuickAccessItem(
        icon: Icons.grade_outlined,
        title: 'Results',
        color: green,
      ),
      const _QuickAccessItem(
        icon: Icons.directions_bus_outlined,
        title: 'Transport',
        color: navy,
      ),
      const _QuickAccessItem(
        icon: Icons.receipt_long_outlined,
        title: 'Fees',
        color: orange,
      ),
      const _QuickAccessItem(
        icon: Icons.more_horiz_rounded,
        title: 'More',
        color: darkTeal,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
        constraints.maxWidth >= 800
            ? 5
            : constraints.maxWidth >= 560
            ? 4
            : constraints.maxWidth >= 360
            ? 4
            : 3;

        return GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 9,
            mainAxisSpacing: 9,
            mainAxisExtent: 82,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return _QuickAccessCard(
              item: item,
              onTap: () {},
            );
          },
        );
      },
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final Color accentColor;
  final Color darkAccent;

  final IconData icon;
  final String title;
  final String subtitle;

  final Widget? trailing;
  final Widget child;

  const _DashboardCard({
    required this.accentColor,
    required this.darkAccent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: _HomeScreenState.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Container(
              width: 5,
              color: accentColor,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  14,
                  14,
                  14,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(
                              alpha: 0.09,
                            ),
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color: accentColor.withValues(
                                alpha: 0.13,
                              ),
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: darkAccent,
                            size: 21,
                          ),
                        ),

                        const SizedBox(width: 11),

                        // Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: darkAccent,
                                  fontSize: 14.5,
                                  fontWeight:
                                  FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 3),

                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color:
                                  _HomeScreenState
                                      .textSecondary,
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (trailing != null) trailing!,
                      ],
                    ),

                    const SizedBox(height: 14),

                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeworkEmptyState extends StatelessWidget {
  final Color color;

  const _HomeworkEmptyState({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        13,
        12,
        13,
        12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEFE7D8),
        ),
      ),
      child: Row(
        children: [
          // Notebook-style icon
          Container(
            width: 42,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: color.withValues(alpha: 0.20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  color: color,
                  size: 22,
                ),
                Positioned(
                  left: 7,
                  right: 7,
                  bottom: 8,
                  child: Container(
                    height: 2,
                    color: color.withValues(alpha: 0.18),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'No homework available yet',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _HomeScreenState.textPrimary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'New assignments will appear here.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                    _HomeScreenState.textSecondary,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          _SmallStatusChip(
            text: 'CLEAR',
            color: color,
          ),
        ],
      ),
    );
  }
}

class _AnnouncementEmptyState extends StatelessWidget {
  final Color color;

  const _AnnouncementEmptyState({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          // Communication marker
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: color,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'No new announcements',
                  style: TextStyle(
                    color: _HomeScreenState.textPrimary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'School notices will appear here.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                    _HomeScreenState.textSecondary,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.65),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamEmptyState extends StatelessWidget {
  final Color color;

  const _ExamEmptyState({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          // Date block
          Container(
            width: 54,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: color.withValues(alpha: 0.20),
              ),
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Text(
                  '--',
                  style: TextStyle(
                    color: color,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'DATE',
                  style: TextStyle(
                    color: color.withValues(alpha: 0.75),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming exam dates',
                  style: TextStyle(
                    color: _HomeScreenState.textPrimary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'Your examination schedule will appear here.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                    _HomeScreenState.textSecondary,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.calendar_month_outlined,
            color: color,
            size: 21,
          ),
        ],
      ),
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _ViewAllButton({
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View all',
                style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(width: 1),

              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallStatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _SmallStatusChip({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.13),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 7.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final String period;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final bool isFirst;

  const _ScheduleRow({
    required this.period,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        SizedBox(
          width: 38,
          child: Column(
            children: [
              Container(
                width: 31,
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: color,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: _HomeScreenState.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color:
                          _HomeScreenState
                              .textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color:
                          _HomeScreenState
                              .textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ColoredInfoItem extends StatelessWidget {
  final String value;
  final String label;

  const _ColoredInfoItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final String text;
  final Color color;

  const _HeaderPill({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _WhiteDivider extends StatelessWidget {
  const _WhiteDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: Colors.white.withValues(alpha: 0.18),
    );
  }
}

class _QuickAccessItem {
  final IconData icon;
  final String title;
  final Color color;

  const _QuickAccessItem({
    required this.icon,
    required this.title,
    required this.color,
  });
}

class _QuickAccessCard extends StatelessWidget {
  final _QuickAccessItem item;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor:
        item.color.withValues(alpha: 0.10),
        highlightColor:
        item.color.withValues(alpha: 0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _HomeScreenState.border,
            ),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withValues(alpha: 0.035),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              // Colored icon tile
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color:
                  item.color.withValues(alpha: 0.09),
                  borderRadius:
                  BorderRadius.circular(10),
                  border: Border.all(
                    color:
                    item.color.withValues(alpha: 0.13),
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 18,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color:
                  _HomeScreenState.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}