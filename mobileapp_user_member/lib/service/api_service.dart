import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.40:8080"; // Change this

  static Future<http.Response> createUser(Map<String, dynamic> userData) async {
    final Uri url = Uri.parse("$baseUrl/user"); // Change based on your API route
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<http.Response> login(Map<String, dynamic> credentials) async {
    final Uri url = Uri.parse("$baseUrl/login"); // Change based on your login API route
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(credentials),
      );
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> getUser(String userId) async {
  final Uri url = Uri.parse("$baseUrl/user/$userId");
  try {
    final response = await http.get(url, headers: {"Content-Type": "application/json",});
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == true && responseData['data'] is List && responseData['data'].isNotEmpty) {
        return responseData['data'][0]; // Return the first user in the list
      } else {
        throw Exception("User not found or invalid response format");
      }
    } else {
      throw Exception("Failed to load user: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}

  static Future<http.Response> getLogin(String email) async {
    final Uri url = Uri.parse("$baseUrl/login/$email"); // Change based on your API route
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}