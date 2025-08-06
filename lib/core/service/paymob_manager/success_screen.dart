import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/core/service/paymob_manager/paymob_manager.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class PaymentSuccessScreen extends StatefulWidget {

  const PaymentSuccessScreen({
    required this.orderId, required this.course, super.key,
  });
  final String orderId;
  final CoursesModel course;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool isLoading = true;
  String message = 'جارٍ تأكيد الدفع...';

  @override
  void initState() {
    super.initState();
    _confirmPayment();
  }

  Future<void> _confirmPayment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        message = 'لم يتم تسجيل الدخول!';
        isLoading = false;
      });
      return;
    }

    try {
      await PaymobManager().confirmPayment(
        orderId: widget.orderId,
        userId: user.uid,
        userName: user.displayName ?? 'Unknown',
        userEmail: user.email ?? 'unknown@mail.com',
        courseId: widget.course.id ?? '0',
        courseName: widget.course.title,
        courseDescription: widget.course.subTitle ?? 'No description',
        courseImage: widget.course.imageUrl ?? '',
        price: widget.course.price ?? 0,
      );
      setState(() {
        message = 'تم الدفع بنجاح وتم الاشتراك!';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        message = 'خطأ أثناء التأكيد: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نتيجة الدفع')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('رجوع'),
                  ),
                ],
              ),
      ),
    );
  }
}
