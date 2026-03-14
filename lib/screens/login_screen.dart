// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  void login() async {

    setState(() {
      loading = true;
    });

    final result = await ApiService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      loading = false;
    });

    if(result["token"] != null){

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("token", result["token"]);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["error"] ?? "Login failed")),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

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

        child: Center(

          child: SingleChildScrollView(

            child: Container(

              margin: const EdgeInsets.symmetric(horizontal: 25),

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(

                children: [

                  const Text(
                    "DartBank",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Welcome back",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(

                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(

                      onPressed: loading ? null : login,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E7C66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                    ),

                  ),

                  const SizedBox(height: 20),

                  TextButton(

                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );

                    },

                    child: const Text("Create new account"),

                  )

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}