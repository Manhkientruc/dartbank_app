// lib/screens/transfer_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class TransferScreen extends StatefulWidget {

  final String fromAccount;
  final String? toAccount;
  final String? toBank;

  const TransferScreen({
    super.key,
    required this.fromAccount,
    this.toAccount,
    this.toBank,
  });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {

  final toAccountController = TextEditingController();
  final amountController = TextEditingController();

  String selectedBank = "DBK";

  final banks = [
    {"name": "DartBank", "code": "DBK"},
    {"name": "KTBank", "code": "KTB"},
  ];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    if(widget.toAccount != null){
      toAccountController.text = widget.toAccount!;
    }

    if(widget.toBank != null){
      selectedBank = widget.toBank!;
    }
  }

  void sendMoney() async {

    setState(() {
      loading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final result = await ApiService.transfer(
      token!,
      widget.fromAccount,
      selectedBank,
      toAccountController.text,
      double.parse(amountController.text),
    );

    setState(() {
      loading = false;
    });

    if(result["error"] == null){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transfer successful")),
      );

      Navigator.pop(context);

    }else{

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["error"] ?? "Transfer failed")),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F7F7),

      appBar: AppBar(
        title: const Text(
          "Transfer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0E7C66),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            // SOURCE ACCOUNT CARD
            Container(

              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  )
                ],
              ),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    "From Account",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.fromAccount,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )

                ],

              ),

            ),

            const SizedBox(height: 20),

            // RECEIVER BANK
            DropdownButtonFormField<String>(
              value: selectedBank,
              decoration: InputDecoration(
                labelText: "Receiver Bank",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: banks.map((bank) {
                return DropdownMenuItem(
                  value: bank["code"],
                  child: Text(bank["name"]!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBank = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // RECEIVER ACCOUNT
            TextField(

              controller: toAccountController,

              decoration: InputDecoration(

                labelText: "Receiver Account",

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

              ),

            ),

            const SizedBox(height: 20),

            // AMOUNT
            TextField(

              controller: amountController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(

                labelText: "Amount",

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

              ),

            ),

            const SizedBox(height: 40),

            // SEND BUTTON
            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                onPressed: loading ? null : sendMoney,

                style: ElevatedButton.styleFrom(

                  backgroundColor: const Color(0xFF0E7C66),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),

                ),

                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Send Money",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),

            )

          ],

        ),

      ),

    );

  }

}