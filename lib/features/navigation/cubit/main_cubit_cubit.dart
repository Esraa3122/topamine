import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/core/enums/nav_bar_enum.dart';

part 'main_cubit_state.dart';
part 'main_cubit_cubit.freezed.dart';

class MainCubitCubit extends Cubit<MainCubitState> {
  MainCubitCubit() : super(const MainCubitState.initial());

  NavBarEnum navBarEnum = NavBarEnum.home;

  void selectedNavBarIcons(NavBarEnum viewEnum) {
    if (viewEnum == NavBarEnum.home) {
      navBarEnum = NavBarEnum.home;
    } else if (viewEnum == NavBarEnum.search) {
      navBarEnum = NavBarEnum.search;
    } else if (viewEnum == NavBarEnum.booking) {
      navBarEnum = NavBarEnum.booking;
    } else if (viewEnum == NavBarEnum.profile) {
      navBarEnum = NavBarEnum.profile;
    }
    emit(MainCubitState.barSelectedIcons(navBarEnum: navBarEnum));
  }
}
