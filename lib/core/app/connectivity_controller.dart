import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityController {
  ConnectivityController._();
  static final ConnectivityController instance = ConnectivityController._();

  final ValueNotifier<bool> isConnected = ValueNotifier(true);
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  Future<void> init() async {
    try {
      final result = await _connectivity
          .checkConnectivity();
      _handleConnectionChange(result);

      _subscription = _connectivity.onConnectivityChanged.listen(
        _handleConnectionChange,
      );
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      isConnected.value = false;
    }
  }

  void _handleConnectionChange(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (r) => r == ConnectivityResult.mobile || r == ConnectivityResult.wifi,
    );
    isConnected.value = hasConnection;
  }

  void dispose() {
    _subscription.cancel();
  }
}
