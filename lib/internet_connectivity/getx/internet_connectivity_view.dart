import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connectivity/internet_connectivity/getx/internet_connectivity_controller.dart';

class InternetConnectivityView extends StatefulWidget {
  const InternetConnectivityView({super.key});

  @override
  State<InternetConnectivityView> createState() =>
      _InternetConnectivityViewState();
}

class _InternetConnectivityViewState
    extends State<InternetConnectivityView> {
  final controller = InternetController.to;

  @override
  void initState() {
    super.initState();

    /// 🔁 Either one-time check:
    controller.checkConnection();

    /// 🔁 OR start monitoring if needed:
    // controller.toggleMonitoring(enable: true);
  }

  @override
  void dispose() {
    /// Stop monitoring if you started it in initState
    // controller.toggleMonitoring(enable: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internet Connectivity Test"),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() {
          final status = controller.connectionStatus.value;

          final text = switch (status) {
            ConnectivityStatus.online => "Connected ✅",
            ConnectivityStatus.offline => "Disconnected ❌",
            ConnectivityStatus.checking => "Checking 🔄",
          };

          return Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          );
        }),
      ),
    );
  }
}
