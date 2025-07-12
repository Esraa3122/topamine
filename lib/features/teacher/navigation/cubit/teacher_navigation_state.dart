part of 'teacher_navigation_cubit.dart';

@freezed
class TeacherNavigationState with _$TeacherNavigationState {
  const factory TeacherNavigationState.initial() = _Initial;
  const factory TeacherNavigationState.barSelectedIcons({
    required NavBarEnum navBarEnum,
  }) = BarSelectedIconsState;
}
