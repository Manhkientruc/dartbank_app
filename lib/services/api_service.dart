// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "http://192.168.0.105:8000";

  static Future<Map<String, dynamic>> login(
      String email,
      String password
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    return jsonDecode(response.body);
  }

  static Future getAccount(String token) async {

    final response = await http.get(
      Uri.parse("$baseUrl/accounts/me"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    return jsonDecode(response.body);
  }

  static Future transfer(
      String token,
      String fromAccount,
      String toBank,
      String toAccount,
      double amount
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/transfer"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "from_account": fromAccount,
        "to_bank": toBank,
        "to_account": toAccount,
        "amount": amount
      }),
    );

    return jsonDecode(response.body);
  }

  static Future getTransactions(String token) async {

    final response = await http.get(
      Uri.parse("$baseUrl/transactions"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    return jsonDecode(response.body);
  }

  static Future getQr(String token) async {

    final response = await http.get(
      Uri.parse("$baseUrl/accounts/qr"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    return jsonDecode(response.body);
  }

  static Future register(
      String fullName,
      String email,
      String phone,
      String citizenId,
      String password
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/users/register"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "citizen_id": citizenId,
        "password": password
      }),
    );

    return jsonDecode(response.body);
  }
}