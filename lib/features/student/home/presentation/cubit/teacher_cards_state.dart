part of 'teacher_cards_cubit.dart';

@freezed
class TeacherCardsState with _$TeacherCardsState {
  const factory TeacherCardsState.initial() = _Initial;
  const factory TeacherCardsState.loading() = _Loading;
  const factory TeacherCardsState.loaded(List<UserModel> teachers) = _Loaded;
  const factory TeacherCardsState.error(String message) = _Error;
}
