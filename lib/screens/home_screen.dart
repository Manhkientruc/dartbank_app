// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'transfer_screen.dart';
import 'history_screen.dart';
import 'qr_screen.dart';
import 'scan_qr_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String balance = "Loading...";
  String accountNumber = "";
  String fullName = "";

  @override
  void initState() {
    super.initState();
    loadAccount();
  }

  void loadAccount() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if(token != null){

      final data = await ApiService.getAccount(token);

      setState(() {
        balance = "${data["balance"]} VND";
        accountNumber = data["account_number"];
        fullName = data["full_name"];
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F7F7),

      appBar: AppBar(
        title: const Text(
          "DartBank",
          style: TextStyle(color: Colors.white),
        ),

        backgroundColor: const Color(0xFF0E7C66),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        actions: [

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          )

        ],
      ),

      body: SingleChildScrollView(

        child: Column(

          children: [

            // HEADER
            Container(

              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0E7C66),
                    Color(0xFF14A38B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Welcome back",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BALANCE CARD
                  Container(

                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0,4),
                        )
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Account Balance",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          balance,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Account: $accountNumber",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                      ],
                    ),

                  )

                ],
              ),
            ),

            const SizedBox(height: 30),

            // ACTION BUTTONS

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  _menuButton(Icons.send, "Transfer"),
                  _menuButton(Icons.qr_code, "QR"),
                  _menuButton(Icons.history, "History"),
                  _menuButton(Icons.qr_code_scanner, "Scan"),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _menuButton(IconData icon, String title){

    return GestureDetector(

      onTap: () async {

        if(title == "Transfer"){

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransferScreen(
                fromAccount: accountNumber,
              ),
            ),
          );

          loadAccount();

        }

        else if(title == "History"){

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HistoryScreen(),
            ),
          );

        }

        else if(title == "QR"){

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QrScreen(),
            ),
          );

        }

        else if(title == "Scan"){

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScanQrScreen(
                fromAccount: accountNumber,
              ),
            ),
          );

        }

      },

      child: Column(

        children: [

          Container(

            width: 60,
            height: 60,

            decoration: BoxDecoration(
              color: const Color(0xFF14A38B),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),

          ),

          const SizedBox(height: 8),

          Text(title)

        ],
      ),

    );

  }

  void logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
          (route) => false,
    );

  }

}