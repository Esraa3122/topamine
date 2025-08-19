import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/core/enums/nav_bar_enum.dart';

part 'teacher_navigation_state.dart';
part 'teacher_navigation_cubit.freezed.dart';

class TeacherNavigationCubit extends Cubit<TeacherNavigationState> {
  TeacherNavigationCubit() : super(const TeacherNavigationState.initial());

  NavBarEnum2 navBarEnum = NavBarEnum2.home;

  void selectedNavBarIcons(NavBarEnum2 viewEnum) {
    if (viewEnum == NavBarEnum2.home) {
      navBarEnum = NavBarEnum2.home;
    } 
    // else if (viewEnum == NavBarEnum.search) {
    //   navBarEnum = NavBarEnum.search;
    // }
     else if (viewEnum == NavBarEnum2.booking) {
      navBarEnum = NavBarEnum2.booking;
    } else if (viewEnum == NavBarEnum2.profile) {
      navBarEnum = NavBarEnum2.profile;
    }
    emit(TeacherNavigationState.barSelectedIcons(navBarEnum: navBarEnum));
  }
}
