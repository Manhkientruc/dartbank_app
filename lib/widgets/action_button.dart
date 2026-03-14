// lib/widgets/action_button.dart

import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

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
              size: 28,
            ),

          ),

          const SizedBox(height: 8),

          Text(title)

        ],

      ),

    );

  }

}