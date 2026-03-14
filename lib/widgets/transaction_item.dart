// lib/widgets/transaction_item.dart

import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {

  final Map tx;
  final String myAccount;

  const TransactionItem({
    super.key,
    required this.tx,
    required this.myAccount,
  });

  @override
  Widget build(BuildContext context) {

    bool isIncome = tx["to_account"] == myAccount;

    return Card(

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: ListTile(

        leading: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIncome ? Colors.green : Colors.red,
        ),

        title: Text(
          "${tx["amount"]} VND",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),

        subtitle: Text(
          "${tx["from_account"]} → ${tx["to_account"]}",
        ),

        trailing: Text(
          tx["created_at"] ?? "",
          style: const TextStyle(fontSize: 12),
        ),

      ),

    );

  }

}