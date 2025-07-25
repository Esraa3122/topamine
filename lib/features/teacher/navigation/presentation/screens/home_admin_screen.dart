import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:test/core/style/color/colors_dark.dart';
import 'package:test/core/style/color/colors_light.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/core/utils/admin_drawer_list.dart';
import 'package:test/features/teacher/navigation/presentation/screens/navigation_teacher_screen.dart';
import 'package:test/features/teacher/navigation/presentation/teacher_app_bar.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  Widget page = const NavigationTeacherScreen();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Builder(
        builder: (context) {
          return MenuAdminScreen(
            onPageChanged: (a) {
              setState(() {
                page = a;
              });
              ZoomDrawer.of(context)!.close();
            },
          );
        },
      ),
      mainScreen: page,
      borderRadius: 24,
      showShadow: true,
      drawerShadowsBackgroundColor: ColorsDark.mainColor.withOpacity(0.6),
      menuBackgroundColor: ColorsDark.blueDark,
    );
  }
}

class MenuAdminScreen extends StatelessWidget {
  const MenuAdminScreen({required this.onPageChanged, super.key});
  final void Function(Widget) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.pinkDark,
      appBar: const TeacherAppBar(
        isMain: false,
        backgroundColor: ColorsLight.pinkDark,
        title: 'Topamine',
      ),
      body: Column(
        children: [
          Column(
            children: profileDrawerList(context)
                .map(
                  (e) => ListTile(
                    onTap: () {
                      onPageChanged(e.page);
                    },
                    title: e.title,
                    leading: e.icon,
                  ),
                )
                .toList(),
          ),
          Expanded(child: Image.asset(AppImages.logo))
        ],
      ),
    );
  }
}
