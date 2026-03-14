// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  List transactions = [];
  bool loading = true;
  String myAccount = "";

  @override
  void initState() {
    super.initState();
    loadAccount();
    loadTransactions();
  }

  void loadTransactions() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if(token != null){

      final data = await ApiService.getTransactions(token);

      setState(() {
        transactions = data;
        loading = false;
      });

    }

  }

  void loadAccount() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if(token != null){

      final data = await ApiService.getAccount(token);

      setState(() {
        myAccount = data["account_number"];
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F7F7),

      appBar: AppBar(
        title: const Text(
          "Transaction History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0E7C66),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: transactions.length,

        itemBuilder: (context, index){

          final tx = transactions[index];

          bool isIncome = tx["to_account"] == myAccount;

          return Container(

            margin: const EdgeInsets.only(bottom: 12),

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                )
              ],

            ),

            child: Row(

              children: [

                Container(

                  width: 45,
                  height: 45,

                  decoration: BoxDecoration(
                    color: isIncome
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    isIncome
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),

                ),

                const SizedBox(width: 15),

                Expanded(

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        "${tx["from_account"]} → ${tx["to_account"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        tx["created_at"] ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                    ],

                  ),

                ),

                Text(
                  "${tx["amount"]} VND",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                )

              ],

            ),

          );

        },

      ),

    );

  }

}