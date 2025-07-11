part of 'student_navigation_cubit.dart';

@freezed
class StudentNavigationState with _$StudentNavigationState {
  const factory StudentNavigationState.initial() = _Initial;
  const factory StudentNavigationState.barSelectedIcons({required NavBarEnum navBarEnum}) = 
  BarSelectedIconsState;
}
