// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const SchoolErpApp());
// }
//
// class SchoolErpApp extends StatelessWidget {
//   const SchoolErpApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Delhi Premium School ERP',
//       theme: ThemeData(
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//
//         // School branded background
//         scaffoldBackgroundColor: const Color(0xFFFAF8F0),
//
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF087F70),
//           brightness: Brightness.light,
//         ),
//
//         // Bottom navigation styling
//         navigationBarTheme: NavigationBarThemeData(
//           backgroundColor: Colors.white,
//           indicatorColor: const Color(0xFFDDF1EB),
//           elevation: 3,
//           labelTextStyle: WidgetStateProperty.all(
//             const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int selectedIndex = 0;
//
//   final List<Widget> pages = const [
//     HomePage(),
//     AcademicsPage(),
//     FeesPage(),
//     TransportPage(),
//     ProfilePage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[selectedIndex],
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: selectedIndex,
//         onDestinationSelected: (index) {
//           setState(() {
//             selectedIndex = index;
//           });
//         },
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             selectedIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.menu_book_outlined),
//             selectedIcon: Icon(Icons.menu_book),
//             label: 'Academics',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.account_balance_wallet_outlined),
//             selectedIcon: Icon(Icons.account_balance_wallet),
//             label: 'Fees',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.directions_bus_outlined),
//             selectedIcon: Icon(Icons.directions_bus),
//             label: 'Transport',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outline),
//             selectedIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // --------------------------------------------------
//             // HEADER
//             // --------------------------------------------------
//
//             Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.06),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.asset(
//                       'assets/images/school_logo.png',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 12),
//
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Good Morning 👋',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         'Aarav Sharma',
//                         style: TextStyle(
//                           fontSize: 19,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE5F4EF),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.notifications_none_rounded,
//                     color: Color(0xFF087F70),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 25),
//
//             // --------------------------------------------------
//             // WELCOME / STUDENT HERO
//             // --------------------------------------------------
//
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(22),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color(0xFF087F70),
//                     Color(0xFF0BA58D),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(28),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF087F70).withOpacity(0.22),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//
//                   Positioned(
//                     right: -25,
//                     top: -30,
//                     child: Container(
//                       width: 130,
//                       height: 130,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.08),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//
//                   Positioned(
//                     right: 35,
//                     bottom: -50,
//                     child: Container(
//                       width: 110,
//                       height: 110,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.06),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       Row(
//                         children: [
//                           const Expanded(
//                             child: Text(
//                               'Student Profile',
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: const Text(
//                               '2026–27',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       const Text(
//                         'Aarav Sharma',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 25,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//
//                       const SizedBox(height: 5),
//
//                       const Text(
//                         'Class 8 • Section A • Roll No. 24',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 12,
//                         ),
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       Row(
//                         children: [
//
//                           Expanded(
//                             child: _HomeMetric(
//                               value: '94%',
//                               label: 'Attendance',
//                               icon: Icons.event_available_rounded,
//                             ),
//                           ),
//
//                           const SizedBox(width: 10),
//
//                           Expanded(
//                             child: _HomeMetric(
//                               value: '#06',
//                               label: 'Class Rank',
//                               icon: Icons.emoji_events_outlined,
//                             ),
//                           ),
//
//                           const SizedBox(width: 10),
//
//                           Expanded(
//                             child: _HomeMetric(
//                               value: 'A',
//                               label: 'Result',
//                               icon: Icons.auto_awesome_outlined,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 28),
//
//             // --------------------------------------------------
//             // TODAY AT SCHOOL
//             // --------------------------------------------------
//
//             const Text(
//               'Today at School',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             const SizedBox(height: 5),
//
//             const Text(
//               'Here is what is happening today',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 12,
//               ),
//             ),
//
//             const SizedBox(height: 15),
//
//             Row(
//               children: [
//
//                 Expanded(
//                   child: _TodayHighlight(
//                     icon: Icons.menu_book_rounded,
//                     number: '3',
//                     title: 'Classes',
//                     subtitle: 'Today',
//                     iconColor: const Color(0xFF087F70),
//                   ),
//                 ),
//
//                 const SizedBox(width: 12),
//
//                 Expanded(
//                   child: _TodayHighlight(
//                     icon: Icons.assignment_rounded,
//                     number: '3',
//                     title: 'Homework',
//                     subtitle: 'Pending',
//                     iconColor: const Color(0xFF8055C7),
//                   ),
//                 ),
//
//                 const SizedBox(width: 12),
//
//                 Expanded(
//                   child: _TodayHighlight(
//                     icon: Icons.directions_bus_rounded,
//                     number: '04',
//                     title: 'Bus',
//                     subtitle: 'Assigned',
//                     iconColor: const Color(0xFFE39B2E),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 28),
//
//             // --------------------------------------------------
//             // ATTENDANCE + FEES
//             // --------------------------------------------------
//
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(17),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE5F4EF),
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         const Row(
//                           children: [
//                             Icon(
//                               Icons.event_available_rounded,
//                               color: Color(0xFF087F70),
//                               size: 20,
//                             ),
//                             SizedBox(width: 7),
//                             Text(
//                               'Attendance',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 18),
//
//                         const Text(
//                           '94%',
//                           style: TextStyle(
//                             fontSize: 29,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF087F70),
//                           ),
//                         ),
//
//                         const SizedBox(height: 8),
//
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: const LinearProgressIndicator(
//                             value: 0.94,
//                             minHeight: 7,
//                             backgroundColor: Colors.white,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Color(0xFF087F70),
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 8),
//
//                         const Text(
//                           'Excellent attendance',
//                           style: TextStyle(
//                             color: Color(0xFF087F70),
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 12),
//
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(17),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFFF1D8),
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         const Row(
//                           children: [
//                             Icon(
//                               Icons.account_balance_wallet_rounded,
//                               color: Color(0xFFD48A20),
//                               size: 20,
//                             ),
//                             SizedBox(width: 7),
//                             Text(
//                               'Fees',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 18),
//
//                         const Text(
//                           '₹12.5K',
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFFD48A20),
//                           ),
//                         ),
//
//                         const SizedBox(height: 6),
//
//                         const Text(
//                           'Outstanding',
//                           style: TextStyle(
//                             color: Color(0xFF8D672D),
//                             fontSize: 10,
//                           ),
//                         ),
//
//                         const SizedBox(height: 12),
//
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 7,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.65),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'View Fees',
//                               style: TextStyle(
//                                 color: Color(0xFFD48A20),
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 28),
//
//             // --------------------------------------------------
//             // TODAY'S CLASSES
//             // --------------------------------------------------
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Today's Classes",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 Text(
//                   'View timetable',
//                   style: TextStyle(
//                     color: const Color(0xFF087F70),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 15),
//
//             _CreativeClassTile(
//               time: '09:00',
//               subject: 'Mathematics',
//               room: 'Room 204',
//               icon: Icons.calculate_rounded,
//               color: const Color(0xFF087F70),
//               isCurrent: true,
//             ),
//
//             _CreativeClassTile(
//               time: '10:00',
//               subject: 'Science',
//               room: 'Laboratory 02',
//               icon: Icons.science_rounded,
//               color: const Color(0xFF8055C7),
//               isCurrent: false,
//             ),
//
//             _CreativeClassTile(
//               time: '11:30',
//               subject: 'English',
//               room: 'Room 108',
//               icon: Icons.menu_book_rounded,
//               color: const Color(0xFFE39B2E),
//               isCurrent: false,
//             ),
//
//             const SizedBox(height: 20),
//
//             // --------------------------------------------------
//             // NOTICE
//             // --------------------------------------------------
//
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF123C3A),
//                 borderRadius: BorderRadius.circular(23),
//               ),
//               child: Row(
//                 children: [
//
//                   Container(
//                     width: 45,
//                     height: 45,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: const Icon(
//                       Icons.campaign_rounded,
//                       color: Colors.white,
//                     ),
//                   ),
//
//                   const SizedBox(width: 13),
//
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Latest Notice',
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 10,
//                           ),
//                         ),
//                         SizedBox(height: 3),
//                         Text(
//                           'Annual Sports Day',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 3),
//                         Text(
//                           'Schedule has been released',
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     color: Colors.white54,
//                     size: 15,
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             // --------------------------------------------------
//             // UPCOMING EVENT
//             // --------------------------------------------------
//
//             const Text(
//               'Upcoming',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             const SizedBox(height: 14),
//
//             Container(
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//
//                   Container(
//                     width: 52,
//                     height: 58,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFFE7E2),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           '25',
//                           style: TextStyle(
//                             color: Color(0xFFD95858),
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'SEP',
//                           style: TextStyle(
//                             color: Color(0xFFD95858),
//                             fontSize: 9,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(width: 14),
//
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Parent–Teacher Meeting',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           'Meet your class teacher and discuss academic progress.',
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const Icon(
//                     Icons.chevron_right_rounded,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _HomeMetric extends StatelessWidget {
//   final String value;
//   final String label;
//   final IconData icon;
//
//   const _HomeMetric({
//     required this.value,
//     required this.label,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 11,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.11),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             icon,
//             color: Colors.white70,
//             size: 17,
//           ),
//           const SizedBox(height: 7),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 1),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 9,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TodayHighlight extends StatelessWidget {
//   final IconData icon;
//   final String number;
//   final String title;
//   final String subtitle;
//   final Color iconColor;
//
//   const _TodayHighlight({
//     required this.icon,
//     required this.number,
//     required this.title,
//     required this.subtitle,
//     required this.iconColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.035),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.10),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               color: iconColor,
//               size: 20,
//             ),
//           ),
//
//           const SizedBox(height: 13),
//
//           Text(
//             number,
//             style: const TextStyle(
//               fontSize: 21,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 2),
//
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//
//           const SizedBox(height: 2),
//
//           Text(
//             subtitle,
//             style: const TextStyle(
//               fontSize: 9,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CreativeClassTile extends StatelessWidget {
//   final String time;
//   final String subject;
//   final String room;
//   final IconData icon;
//   final Color color;
//   final bool isCurrent;
//
//   const _CreativeClassTile({
//     required this.time,
//     required this.subject,
//     required this.room,
//     required this.icon,
//     required this.color,
//     required this.isCurrent,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 52,
//             child: Text(
//               time,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: isCurrent ? color : Colors.grey.shade600,
//               ),
//             ),
//           ),
//
//           Container(
//             width: 10,
//             height: 10,
//             decoration: BoxDecoration(
//               color: isCurrent ? color : Colors.grey.shade300,
//               shape: BoxShape.circle,
//               boxShadow: isCurrent
//                   ? [
//                 BoxShadow(
//                   color: color.withOpacity(0.25),
//                   blurRadius: 8,
//                   spreadRadius: 2,
//                 ),
//               ]
//                   : null,
//             ),
//           ),
//
//           const SizedBox(width: 10),
//
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: isCurrent
//                     ? color.withOpacity(0.09)
//                     : Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//                 border: Border.all(
//                   color: isCurrent
//                       ? color.withOpacity(0.18)
//                       : Colors.transparent,
//                 ),
//                 boxShadow: isCurrent
//                     ? null
//                     : [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.025),
//                     blurRadius: 10,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.11),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Icon(
//                       icon,
//                       color: color,
//                       size: 22,
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 subject,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                             if (isCurrent)
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: color,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: const Text(
//                                   'NOW',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 8,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on_outlined,
//                               size: 13,
//                               color: Colors.grey.shade500,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               room,
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AcademicsPage extends StatelessWidget {
//   const AcademicsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF8F0),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // HEADER
//               Row(
//                 children: [
//                   Container(
//                     width: 46,
//                     height: 46,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE5F1EC),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Icon(
//                       Icons.auto_stories_rounded,
//                       color: Color(0xFF087F70),
//                       size: 24,
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Academics',
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF163A35),
//                           ),
//                         ),
//                         SizedBox(height: 3),
//                         Text(
//                           'Your complete academic space',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   Container(
//                     width: 42,
//                     height: 42,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: const Icon(
//                       Icons.search_rounded,
//                       color: Color(0xFF087F70),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 22),
//
//               // ACADEMIC OVERVIEW
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF087F70),
//                       Color(0xFF075E56),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(28),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Row(
//                       children: [
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Academic Overview',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 'Class 10 • Section A',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 19,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         Container(
//                           padding: const EdgeInsets.all(11),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.13),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: const Icon(
//                             Icons.school_rounded,
//                             color: Colors.white,
//                             size: 25,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 22),
//
//                     Row(
//                       children: [
//                         _AcademicMiniStat(
//                           value: '82%',
//                           label: 'Attendance',
//                         ),
//                         _AcademicMiniStat(
//                           value: '5',
//                           label: 'Subjects',
//                         ),
//                         _AcademicMiniStat(
//                           value: '3',
//                           label: 'Pending',
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text(
//                 'Study & Schedule',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF163A35),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               // TIMETABLE + HOMEWORK
//               Row(
//                 children: [
//                   Expanded(
//                     child: _AcademicActionCard(
//                       icon: Icons.calendar_month_rounded,
//                       title: 'Timetable',
//                       subtitle: 'Today · 6 classes',
//                       color: const Color(0xFF087F70),
//                       large: true,
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   Expanded(
//                     child: _AcademicActionCard(
//                       icon: Icons.assignment_rounded,
//                       title: 'Homework',
//                       subtitle: '3 pending',
//                       color: const Color(0xFFE39B2E),
//                       large: true,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               // EXAMINATION
//               Container(
//                 padding: const EdgeInsets.all(18),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEDE7F7),
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 52,
//                       height: 52,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF8055C7).withOpacity(0.14),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: const Icon(
//                         Icons.event_note_rounded,
//                         color: Color(0xFF8055C7),
//                         size: 27,
//                       ),
//                     ),
//
//                     const SizedBox(width: 14),
//
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Next Examination',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           SizedBox(height: 3),
//                           Text(
//                             'Mathematics',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                           SizedBox(height: 3),
//                           Text(
//                             '18 October • 9:00 AM',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const Icon(
//                       Icons.arrow_forward_ios_rounded,
//                       size: 15,
//                       color: Color(0xFF8055C7),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text(
//                 'Performance',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF163A35),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: _AcademicActionCard(
//                       icon: Icons.bar_chart_rounded,
//                       title: 'Results',
//                       subtitle: 'View performance',
//                       color: const Color(0xFF087F70),
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   Expanded(
//                     child: _AcademicActionCard(
//                       icon: Icons.menu_book_rounded,
//                       title: 'Syllabus',
//                       subtitle: '5 subjects',
//                       color: const Color(0xFF4B7BEC),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // MOTIVATION STRIP
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFF1D6),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Row(
//                   children: [
//                     Text(
//                       '✦',
//                       style: TextStyle(
//                         fontSize: 25,
//                         color: Color(0xFFE39B2E),
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'Small progress every day adds up to big results.',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF5D4A2C),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _AcademicMiniStat extends StatelessWidget {
//   final String value;
//   final String label;
//
//   const _AcademicMiniStat({
//     required this.value,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _AcademicActionCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Color color;
//   final bool large;
//
//   const _AcademicActionCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.color,
//     this.large = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(large ? 17 : 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.035),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.11),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 25,
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF163A35),
//             ),
//           ),
//
//           const SizedBox(height: 4),
//
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.grey.shade600,
//             ),
//           ),
//
//           const SizedBox(height: 13),
//
//           Row(
//             children: [
//               Text(
//                 'Open',
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w700,
//                   color: color,
//                 ),
//               ),
//               const Spacer(),
//               Icon(
//                 Icons.arrow_forward_rounded,
//                 size: 16,
//                 color: color,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class FeesPage extends StatelessWidget {
//   const FeesPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF8F0),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // HEADER
//               Row(
//                 children: [
//                   Container(
//                     width: 46,
//                     height: 46,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE5F1EC),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Icon(
//                       Icons.account_balance_wallet_rounded,
//                       color: Color(0xFF087F70),
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Fees & Payments',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF163A35),
//                           ),
//                         ),
//                         SizedBox(height: 3),
//                         Text(
//                           'Manage your school fee details',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               // MAIN FEE CARD
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF087F70),
//                       Color(0xFF075E56),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(28),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Expanded(
//                           child: Text(
//                             'Current Fee Status',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.14),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const Text(
//                             '2026–27',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 8),
//
//                     const Text(
//                       '₹24,500',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//
//                     const SizedBox(height: 3),
//
//                     const Text(
//                       'Total fees paid this academic year',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 11,
//                       ),
//                     ),
//
//                     const SizedBox(height: 22),
//
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: LinearProgressIndicator(
//                         value: 0.72,
//                         minHeight: 8,
//                         backgroundColor: Colors.white.withOpacity(0.15),
//                         valueColor: const AlwaysStoppedAnimation<Color>(
//                           Colors.white,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     const Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             '72% paid',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           '₹9,500 remaining',
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // NEXT PAYMENT
//               Container(
//                 padding: const EdgeInsets.all(17),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFF1D6),
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE39B2E).withOpacity(0.14),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: const Icon(
//                         Icons.calendar_month_rounded,
//                         color: Color(0xFFE39B2E),
//                       ),
//                     ),
//                     const SizedBox(width: 13),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Next Payment Due',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             '₹9,500 • 15 October 2026',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w800,
//                               color: Color(0xFF4D4029),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Icon(
//                       Icons.arrow_forward_rounded,
//                       color: Color(0xFFE39B2E),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text(
//                 'Payment Services',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF163A35),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: _FeeActionCard(
//                       icon: Icons.receipt_long_rounded,
//                       title: 'History',
//                       subtitle: 'Past payments',
//                       color: const Color(0xFF087F70),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _FeeActionCard(
//                       icon: Icons.receipt_rounded,
//                       title: 'Receipts',
//                       subtitle: 'Download receipts',
//                       color: const Color(0xFF8055C7),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // RECENT PAYMENT
//               const Text(
//                 'Recent Payment',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF163A35),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 46,
//                       height: 46,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE5F1EC),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: const Icon(
//                         Icons.check_circle_rounded,
//                         color: Color(0xFF087F70),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Quarterly Tuition Fee',
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             '02 September 2026',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Text(
//                       '₹8,500',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF087F70),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _FeeActionCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Color color;
//
//   const _FeeActionCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(17),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.035),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.11),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 24,
//             ),
//           ),
//
//           const SizedBox(height: 14),
//
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF163A35),
//             ),
//           ),
//
//           const SizedBox(height: 4),
//
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.grey.shade600,
//             ),
//           ),
//
//           const SizedBox(height: 13),
//
//           Row(
//             children: [
//               Text(
//                 'View',
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w700,
//                   color: color,
//                 ),
//               ),
//               const Spacer(),
//               Icon(
//                 Icons.arrow_forward_rounded,
//                 size: 16,
//                 color: color,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class TransportPage extends StatelessWidget {
//   const TransportPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF8F0),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // HEADER
//               Row(
//                 children: [
//                   Container(
//                     width: 46,
//                     height: 46,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE5F1EC),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Icon(
//                       Icons.directions_bus_rounded,
//                       color: Color(0xFF087F70),
//                       size: 25,
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Transport',
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF163A35),
//                           ),
//                         ),
//                         SizedBox(height: 3),
//                         Text(
//                           'Track your school bus',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   Container(
//                     width: 42,
//                     height: 42,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: const Icon(
//                       Icons.more_horiz_rounded,
//                       color: Color(0xFF087F70),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               // LIVE STATUS
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF087F70),
//                       Color(0xFF075E56),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(28),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Row(
//                       children: [
//                         Container(
//                           width: 10,
//                           height: 10,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF8FF0C5),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'BUS LIVE',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                         const Spacer(),
//                         const Text(
//                           'Updated 1 min ago',
//                           style: TextStyle(
//                             color: Colors.white60,
//                             fontSize: 9,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 58,
//                           height: 58,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.13),
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                           child: const Icon(
//                             Icons.directions_bus_rounded,
//                             color: Colors.white,
//                             size: 31,
//                           ),
//                         ),
//
//                         const SizedBox(width: 14),
//
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Bus 04',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 'Sector 45 → School',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 11,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 11,
//                             vertical: 7,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.13),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const Text(
//                             'ON ROUTE',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 22),
//
//                     // FAKE MAP / ROUTE AREA
//                     Container(
//                       height: 145,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.10),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 30,
//                             right: 30,
//                             top: 70,
//                             child: Container(
//                               height: 5,
//                               decoration: BoxDecoration(
//                                 color: Colors.white24,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),
//
//                           Positioned(
//                             left: 38,
//                             top: 60,
//                             child: _RoutePoint(
//                               label: '45',
//                               active: false,
//                             ),
//                           ),
//
//                           Positioned(
//                             left: 130,
//                             top: 60,
//                             child: _RoutePoint(
//                               label: 'BUS',
//                               active: true,
//                             ),
//                           ),
//
//                           Positioned(
//                             right: 35,
//                             top: 60,
//                             child: _RoutePoint(
//                               label: 'SCH',
//                               active: false,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 22),
//
//               const Text(
//                 'Journey Details',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF163A35),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: _TransportInfoCard(
//                       icon: Icons.person_rounded,
//                       title: 'Driver',
//                       value: 'Rajesh Kumar',
//                       color: const Color(0xFF8055C7),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _TransportInfoCard(
//                       icon: Icons.access_time_rounded,
//                       title: 'Arrival',
//                       value: '08:25 AM',
//                       color: const Color(0xFFE39B2E),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               // STOP CARD
//               Container(
//                 padding: const EdgeInsets.all(17),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE5F1EC),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: const Icon(
//                         Icons.location_on_rounded,
//                         color: Color(0xFF087F70),
//                       ),
//                     ),
//
//                     const SizedBox(width: 13),
//
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Your Bus Stop',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Sector 45 Community Gate',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w800,
//                               color: Color(0xFF163A35),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const Icon(
//                       Icons.arrow_forward_rounded,
//                       color: Color(0xFF087F70),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ETA STRIP
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEDE7F7),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(
//                       Icons.notifications_active_rounded,
//                       color: Color(0xFF8055C7),
//                       size: 22,
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'You will receive a notification when the bus is nearby.',
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF514267),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _RoutePoint extends StatelessWidget {
//   final String label;
//   final bool active;
//
//   const _RoutePoint({
//     required this.label,
//     required this.active,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 42,
//       height: 42,
//       decoration: BoxDecoration(
//         color: active
//             ? const Color(0xFF8FF0C5)
//             : Colors.white.withOpacity(0.16),
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: Colors.white.withOpacity(0.25),
//           width: 2,
//         ),
//       ),
//       child: Center(
//         child: Text(
//           label,
//           style: TextStyle(
//             color: active
//                 ? const Color(0xFF075E56)
//                 : Colors.white,
//             fontSize: active ? 8 : 10,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _TransportInfoCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//   final Color color;
//
//   const _TransportInfoCard({
//     required this.icon,
//     required this.title,
//     required this.value,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.11),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 23,
//             ),
//           ),
//           const SizedBox(height: 14),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF163A35),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF8F0),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // HEADER
//               Row(
//                 children: [
//                   Container(
//                     width: 46,
//                     height: 46,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE5F1EC),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Icon(
//                       Icons.person_rounded,
//                       color: Color(0xFF087F70),
//                       size: 25,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'My Profile',
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF163A35),
//                           ),
//                         ),
//                         SizedBox(height: 3),
//                         Text(
//                           'Student and account information',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               // STUDENT PROFILE CARD
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF087F70),
//                       Color(0xFF075E56),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(28),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 68,
//                           height: 68,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.3),
//                               width: 2,
//                             ),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'AS',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 21,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(width: 15),
//
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Aarav Sharma',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 'Class 8-A  •  Roll No. 24',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 11,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         const Icon(
//                           Icons.verified_rounded,
//                           color: Color(0xFF8FF0C5),
//                           size: 22,
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     Container(
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.10),
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: const Row(
//                         children: [
//                           Icon(
//                             Icons.school_rounded,
//                             color: Colors.white70,
//                             size: 18,
//                           ),
//                           SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               'Delhi Premium School',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '2026–27',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 10,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text(
//                 'Personal Information',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF163A35),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               Container(
//                 padding: const EdgeInsets.all(18),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//                 child: const Column(
//                   children: [
//                     _ProfileDetailRow(
//                       icon: Icons.cake_rounded,
//                       label: 'Date of Birth',
//                       value: '14 August 2012',
//                     ),
//                     Divider(height: 24),
//                     _ProfileDetailRow(
//                       icon: Icons.email_rounded,
//                       label: 'Email',
//                       value: 'aarav@example.com',
//                     ),
//                     Divider(height: 24),
//                     _ProfileDetailRow(
//                       icon: Icons.phone_rounded,
//                       label: 'Phone',
//                       value: '+91 98765 43210',
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text(
//                 'Account & Documents',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF163A35),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: _ProfileActionCard(
//                       icon: Icons.family_restroom_rounded,
//                       title: 'Parents',
//                       subtitle: 'Contact details',
//                       color: const Color(0xFF8055C7),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _ProfileActionCard(
//                       icon: Icons.description_rounded,
//                       title: 'Documents',
//                       subtitle: 'School records',
//                       color: const Color(0xFFE39B2E),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               // SETTINGS
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//                 child: Column(
//                   children: [
//                     _ProfileMenuTile(
//                       icon: Icons.settings_rounded,
//                       title: 'Settings',
//                       subtitle: 'Account and app preferences',
//                       color: const Color(0xFF087F70),
//                     ),
//                     _ProfileMenuTile(
//                       icon: Icons.help_outline_rounded,
//                       title: 'Help & Support',
//                       subtitle: 'Contact school support',
//                       color: const Color(0xFF4B7BEC),
//                     ),
//                     _ProfileMenuTile(
//                       icon: Icons.logout_rounded,
//                       title: 'Log Out',
//                       subtitle: 'Sign out of this account',
//                       color: const Color(0xFFD45D5D),
//                       showDivider: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _ProfileDetailRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//
//   const _ProfileDetailRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 42,
//           height: 42,
//           decoration: BoxDecoration(
//             color: const Color(0xFFE5F1EC),
//             borderRadius: BorderRadius.circular(13),
//           ),
//           child: Icon(
//             icon,
//             color: const Color(0xFF087F70),
//             size: 20,
//           ),
//         ),
//
//         const SizedBox(width: 13),
//
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF163A35),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _ProfileActionCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Color color;
//
//   const _ProfileActionCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(17),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.11),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 24,
//             ),
//           ),
//           const SizedBox(height: 14),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF163A35),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Text(
//                 'View',
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w700,
//                   color: color,
//                 ),
//               ),
//               const Spacer(),
//               Icon(
//                 Icons.arrow_forward_rounded,
//                 size: 16,
//                 color: color,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ProfileMenuTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Color color;
//   final bool showDivider;
//
//   const _ProfileMenuTile({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.color,
//     this.showDivider = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: color,
//                   size: 21,
//                 ),
//               ),
//
//               const SizedBox(width: 13),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF163A35),
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 14,
//                 color: Colors.grey.shade400,
//               ),
//             ],
//           ),
//         ),
//
//         if (showDivider)
//           Padding(
//             padding: const EdgeInsets.only(left: 73),
//             child: Divider(
//               height: 1,
//               color: Colors.grey.shade100,
//             ),
//           ),
//       ],
//     );
//   }
// }