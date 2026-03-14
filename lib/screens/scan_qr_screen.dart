// lib/screens/scan_qr_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'transfer_screen.dart';
import 'dart:convert';

class ScanQrScreen extends StatefulWidget {

  final String fromAccount;

  const ScanQrScreen({
    super.key,
    required this.fromAccount,
  });

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {

  bool scanned = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          "Scan QR",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(

        children: [

          /// CAMERA
          MobileScanner(

            onDetect: (BarcodeCapture capture) {

              if(scanned) return;

              final String? code = capture.barcodes.first.rawValue;

              if(code == null) return;

              try {

                scanned = true;

                final data = jsonDecode(code);

                final bank = data["bank"];
                final account = data["account"];

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransferScreen(
                      fromAccount: widget.fromAccount,
                      toAccount: account,
                      toBank: bank,
                    ),
                  ),
                );

              } catch (e) {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid QR code")),
                );

              }

            },

          ),

          /// DARK OVERLAY
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          /// SCAN FRAME
          Center(

            child: Container(

              width: 250,
              height: 250,

              decoration: BoxDecoration(

                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),

                borderRadius: BorderRadius.circular(20),

              ),

            ),

          ),

          /// TEXT
          const Positioned(

            top: 120,
            left: 0,
            right: 0,

            child: Center(

              child: Text(

                "Scan QR to pay",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),

              ),

            ),

          ),

          /// BOTTOM TEXT
          Positioned(

            bottom: 60,
            left: 0,
            right: 0,

            child: Center(

              child: Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Text(
                  "Align QR code inside the frame",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

              ),

            ),

          )

        ],

      ),

    );

  }

}