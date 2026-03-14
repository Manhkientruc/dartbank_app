// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final citizenController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  void register() async {

    setState(() {
      loading = true;
    });

    final result = await ApiService.register(
      nameController.text,
      phoneController.text,
      citizenController.text,
      emailController.text,
      passwordController.text,
    );

    setState(() {
      loading = false;
    });

    if(result["user_id"] != null){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register successful")),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["error"] ?? "Register failed")),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: const Color(0xFF0E7C66),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(25),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: citizenController,
              decoration: const InputDecoration(labelText: "Citizen ID"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed: loading ? null : register,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E7C66),
                ),

                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),

              ),

            )

          ],

        ),

      ),

    );

  }

}