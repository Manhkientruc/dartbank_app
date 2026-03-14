// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const DartBankApp());
}

class DartBankApp extends StatelessWidget {
  const DartBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DartBank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}