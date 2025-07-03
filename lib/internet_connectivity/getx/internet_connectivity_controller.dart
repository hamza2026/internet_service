import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

enum ConnectivityStatus { online, offline, checking }

class InternetController extends GetxController {
  static InternetController get to => Get.put<InternetController>(InternetController());
  final Rx<ConnectivityStatus> connectionStatus = ConnectivityStatus.checking.obs;

  final List<String> _urlsToCheck = const ['https://google.com', 'https://github.com'];

  Timer? _timer;
  StreamSubscription? _subscription;
  final RxBool _isMonitoring = false.obs;
  Duration _interval = const Duration(seconds: 5);

  /// Manually trigger a one-time connection check
  Future<void> checkConnection() async {
    connectionStatus.value = ConnectivityStatus.checking;
    final isConnected = await _checkUrls();
    connectionStatus.value = isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline;
    _log('🔎 Manual Check → ${connectionStatus.value.name}');
  }

  /// Start or stop monitoring (based on [enable])
  void toggleMonitoring({bool enable = true, Duration? interval}) {
    _isMonitoring.value = enable;

    if (enable) {
      _interval = interval ?? const Duration(seconds: 5);
      _log('📡 Monitoring started every $_interval');

      _checkAndEmit(); // initial check
      _timer?.cancel();
      _timer = Timer.periodic(_interval, (_) => _checkAndEmit());
    } else {
      _timer?.cancel();
      _log('🛑 Monitoring stopped');
    }
  }

  /// Internal stream-style check
  void _checkAndEmit() async {
    final isConnected = await _checkUrls();
    connectionStatus.value = isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline;
    _log('📶 Stream Update → ${connectionStatus.value.name}');
  }

  /// Actual ping logic
  // Future<bool> _checkUrls() async {
  //   for (final url in _urlsToCheck) {
  //     try {
  //       final request = await HttpClient().headUrl(Uri.parse(url));
  //       final response = await request.close();
  //       if (response.connectionInfo != null) return true;
  //     } catch (_) {}
  //   }
  //   return false;
  // }
  Future<bool> _checkUrls() async {
    const timeoutDuration = Duration(seconds: 3);

    for (final url in _urlsToCheck) {
      try {
        final request = await HttpClient().headUrl(Uri.parse(url))
            .timeout(timeoutDuration); // Request timeout
        final response = await request.close().timeout(timeoutDuration); // Response timeout

        if (response.connectionInfo != null) return true;
      } catch (e) {
        _log('⏱️ Timeout or error for: $url → $e');
      }
    }
    return false;
  }


  /// Logs with emoji
  void _log(String message) {
    if (kDebugMode) {
      print('[🌍 InternetController] $message');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _subscription?.cancel();
    _log('♻️ Controller disposed');
    super.onClose();
  }
}
