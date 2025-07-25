import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:test/core/service/shared_pref/pref_keys.dart';

class PaymobManager {
  Future<String> getPaymentKey(int amount, String currency) async {
    try {
      String authenticationToken = await _getAuthenticationToken();
      int orderId = await _getOrderId(
        amount: (100 * amount).toString(),
        authenticationToken: authenticationToken,
        currency: currency,
      );

      String paymentKey = await _getPaymentKey(
        authenticationToken: authenticationToken,
        orderId: orderId.toString(),
        amount: (100 * amount).toString(),
        currency: currency,
      );

      await _savePaymentDataToFirestore(
        amount: amount,
        currency: currency,
        orderId: orderId.toString(),
        paymentKey: paymentKey,
      );

      return paymentKey;
    } catch (e) {
      print('Error in getPaymentKey: $e');
      throw Exception('Failed to generate payment key');
    }
  }

  Future<String> _getAuthenticationToken() async {
    final Response response = await Dio().post(
      'https://accept.paymob.com/api/auth/tokens',
      data: {
        'api_key': PrefKeys.apiKey,
      },
    );
    return response.data['token'] as String;
  }

  Future<int> _getOrderId({
    required String authenticationToken,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio().post(
      'https://accept.paymob.com/api/ecommerce/orders',
      data: {
        'auth_token': authenticationToken,
        'amount_cents': amount,
        'currency': currency,
        'delivery_needed': 'false',
        'items': [],
      },
    );

    // تأكد من أن القيمة int
    return response.data['id'] is int
        ? response.data['id'] as int
        : int.parse(response.data['id'].toString());
  }

  Future<String> _getPaymentKey({
    required String authenticationToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio().post(
      'https://accept.paymob.com/api/acceptance/payment_keys',
      data: {
        'expiration': 3600,
        'auth_token': authenticationToken,
        'order_id': orderId,
        'integration_id': PrefKeys.integartionIdcard,
        'amount_cents': amount,
        'currency': currency,
        'billing_data': {
          // Required fields
          'first_name': 'Esraa',
          'last_name': 'Elsheikh',
          'email': 'esraa@gmail.com',
          'phone_number': '+86(8)9135210487',

          // Optional / can be "NA"
          'apartment': 'NA',
          'floor': 'NA',
          'street': 'NA',
          'building': 'NA',
          'shipping_method': 'NA',
          'postal_code': 'NA',
          'city': 'NA',
          'country': 'NA',
          'state': 'NA',
        },
      },
    );

    return response.data['token'] as String;
  }

  Future<void> _savePaymentDataToFirestore({
    required int amount,
    required String currency,
    required String orderId,
    required String paymentKey,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'amount': amount,
        'currency': currency,
        'orderId': orderId,
        'paymentKey': paymentKey,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving payment data to Firestore: $e');
    }
  }
}
