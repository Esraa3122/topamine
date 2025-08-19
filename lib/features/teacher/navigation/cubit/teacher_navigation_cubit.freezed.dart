// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_navigation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherNavigationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherNavigationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherNavigationState()';
}


}

/// @nodoc
class $TeacherNavigationStateCopyWith<$Res>  {
$TeacherNavigationStateCopyWith(TeacherNavigationState _, $Res Function(TeacherNavigationState) __);
}


/// @nodoc


class _Initial implements TeacherNavigationState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherNavigationState.initial()';
}


}




/// @nodoc


class BarSelectedIconsState implements TeacherNavigationState {
  const BarSelectedIconsState({required this.navBarEnum});
  

 final  NavBarEnum2 navBarEnum;

/// Create a copy of TeacherNavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarSelectedIconsStateCopyWith<BarSelectedIconsState> get copyWith => _$BarSelectedIconsStateCopyWithImpl<BarSelectedIconsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarSelectedIconsState&&(identical(other.navBarEnum, navBarEnum) || other.navBarEnum == navBarEnum));
}


@override
int get hashCode => Object.hash(runtimeType,navBarEnum);

@override
String toString() {
  return 'TeacherNavigationState.barSelectedIcons(navBarEnum: $navBarEnum)';
}


}

/// @nodoc
abstract mixin class $BarSelectedIconsStateCopyWith<$Res> implements $TeacherNavigationStateCopyWith<$Res> {
  factory $BarSelectedIconsStateCopyWith(BarSelectedIconsState value, $Res Function(BarSelectedIconsState) _then) = _$BarSelectedIconsStateCopyWithImpl;
@useResult
$Res call({
 NavBarEnum2 navBarEnum
});




}
/// @nodoc
class _$BarSelectedIconsStateCopyWithImpl<$Res>
    implements $BarSelectedIconsStateCopyWith<$Res> {
  _$BarSelectedIconsStateCopyWithImpl(this._self, this._then);

  final BarSelectedIconsState _self;
  final $Res Function(BarSelectedIconsState) _then;

/// Create a copy of TeacherNavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? navBarEnum = null,}) {
  return _then(BarSelectedIconsState(
navBarEnum: null == navBarEnum ? _self.navBarEnum : navBarEnum // ignore: cast_nullable_to_non_nullable
as NavBarEnum2,
  ));
}


}

// dart format on
