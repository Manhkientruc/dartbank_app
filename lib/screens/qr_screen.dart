// lib/screens/qr_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/api_service.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {

  String account = "";
  String qrBase64 = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadQr();
  }

  void loadQr() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null) {

      final data = await ApiService.getQr(token);

      setState(() {
        account = data["account"];
        qrBase64 = data["qr"];
        loading = false;
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F7F7),

      appBar: AppBar(
        title: const Text(
          "Receive Money",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0E7C66),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(

        child: loading
            ? const CircularProgressIndicator()
            : Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(

              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(

                color: Colors.white,
                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  )
                ],

              ),

              child: Column(

                children: [

                  const Text(
                    "Scan this QR to send money",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Image.memory(
                    base64Decode(qrBase64),
                    width: 220,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    account,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],

              ),

            ),

            const SizedBox(height: 30),

            Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                _actionButton(Icons.download, "Save"),
                const SizedBox(width: 30),
                _actionButton(Icons.share, "Share"),

              ],

            )

          ],

        ),

      ),

    );

  }

  Widget _actionButton(IconData icon, String title) {

    return Column(

      children: [

        Container(

          width: 55,
          height: 55,

          decoration: BoxDecoration(
            color: const Color(0xFF14A38B),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color: Colors.white,
          ),

        ),

        const SizedBox(height: 6),

        Text(title)

      ],

    );

  }

}