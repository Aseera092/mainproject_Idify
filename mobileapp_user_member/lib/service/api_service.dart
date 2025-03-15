import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.51.13:8080"; // Change this
  // static const String baseUrl = "http://localhost:8080";


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
      if (responseData['status'] == true ) {
        return responseData['data']; // Return the first user in the list
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
  static Future<http.Response> addComplaint(Map<String, dynamic> complaintData) async {
    final Uri url = Uri.parse("$baseUrl/complaint"); // Adjust based on your API route
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(complaintData),
      );
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
  
   // Get Complaints API
  static Future<List<Map<String, dynamic>>> getComplaints() async {
    final Uri url = Uri.parse("$baseUrl/complaints"); // Match backend route
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          return List<Map<String, dynamic>>.from(responseData['data']); // Convert JSON list to Dart list
        } else {
          throw Exception("Failed to fetch complaints: ${responseData['message']}");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
  // // Delete Complaint API
  // static Future<http.Response> deleteComplaint(String complaintId) async {
  //   final Uri url = Uri.parse("$baseUrl/complaint/$complaintId"); // Match backend route
  //   try {
  //     final response = await http.delete(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //       },
  //     );
  //     return response;
  //   } catch (e) {
  //     throw Exception("Error: $e");
  //   }
  // }

   // Notification API
  static Future<http.Response> sendNotification(Map<String, dynamic> notificationData) async {
    final Uri url = Uri.parse("$baseUrl/notifications"); // Adjust based on your API route
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(notificationData),
      );
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final Uri url = Uri.parse("$baseUrl/notifications");
    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json"
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          throw Exception("Failed to fetch notifications: ${responseData['message']}");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

}





