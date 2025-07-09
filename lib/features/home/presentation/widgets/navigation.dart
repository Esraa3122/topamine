// import 'package:flutter/material.dart';
// import 'package:test/features/booking/presentation/screen/booking_page.dart';
// import 'package:test/features/home/presentation/screens/home_page.dart';
// import 'package:test/features/search/presentation/screen/search_page.dart';
// import 'package:test/features/student/profile/presentation/screens/student_profile2.dart';

// class Navigation extends StatefulWidget {
//   const Navigation({super.key});

//   @override
//   State<Navigation> createState() => _NavigationState();
// }

// class _NavigationState extends State<Navigation> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = const [
//     HomePage(),
//     SearchPage(),
//     BookingPage(),
//     StudentProfile2(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: _screens[_currentIndex],
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 15,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           type: BottomNavigationBarType.fixed,
//           currentIndex: _currentIndex,
//           selectedItemColor: Colors.blue.shade700,
//           unselectedItemColor: Colors.grey.shade400,
//           showSelectedLabels: true,
//           showUnselectedLabels: false,
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           items: [
//             _buildNavItem(Icons.home, 'Home', 0),
//             _buildNavItem(Icons.search, 'Search', 1),
//             _buildNavItem(Icons.calendar_month, 'Booking', 2),
//             _buildNavItem(Icons.person, 'Profile', 3),
//           ],
//         ),
//       ),
//     );
//   }

//   BottomNavigationBarItem _buildNavItem(
//     IconData icon,
//     String label,
//     int index,
//   ) {
//     final isSelected = _currentIndex == index;
//     return BottomNavigationBarItem(
//       label: label,
//       icon: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//         decoration: isSelected
//             ? BoxDecoration(
//                 color: Colors.blue.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(15),
//               )
//             : null,
//         child: Icon(icon, size: 24),
//       ),
//     );
//   }
// }
