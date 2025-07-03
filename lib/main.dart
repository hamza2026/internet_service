import 'package:flutter/material.dart';
import 'package:internet_connectivity/internet_connectivity/getx/internet_connectivity_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet Connectivity Testing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: InternetConnectivityView(),
    );
  }
}
