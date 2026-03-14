// lib/widgets/balance_card.dart

import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {

  final String balance;
  final String accountNumber;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

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
          )

        ],

      ),

    );

  }

}