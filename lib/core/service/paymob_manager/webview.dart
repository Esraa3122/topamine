import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test/core/common/toast/buildawesomedialog.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/paymob_manager/paymob_manager.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    required this.paymentUrl,
    required this.successRedirect,
    required this.course,
    required this.orderId,
    super.key,
  });
  final String paymentUrl;
  final String successRedirect;
  final CoursesModel course;
  final String orderId;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            _handleUrl(request.url);
            return NavigationDecision.navigate;
          },
          onPageStarted: _handleUrl,
          onPageFinished: _handleUrl,
          onWebResourceError: (error) {
            if (kDebugMode) {
              print('WebView error: $error');
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handleUrl(String url) async {
    if (_handled) return;

    final possibleSuccesses = [
      widget.successRedirect,
      'https://accept.paymob.com/api/acceptance/post_pay',
    ];

    final uri = Uri.tryParse(url);
    final hasSuccessParam = uri?.queryParameters['success'] == 'true';
    final isSuccessUrl = possibleSuccesses.any((u) => url.startsWith(u));

    if (isSuccessUrl || hasSuccessParam) {
      _handled = true;
      final orderId = uri?.queryParameters['order_id'] ?? widget.orderId;
      await _onPaymentSuccess(orderId);
    }
  }

  Future<void> _onPaymentSuccess(String orderId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await PaymobManager().confirmPayment(
      orderId: orderId,
      userId: user.uid,
      userName: user.displayName ?? 'Unknown',
      userEmail: user.email ?? 'unknown@email.com',
      courseId: widget.course.id ?? '0',
      courseName: widget.course.title,
      courseDescription: widget.course.subTitle ?? 'No description',
      courseImage: widget.course.imageUrl ?? '',
      price: widget.course.price ?? 0,
    );

    if (!mounted) return;

    buildAwesomeDialogSucces(
      'تم الدفع بنجاح',
      'تم الاشتراك في ${widget.course.title}',
      'اذهب للكورس',
      context,
      () {
        context.pushReplacementNamed(
          AppRoutes.videoPlayerScreen,
          arguments: widget.course,
        );
      },
    );

    //     await showDialog(
    //   context: context,
    //   builder: (_) => AlertDialog(
    //     title: const Text('تم الدفع بنجاح'),
    //     content: Text('تم الاشتراك في ${widget.course.title}'),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //           Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(
    //               builder: (_) => VideoPlayerPage(course: widget.course),
    //             ),
    //           );
    //         },
    //         child: const Text('اذهب للكورس'),
    //       ),
    //     ],
    //   ),
    // );
  }

  Future<void> _markPaymentAsFailed() async {
    try {
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(widget.orderId)
          .update({'status': 'failed'});
      debugPrint('Payment marked as failed.');
    } catch (e) {
      debugPrint('Failed to mark payment as failed: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!_handled) {
      _markPaymentAsFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الدفع عبر Paymob',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.color.bluePinkLight,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
