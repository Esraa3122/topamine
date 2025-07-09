import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/features/booking/presentation/screen/booking_page.dart';
import 'package:test/features/home/presentation/screens/home_page.dart';
import 'package:test/features/navigation/controller/navigation_controller.dart';
import 'package:test/features/navigation/widgets/navigation_item.dart';
import 'package:test/features/search/presentation/screen/search_page.dart';
import 'package:test/features/teacher/profile/presentation/screens/profile_teacher_screen.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationController(),
      child: const _NavigationView(),
    );
  }
}

class _NavigationView extends StatelessWidget {
  const _NavigationView();

  static final List<Widget> _screens = [
    const HomePage(),
    const SearchPage(),
    const BookingPage(),
    const ProfileTeacherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NavigationController>(context);
    return Scaffold(
      extendBody: true,
      body: _screens[controller.currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex,
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: controller.changeIndex,
          items: [
            _buildNavItem(controller.currentIndex, 0, Icons.home, 'Home'),
            _buildNavItem(controller.currentIndex, 1, Icons.search, 'Search'),
            _buildNavItem(
              controller.currentIndex,
              2,
              Icons.calendar_month,
              'Booking',
            ),
            _buildNavItem(controller.currentIndex, 3, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    int currentIndex,
    int index,
    IconData icon,
    String label,
  ) {
    return BottomNavigationBarItem(
      label: label,
      icon: CustomNavItem(
        icon: icon,
        label: label,
        isSelected: currentIndex == index,
      ),
    );
  }
}
