// import 'package:flutter/material.dart';
// import '../Services/auth_services.dart';
// import '../Services/storage_service.dart';
// import '../models/attendance_model.dart';
// import '../models/student_model.dart';
// import '../widgets/common_app_header.dart';
//
// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});
//
//   @override
//   State<AttendanceScreen> createState() =>
//       _AttendanceScreenState();
// }
//
// class _AttendanceScreenState
//     extends State<AttendanceScreen> {
//   AttendanceCalendar? calendar;
//   StudentModel? student;
//
//   bool isLoading = true;
//   String? errorMessage;
//
//   DateTime selectedMonth = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _loadStudentProfile();
//     _loadAttendance();
//   }
//   Future<void> _loadStudentProfile() async {
//     try {
//       final token = await StorageService.getToken();
//
//       if (token == null || token.isEmpty) {
//         throw Exception('Authentication session not found.');
//       }
//
//       final profile = await ApiService.getMyProfile(token);
//
//       if (!mounted) return;
//
//       setState(() {
//         student = profile;
//       });
//     } catch (error) {
//       if (!mounted) return;
//
//       setState(() {
//         errorMessage = error
//             .toString()
//             .replaceFirst('Exception: ', '');
//       });
//     }
//   }
//   Future<void> _loadAttendance() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//
//     try {
//       final token = await StorageService.getToken();
//
//       if (token == null || token.isEmpty) {
//         throw Exception('Authentication required.');
//       }
//
//       final month =
//           '${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}';
//
//       final result =
//       await ApiService.getMyAttendanceCalendar(
//         token,
//         month,
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         calendar = result;
//         isLoading = false;
//       });
//     } catch (error) {
//       if (!mounted) return;
//
//       setState(() {
//         errorMessage = error
//             .toString()
//             .replaceFirst('Exception: ', '');
//         isLoading = false;
//       });
//     }
//   }
//
//   void _changeMonth(int offset) {
//     setState(() {
//       selectedMonth = DateTime(
//         selectedMonth.year,
//         selectedMonth.month + offset,
//       );
//     });
//
//     _loadAttendance();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const cream = Color(0xFFFAF8F0);
//
//     return Scaffold(
//       backgroundColor: cream,
//       body: SafeArea(
//         child: Column(
//           children: [
//             CommonAppHeader(
//               student: student,
//               isLoading: student == null,
//               errorMessage: null,
//               onMenuPressed: () {
//                 // MainNavigation will connect the drawer here.
//               },
//               onNotificationPressed: () {
//                 // Notifications will be connected later.
//               },
//             ),
//
//             Expanded(
//               child: _buildBody(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     const teal = Color(0xFF087F70);
//     const darkTeal = Color(0xFF075E56);
//     const orange = Color(0xFFE39B2E);
//
//     if (isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//
//     if (errorMessage != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(
//                 Icons.error_outline,
//                 size: 42,
//                 color: Colors.redAccent,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 errorMessage!,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _loadAttendance,
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     if (calendar == null) {
//       return const Center(
//         child: Text(
//           'No attendance data available.',
//         ),
//       );
//     }
//
//     return RefreshIndicator(
//       onRefresh: _loadAttendance,
//       child: SingleChildScrollView(
//         physics:
//         const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment:
//           CrossAxisAlignment.start,
//           children: [
//             _buildMonthHeader(teal),
//
//             const SizedBox(height: 16),
//
//             _buildPercentageCard(teal),
//
//             const SizedBox(height: 16),
//
//             _buildSummaryCards(),
//
//             const SizedBox(height: 24),
//
//             _buildCalendarCard(teal),
//
//             const SizedBox(height: 20),
//
//             _buildLegend(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMonthHeader(Color teal) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 6,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFFE1E5E9),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _monthArrow(
//             icon: Icons.chevron_left_rounded,
//             onPressed: () => _changeMonth(-1),
//           ),
//
//           Expanded(
//             child: Column(
//               children: [
//                 Text(
//                   '${_monthName(selectedMonth.month)} ${selectedMonth.year}',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF17202A),
//                   ),
//                 ),
//
//                 const SizedBox(height: 2),
//
//                 const Text(
//                   'Monthly attendance',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Color(0xFF66717D),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           _monthArrow(
//             icon: Icons.chevron_right_rounded,
//             onPressed: () => _changeMonth(1),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _monthArrow({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Material(
//       color: const Color(0xFFF5F6F8),
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(12),
//         child: SizedBox(
//           width: 42,
//           height: 42,
//           child: Icon(
//             icon,
//             size: 22,
//             color: const Color(0xFF173B5E),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPercentageCard(Color teal) {
//     final percentage = calendar!.summary.percentage;
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: const Color(0xFFE1E5E9),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 72,
//             height: 72,
//             decoration: BoxDecoration(
//               color: teal.withValues(alpha: 0.10),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 '${percentage.toStringAsFixed(0)}%',
//                 style: TextStyle(
//                   color: teal,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 18),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Attendance',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF17202A),
//                   ),
//                 ),
//
//                 const SizedBox(height: 5),
//
//                 Text(
//                   '${calendar!.summary.present} of '
//                       '${calendar!.summary.attendanceRequiredDays} '
//                       'required days attended',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF66717D),
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: LinearProgressIndicator(
//                     value: percentage / 100,
//                     minHeight: 8,
//                     backgroundColor: const Color(0xFFE8ECEF),
//                     valueColor: AlwaysStoppedAnimation<Color>(teal),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSummaryCards() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             value: calendar!.summary.present,
//             label: 'Present',
//             icon: Icons.check_circle_outline_rounded,
//             color: const Color(0xFF16805B),
//             background: const Color(0xFFEAF7F1),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _buildStatCard(
//             value: calendar!.summary.absent,
//             label: 'Absent',
//             icon: Icons.cancel_outlined,
//             color: const Color(0xFFD9534F),
//             background: const Color(0xFFFDEEEE),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _buildStatCard(
//             value: calendar!.summary.total,
//             label: 'Total',
//             icon: Icons.calendar_month_outlined,
//             color: const Color(0xFF246BCE),
//             background: const Color(0xFFEEF4FC),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard({
//     required int value,
//     required String label,
//     required IconData icon,
//     required Color color,
//     required Color background,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 15,
//       ),
//       decoration: BoxDecoration(
//         color: background,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: color.withValues(alpha: 0.12),
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.75),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               size: 18,
//               color: color,
//             ),
//           ),
//
//           const SizedBox(height: 9),
//
//           Text(
//             value.toString(),
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w800,
//               color: color,
//             ),
//           ),
//
//           const SizedBox(height: 2),
//
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF66717D),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCalendarCard(Color teal) {
//     final firstDay = DateTime(
//       selectedMonth.year,
//       selectedMonth.month,
//       1,
//     );
//
//     final leadingEmptyDays = firstDay.weekday - 1;
//
//     final totalGridItems =
//         leadingEmptyDays + calendar!.days.length;
//
//     return Container(
//       padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFA),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: const Color(0xFFE1E8E7),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 38,
//                 height: 38,
//                 decoration: BoxDecoration(
//                   color: teal.withValues(alpha: 0.10),
//                   borderRadius: BorderRadius.circular(11),
//                 ),
//                 child: Icon(
//                   Icons.calendar_month_rounded,
//                   color: teal,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 11),
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Attendance calendar',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w800,
//                       color: Color(0xFF17202A),
//                     ),
//                   ),
//                   SizedBox(height: 2),
//                   Text(
//                     'Your daily attendance',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Color(0xFF66717D),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 18),
//
//           _buildWeekdayHeader(),
//
//           const SizedBox(height: 10),
//
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: totalGridItems,
//             gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 7,
//               crossAxisSpacing: 7,
//               mainAxisSpacing: 7,
//               childAspectRatio: 0.90,
//             ),
//             itemBuilder: (context, index) {
//               if (index < leadingEmptyDays) {
//                 return const SizedBox.shrink();
//               }
//
//               final dayIndex = index - leadingEmptyDays;
//
//               return _buildCalendarDay(
//                 calendar!.days[dayIndex],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWeekdayHeader() {
//     const weekdays = [
//       'Mon',
//       'Tue',
//       'Wed',
//       'Thu',
//       'Fri',
//       'Sat',
//       'Sun',
//     ];
//
//     return Row(
//       children: weekdays.map((day) {
//         return Expanded(
//           child: Center(
//             child: Text(
//               day,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildCalendarDay(AttendanceCalendarDay day) {
//     final status = day.status;
//
//     final Color backgroundColor;
//     final Color borderColor;
//     final Color textColor;
//     final IconData? icon;
//
//     switch (status) {
//       case 'PRESENT':
//         backgroundColor = const Color(0xFFD9F5E5);
//         borderColor = const Color(0xFF32B878);
//         textColor = const Color(0xFF07865F);
//         icon = Icons.check_rounded;
//         break;
//
//       case 'ABSENT':
//         backgroundColor = const Color(0xFFFFE0DE);
//         borderColor = const Color(0xFFEF6A64);
//         textColor = const Color(0xFFD93630);
//         icon = Icons.close_rounded;
//         break;
//
//       case 'HOLIDAY':
//       case 'OFF':
//         backgroundColor = const Color(0xFFFFF0B3);
//         borderColor = const Color(0xFFFFC107);
//         textColor = const Color(0xFFE09B00);
//         icon = Icons.remove_rounded;
//         break;
//
//       default:
//         backgroundColor = const Color(0xFFF4F6F7);
//         borderColor = const Color(0xFFE1E5E9);
//         textColor = const Color(0xFF66717D);
//         icon = null;
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(11),
//         border: Border.all(
//           color: borderColor,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             day.date.day.toString(),
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w800,
//               color: textColor,
//             ),
//           ),
//
//           const SizedBox(height: 3),
//
//           if (icon != null)
//             Icon(
//               icon,
//               size: 13,
//               color: textColor,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLegend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildLegendItem(
//           color: const Color(0xFF32B878),
//           label: 'Present',
//         ),
//         const SizedBox(width: 18),
//         _buildLegendItem(
//           color: const Color(0xFFEF6A64),
//           label: 'Absent',
//         ),
//         const SizedBox(width: 18),
//         _buildLegendItem(
//           color: const Color(0xFFFFC107),
//           label: 'Off / Holiday',
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLegendItem({
//     required Color color,
//     required String label,
//   }) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF66717D),
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _monthName(int month) {
//     const months = [
//       '',
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//
//     return months[month];
//   }
// }

import 'package:flutter/material.dart';
import '../Services/auth_services.dart';
import '../Services/storage_service.dart';
import '../models/attendance_model.dart';
import '../models/student_model.dart';
import '../widgets/common_app_header.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState
    extends State<AttendanceScreen> {
  AttendanceCalendar? calendar;
  StudentModel? student;

  bool isLoading = true;
  String? errorMessage;

  DateTime selectedMonth = DateTime.now();

// ---------- COLORS ----------
  static const navy = Color(0xFF173B5E);
  static const darkNavy = Color(0xFF0F2942);

  static const teal = Color(0xFF087F70);
  static const darkTeal = Color(0xFF075E56);

  static const green = Color(0xFF16805B);
  static const greenLight = Color(0xFFDDF6E9);

  static const red = Color(0xFFD9534F);
  static const redLight = Color(0xFFFFE4E1);

  static const blue = Color(0xFF246BCE);
  static const blueLight = Color(0xFFE3EEFF);

  static const yellow = Color(0xFFE09B00);
  static const yellowLight = Color(0xFFFFF2C2);

  static const background = Color(0xFFF3F7F6);
  static const textPrimary = Color(0xFF17202A);
  static const textSecondary = Color(0xFF66717D);

  @override
  void initState() {
    super.initState();

    _loadStudentProfile();
    _loadAttendance();
  }

  Future<void> _loadStudentProfile() async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'Authentication session not found.',
        );
      }

      final profile =
      await ApiService.getMyProfile(token);

      if (!mounted) return;

      setState(() {
        student = profile;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error
            .toString()
            .replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _loadAttendance() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication required.');
      }

      final month =
          '${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}';

      final result =
      await ApiService.getMyAttendanceCalendar(
        token,
        month,
      );

      if (!mounted) return;

      setState(() {
        calendar = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error
            .toString()
            .replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + offset,
      );
    });

    _loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            CommonAppHeader(
              student: student,
              isLoading: student == null,
              errorMessage: null,
              onMenuPressed: () {
// MainNavigation will connect the drawer here.
              },
              onNotificationPressed: () {
// Notifications will be connected later.
              },
            ),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: teal,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: redLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 38,
                  color: red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _loadAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (calendar == null) {
      return const Center(
        child: Text(
          'No attendance data available.',
          style: TextStyle(
            color: textSecondary,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: teal,
      onRefresh: _loadAttendance,
      child: SingleChildScrollView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          28,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),

            const SizedBox(height: 18),

            _buildAttendanceHero(),

            const SizedBox(height: 16),

            _buildSummaryCards(),

            const SizedBox(height: 22),

            _buildCalendarCard(),

            const SizedBox(height: 14),

            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            teal,
            darkTeal,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: teal.withValues(alpha: 0.20),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _monthArrow(
            icon: Icons.chevron_left_rounded,
            onPressed: () => _changeMonth(-1),
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  '${_monthName(selectedMonth.month)} ${selectedMonth.year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Monthly attendance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          _monthArrow(
            icon: Icons.chevron_right_rounded,
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
    );
  }

  Widget _monthArrow({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            size: 23,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceHero() {
    final percentage = calendar!.summary.percentage;

    const accent = Color(0xFF087F70);
    const accentLight = Color(0xFFE5F6F3);
    const darkText = Color(0xFF173B5E);
    const softText = Color(0xFF66717D);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accent.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: darkText.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attendance percentage
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentLight,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 7,
                    backgroundColor:
                    accent.withValues(alpha: 0.12),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      accent,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Attendance',
                      style: TextStyle(
                        color: softText,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // Small accent label
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'ATTENDANCE',
                      style: TextStyle(
                        color: accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                const Text(
                  'Keep it up! 👏',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${calendar!.summary.present} of '
                      '${calendar!.summary.attendanceRequiredDays} '
                      'required days attended',
                  style: const TextStyle(
                    color: softText,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 7,
                    backgroundColor:
                    accent.withValues(alpha: 0.10),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            value: calendar!.summary.present,
            label: 'Present',
            icon: Icons.check_circle_rounded,
            color: green,
            background: greenLight,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _buildStatCard(
            value: calendar!.summary.absent,
            label: 'Absent',
            icon: Icons.cancel_rounded,
            color: red,
            background: redLight,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _buildStatCard(
            value: calendar!.summary.total,
            label: 'Total',
            icon: Icons.calendar_month_rounded,
            color: blue,
            background: blueLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required int value,
    required String label,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        14,
        10,
        13,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.85,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 1),

          Text(
            label,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    final firstDay = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      1,
    );

    final leadingEmptyDays =
        firstDay.weekday - 1;

    final totalGridItems =
        leadingEmptyDays + calendar!.days.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        15,
        17,
        15,
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
// Calendar title
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF10A994),
                      teal,
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance calendar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Your daily attendance',
                      style: TextStyle(
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F4),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: const Text(
                  'DAILY',
                  style: TextStyle(
                    color: teal,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

// Weekdays
          _buildWeekdayHeader(),

          const SizedBox(height: 10),

// Calendar days
          GridView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount: totalGridItems,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
              childAspectRatio: 0.90,
            ),
            itemBuilder: (context, index) {
              if (index < leadingEmptyDays) {
                return const SizedBox.shrink();
              }

              final dayIndex =
                  index - leadingEmptyDays;

              return _buildCalendarDay(
                calendar!.days[dayIndex],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = [
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
      'SUN',
    ];

    return Row(
      children: weekdays.map((day) {
        final isWeekend =
            day == 'SAT' || day == 'SUN';

        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
                color: isWeekend
                    ? const Color(0xFF9AA5AD)
                    : navy,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarDay(
      AttendanceCalendarDay day,
      ) {
    final status = day.status;

    final Color backgroundColor;
    final Color borderColor;
    final Color textColor;
    final IconData? icon;

    switch (status) {
      case 'PRESENT':
        backgroundColor =
        const Color(0xFFD8F5E5);
        borderColor =
        const Color(0xFF3BC17F);
        textColor =
        const Color(0xFF087F70);
        icon = Icons.check_rounded;
        break;

      case 'ABSENT':
        backgroundColor =
        const Color(0xFFFFDEDB);
        borderColor =
        const Color(0xFFEF6A64);
        textColor =
        const Color(0xFFD93630);
        icon = Icons.close_rounded;
        break;

      case 'HOLIDAY':
      case 'OFF':
        backgroundColor =
        const Color(0xFFFFF0B5);
        borderColor =
        const Color(0xFFFFC107);
        textColor =
        const Color(0xFFD89100);
        icon = Icons.remove_rounded;
        break;

      default:
        backgroundColor =
        const Color(0xFFF4F7F8);
        borderColor =
        const Color(0xFFE2E7EA);
        textColor =
            textSecondary;
        icon = null;
    }

    final isToday =
    _isSameDate(day.date, DateTime.now());

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday
              ? navy
              : borderColor,
          width: isToday ? 1.8 : 1,
        ),
        boxShadow: [
          if (status == 'PRESENT' ||
              status == 'ABSENT')
            BoxShadow(
              color:
              borderColor.withValues(
                alpha: 0.10,
              ),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Text(
            day.date.day.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),

          const SizedBox(height: 3),

          if (icon != null)
            Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.65,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 12,
                color: textColor,
              ),
            ),
        ],
      ),
    );
  }

  bool _isSameDate(
      DateTime first,
      DateTime second,
      ) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.72,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(
            color: green,
            label: 'Present',
          ),
          _buildLegendItem(
            color: red,
            label: 'Absent',
          ),
          _buildLegendItem(
            color: yellow,
            label: 'Off / Holiday',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: textSecondary,
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month];
  }
}
