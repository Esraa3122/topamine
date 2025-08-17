import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:test/core/service/shared_pref/pref_keys.dart';

class PaymobManager {
  String lastOrderId = '';

  Future<String> createPayment({
    required int amount,
    required String currency,
    required String userId,
    required String userName,
    required String userEmail,
    required String courseId,
    required String courseName,
    required String courseDescription,
    required String courseImage,
  }) async {
    if (kDebugMode) {
      print('---- CREATE PAYMENT START ----');
    }
    if (kDebugMode) {
      print('Amount: $amount, Currency: $currency, User: $userEmail');
    }

    try {
      final authToken = await _getAuthenticationToken();
      if (kDebugMode) {
        print('Auth Token: $authToken');
      }

      final orderId = await _getOrderId(
        authenticationToken: authToken,
        amount: (100 * amount).toString(),
        currency: currency,
        redirectUrl: 'https://yourapp.com/payment-success',
      );
      lastOrderId = orderId.toString();
      if (kDebugMode) {
        print('Order ID: $lastOrderId');
      }

      final paymentKey = await _getPaymentKey(
        authenticationToken: authToken,
        orderId: lastOrderId,
        amount: (100 * amount).toString(),
        currency: currency,
        userName: userName,
        userEmail: userEmail,
      );
      if (kDebugMode) {
        print('Payment Key: $paymentKey');
      }

      await _savePaymentDataToFirestore(
        amount: amount,
        currency: currency,
        orderId: lastOrderId,
        paymentKey: paymentKey,
        status: 'pending',
        userId: userId,
        userName: userName,
        userEmail: userEmail,
        courseId: courseId,
        courseName: courseName,
        courseDescription: courseDescription,
        courseImage: courseImage,
      );
      if (kDebugMode) {
        print('Saved payment data to Firestore');
      }

      return paymentKey;
    } catch (e, s) {
      if (kDebugMode) {
        print('Pay error: $e');
      }
      if (kDebugMode) {
        print('Stacktrace: $s');
      }
      throw Exception('Failed to create payment');
    }
  }

  Future<void> confirmPayment({
    required String orderId,
    required String userId,
    required String userName,
    required String userEmail,
    required String courseId,
    required String courseName,
    required String courseDescription,
    required String courseImage,
    required num price,
  }) async {
    try {
      if (kDebugMode) {
        print('---- CONFIRM PAYMENT ----');
      }
      if (kDebugMode) {
        print('Order ID: $orderId');
      }

      await FirebaseFirestore.instance
        .collection('payments')
        .doc(orderId)
        .update({'status': 'success'});

        if (kDebugMode) {
          print('Payment $orderId updated to paid');
        }

      await saveCourseEnrollment(
        userId: userId,
        courseId: courseId,
        courseName: courseName,
        courseDescription: courseDescription,
        courseImage: courseImage,
        price: price,
        orderId: orderId,
        userName: userName,
        userEmail: userEmail,
      );
      if (kDebugMode) {
        print('Enrollment saved');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error confirming payment: $e');
      }
    }
  }

  Future<void> saveCourseEnrollment({
    required String userId,
    required String courseId,
    required String courseName,
    required String courseDescription,
    required String courseImage,
    required num price,
    required String orderId,
    required String userName,
    required String userEmail,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('enrollments').add({
        'userId': userId,
        'courseId': courseId,
        'courseName': courseName,
        'courseDescription': courseDescription,
        'courseImage': courseImage,
        'price': price,
        'orderId': orderId,
        'userName': userName,
        'userEmail': userEmail,
        'status': 'enrolled',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error saving course enrollment: $e');
      }
    }
  }

  Future<String> _getAuthenticationToken() async {
    final response = await Dio().post(
      'https://accept.paymob.com/api/auth/tokens',
      data: {'api_key': PrefKeys.apiKey},
    );
    if (kDebugMode) {
      print('Auth Response: ${response.statusCode} -> ${response.data}');
    }
    return response.data['token'].toString();
  }

  Future<int> _getOrderId({
    required String authenticationToken,
    required String amount,
    required String currency,
    required String redirectUrl,
  }) async {
    final response = await Dio().post(
      'https://accept.paymob.com/api/ecommerce/orders',
      data: {
        'auth_token': authenticationToken,
        'amount_cents': amount,
        'currency': currency,
        'delivery_needed': 'false',
        'items': [],
        'merchant_order_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'redirect_url': redirectUrl,
      },
    );
    if (kDebugMode) {
      print('Order Response: ${response.statusCode} -> ${response.data}');
    }
    return int.parse(response.data['id'].toString());
  }

  Future<String> _getPaymentKey({
    required String authenticationToken,
    required String orderId,
    required String amount,
    required String currency,
    required String userName,
    required String userEmail,
  }) async {
    try {
      final response = await Dio().post(
        'https://accept.paymob.com/api/acceptance/payment_keys',
        data: {
          'expiration': 3600,
          'auth_token': authenticationToken,
          'order_id': orderId,
          'integration_id': PrefKeys.integartionIdcard,
          'amount_cents': amount,
          'currency': currency,
          'billing_data': {
            'first_name': 'Esraa',
            'last_name': 'Elshike',
            'email': userEmail,
            'phone_number': '+201006933534',
            'apartment': '1',
            'floor': '1',
            'street': 'Test Street',
            'building': '123',
            'shipping_method': 'PKG',
            'postal_code': '12345',
            'city': 'Cairo',
            'country': 'EG',
            'state': 'Cairo',
          },
        },
      );
      if (kDebugMode) {
        print('PaymentKey Response: ${response.statusCode} -> ${response.data}');
      }
      return response.data['token'].toString();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('PaymentKey Error Data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<void> _savePaymentDataToFirestore({
    required int amount,
    required String currency,
    required String orderId,
    required String paymentKey,
    required String status,
    required String userId,
    required String userName,
    required String userEmail,
    required String courseId,
    required String courseName,
    required String courseDescription,
    required String courseImage,
  }) async {
    await FirebaseFirestore.instance.collection('payments').doc(orderId).set({
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'courseId': courseId,
      'courseName': courseName,
      'courseDescription': courseDescription,
      'courseImage': courseImage,
      'amount': amount,
      'currency': currency,
      'orderId': orderId,
      'paymentKey': paymentKey,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:test/core/service/shared_pref/pref_keys.dart';

// class PaymobManager {
//   Future<String> getPaymentKey({
//     required int amount,
//     required String currency,
//     required String userId,
//     required String userName,
//     required String userEmail,
//     required String courseId,
//     required String courseName,
//     required String courseDescription,
//   }) async {
//     try {
//       String authenticationToken = await _getAuthenticationToken();
//       int orderId = await _getOrderId(
//         amount: (100 * amount).toString(),
//         authenticationToken: authenticationToken,
//         currency: currency,
//       );

//       String paymentKey = await _getPaymentKey(
//         authenticationToken: authenticationToken,
//         orderId: orderId.toString(),
//         amount: (100 * amount).toString(),
//         currency: currency,
//       );

//       // محاكاة الدفع
//       bool success = _simulatePayment(amount);

//       if (success) {
//         await _savePaymentDataToFirestore(
//           amount: amount,
//           currency: currency,
//           orderId: orderId.toString(),
//           paymentKey: paymentKey,
//           status: 'enrolled',
//           userId: userId,
//           userName: userName,
//           userEmail: userEmail,
//           courseId: courseId,
//           courseName: courseName,
//           courseDescription: courseDescription,
//         );
//         print('Payment successful - User enrolled in the course');
//       } else {
//         await _savePaymentDataToFirestore(
//           amount: amount,
//           currency: currency,
//           orderId: orderId.toString(),
//           paymentKey: paymentKey,
//           status: 'failed',
//           userId: userId,
//           userName: userName,
//           userEmail: userEmail,
//           courseId: courseId,
//           courseName: courseName,
//           courseDescription: courseDescription,
//         );
//         print('Payment failed - Data saved with status failed');
//       }

//       return paymentKey;
//     } catch (e) {
//       print('Error in getPaymentKey: $e');
//       throw Exception('Failed to generate payment key');
//     }
//   }

//   Future<void> saveCourseEnrollment({
//   required String userId,
//   required String courseId,
//   required String courseName,
//   required String courseDescription,
//   required String courseImage,
//   required num price,
//   required String orderId,
//   required String userName,
//   required String userEmail,

// }) async {
//   try {
//     await FirebaseFirestore.instance.collection('enrollments').add({
//       'userId': userId,
//       'courseId': courseId,
//       'courseName': courseName,
//       'courseDescription': courseDescription,
//       'courseImage': courseImage,
//       'orderId': orderId,
//       'userName': userName,
//       'userEmail': userEmail,
//       'price': price,
//       'status': 'enrolled',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   } catch (e) {
//     print('Error saving course enrollment: $e');
//   }
// }


//   Future<String> _getAuthenticationToken() async {
//     final Response response = await Dio().post(
//       'https://accept.paymob.com/api/auth/tokens',
//       data: {
//         'api_key': PrefKeys.apiKey,
//       },
//     );
//     return response.data['token'] as String;
//   }

//   Future<int> _getOrderId({
//     required String authenticationToken,
//     required String amount,
//     required String currency,
//   }) async {
//     final Response response = await Dio().post(
//       'https://accept.paymob.com/api/ecommerce/orders',
//       data: {
//         'auth_token': authenticationToken,
//         'amount_cents': amount,
//         'currency': currency,
//         'delivery_needed': 'false',
//         'items': [],
//       },
//     );

//     return response.data['id'] is int
//         ? response.data['id'] as int
//         : int.parse(response.data['id'].toString());
//   }

//   Future<String> _getPaymentKey({
//     required String authenticationToken,
//     required String orderId,
//     required String amount,
//     required String currency,
//   }) async {
//     final Response response = await Dio().post(
//       'https://accept.paymob.com/api/acceptance/payment_keys',
//       data: {
//         'expiration': 3600,
//         'auth_token': authenticationToken,
//         'order_id': orderId,
//         'integration_id': PrefKeys.integartionIdcard,
//         'amount_cents': amount,
//         'currency': currency,
//         'billing_data': {
//           'first_name': 'Esraa',
//           'last_name': 'Elsheikh',
//           'email': 'esraa@gmail.com',
//           'phone_number': '+86(8)9135210487',
//           'apartment': 'NA',
//           'floor': 'NA',
//           'street': 'NA',
//           'building': 'NA',
//           'shipping_method': 'NA',
//           'postal_code': 'NA',
//           'city': 'NA',
//           'country': 'NA',
//           'state': 'NA',
//         },
//       },
//     );

//     return response.data['token'] as String;
//   }

//   Future<void> _savePaymentDataToFirestore({
//     required int amount,
//     required String currency,
//     required String orderId,
//     required String paymentKey,
//     required String status,
//     required String userId,
//     required String userName,
//     required String userEmail,
//     required String courseId,
//     required String courseName,
//     required String courseDescription,
//   }) async {
//     try {
//       await FirebaseFirestore.instance.collection('payments').add({
//         'userId': userId,
//         'userName': userName,
//         'userEmail': userEmail,
//         'courseId': courseId,
//         'courseName': courseName,
//         'courseDescription': courseDescription,
//         'amount': amount,
//         'currency': currency,
//         'orderId': orderId,
//         'paymentKey': paymentKey,
//         'status': status, 
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error saving payment data to Firestore: $e');
//     }
//   }

//   bool _simulatePayment(int amount) {
//     return amount > 0; 
//   }
// }





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:test/core/service/shared_pref/pref_keys.dart';

// class PaymobManager {
//   Future<String> getPaymentKey(int amount, String currency) async {
//     try {
//       String authenticationToken = await _getAuthenticationToken();
//       int orderId = await _getOrderId(
//         amount: (100 * amount).toString(),
//         authenticationToken: authenticationToken,
//         currency: currency,
//       );

//       String paymentKey = await _getPaymentKey(
//         authenticationToken: authenticationToken,
//         orderId: orderId.toString(),
//         amount: (100 * amount).toString(),
//         currency: currency,
//       );

//       await _savePaymentDataToFirestore(
//         amount: amount,
//         currency: currency,
//         orderId: orderId.toString(),
//         paymentKey: paymentKey,
//       );

//       return paymentKey;
//     } catch (e) {
//       print('Error in getPaymentKey: $e');
//       throw Exception('Failed to generate payment key');
//     }
//   }

//   Future<String> _getAuthenticationToken() async {
//     final Response response = await Dio().post(
//       'https://accept.paymob.com/api/auth/tokens',
//       data: {
//         'api_key': PrefKeys.apiKey,
//       },
//     );
//     return response.data['token'] as String;
//   }

//   Future<int> _getOrderId({
//     required String authenticationToken,
//     required String amount,
//     required String currency,
//   }) async {
//     final Response response = await Dio().post(
//       'https://accept.paymob.com/api/ecommerce/orders',
//       data: {
//         'auth_token': authenticationToken,
//         'amount_cents': amount,
//         'currency': currency,
//         'delivery_needed': 'false',
//         'items': [],
//       },
//     );

//     return response.data['id'] is int
//         ? response.data['id'] as int
//         : int.parse(response.data['id'].toString());
//   }

//   Future<String> _getPaymentKey({
//     required String authenticationToken,
//     required String orderId,
//     required String amount,
//     required String currency,
//   }) async {
//     final Response response = await Dio().post(
//       'https://accept.paymob.com/api/acceptance/payment_keys',
//       data: {
//         'expiration': 3600,
//         'auth_token': authenticationToken,
//         'order_id': orderId,
//         'integration_id': PrefKeys.integartionIdcard,
//         'amount_cents': amount,
//         'currency': currency,
//         'billing_data': {
//           // Required fields
//           'first_name': 'Esraa',
//           'last_name': 'Elsheikh',
//           'email': 'esraa@gmail.com',
//           'phone_number': '+86(8)9135210487',

//           // Optional / can be "NA"
//           'apartment': 'NA',
//           'floor': 'NA',
//           'street': 'NA',
//           'building': 'NA',
//           'shipping_method': 'NA',
//           'postal_code': 'NA',
//           'city': 'NA',
//           'country': 'NA',
//           'state': 'NA',
//         },
//       },
//     );

//     return response.data['token'] as String;
//   }

//   Future<void> _savePaymentDataToFirestore({
//     required int amount,
//     required String currency,
//     required String orderId,
//     required String paymentKey,
//   }) async {
//     try {
//       await FirebaseFirestore.instance.collection('payments').add({
//         'amount': amount,
//         'currency': currency,
//         'orderId': orderId,
//         'paymentKey': paymentKey,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error saving payment data to Firestore: $e');
//     }
//   }
// }
