import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.31.168:8080"; // Change this
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
    final Uri url = Uri.parse("$baseUrl/auth/login"); // Change based on your login API route
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

// getmemberprofile
 Future<Map<String, dynamic>> getMemberById(String memberId) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/member/$memberId'));

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

      if (decodedResponse['status'] == true) {
        return decodedResponse['data'] as Map<String, dynamic>;
      } else {
        throw Exception(
            'API returned status: false. Message: ${decodedResponse['message']}');
      }
    } else {
      throw Exception('Failed to fetch member. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching member: $e');
    rethrow;
  }
  }
  static Future<Map<String, dynamic>> getMember(String memberId) async {
  final Uri url = Uri.parse("$baseUrl/member/$memberId");
  try {
    final response = await http.get(url, headers: {"Content-Type": "application/json",});
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == true ) {
        return responseData['data']; // Return the first user in the list
      } else {
        throw Exception("Member not found or invalid response format");
      }
    } else {
      throw Exception("Failed to load Member: ${response.statusCode}");
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


// membercomplaintview


  // Get complaints for a member with ward number filtering and user details in one call
 static Future<List<Map<String, dynamic>>> getComplaintsAndUserDetails(String wardNo) async {
    final Uri url = Uri.parse("$baseUrl/complaint/get-member/$wardNo"); // Combined endpoint
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          return List<Map<String, dynamic>>.from(responseData['data']); // Return combined data
        } else {
          throw Exception("Failed to fetch complaints and user details: ${responseData['message']}");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
// static Future<List<Map<String, dynamic>>> getmemberComplaints(String wardNo) async {
//     final Uri url = Uri.parse("$baseUrl/complaint/get-member/$wardNo"); // Match the backend endpoint
//     try {
//       final response = await http.get(
//         url,
//         headers: {"Content-Type": "application/json"},
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         if (responseData['status'] == true && responseData['data'] is List) {
//           return List<Map<String, dynamic>>.from(responseData['data']);
//         } else {
//           throw Exception("Failed to fetch complaints: ${responseData['message'] ?? 'Invalid response'}");
//         }
//       } else {
//         throw Exception("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Error: $e");
//     }
//   }

static Future<http.Response> updateComplaintStatus(String id, Map<String, dynamic> data) async {
    final Uri url = Uri.parse("$baseUrl/complaint/$id"); // Combined endpoint
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }


// userEventView
Future<List<Map<String, dynamic>>> getEvents() async {
  final Uri url = Uri.parse("$baseUrl/event"); // Combined endpoint
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == true) {
          List<dynamic> eventData = decodedResponse['data'];
          return eventData.cast<Map<String, dynamic>>();
        } else {
          throw Exception('API returned status: false. Message: ${decodedResponse['message']}');
        }
      } else {
        throw Exception('Failed to fetch events. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      rethrow; // Rethrow the exception to be handled in the UI
    }
  }
}



// // memberprofile


// class AdminMemberService {
//   final String baseUrl;
//   final String adminToken; // Add admin token for authentication

//   AdminMemberService(this.baseUrl, this.adminToken);

//   Future<Map<String, dynamic>> addMemberByAdmin(Map<String, dynamic> memberData) async {
//     final Uri url = Uri.parse('$baseUrl/admin/members'); // Assuming admin endpoint is /admin/members
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $adminToken', // Include admin token in headers
//         },
//         body: jsonEncode(memberData),
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 201) {
//         return responseData;
//       } else {
//         throw Exception(responseData['message'] ?? 'Failed to add member: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error adding member: $e');
//     }
//   }
// }

// class MemberService {
//   final String baseUrl;

//   MemberService(this.baseUrl);

//   Future<List<dynamic>> getMembersForUser() async {
//     final Uri url = Uri.parse('$baseUrl/members/user'); // Assuming your backend route is /members/user
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         if (responseData['status'] == true) {
//           return responseData['data'];
//         } else {
//           throw Exception(responseData['message'] ?? 'Failed to get members: ${response.statusCode}');
//         }
//       } else {
//         throw Exception('Failed to get members: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching members: $e');
//     }
//   }
// }





