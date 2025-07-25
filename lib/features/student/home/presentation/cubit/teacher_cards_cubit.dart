import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/features/auth/data/models/user_model.dart';

part 'teacher_cards_state.dart';
part 'teacher_cards_cubit.freezed.dart';

class TeacherCardsCubit extends Cubit<List<UserModel>> {
  TeacherCardsCubit() : super([]);

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  Future<void> getTeachers() async {
        final teacherSnapshot = await _firestore.collection('users')
        .where('role', isEqualTo: 'teacher')
        .where('status', isEqualTo: 'تم القبول')
        .get();
      final currentEmail = FirebaseAuth.instance.currentUser?.email;
      final teachers = teacherSnapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .where((user) => user.userEmail != currentEmail)
        .toList();

      emit(teachers);
  }
}
