import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String baseUrl = "http://localhost:8080/user"; // Replace with your backend URL

  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData, File? image) async {
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/user"));

    request.headers['Content-Type'] = 'multipart/form-data';

    // Add Text Fields
    userData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add Image File if Available
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        "rationCardImage",
        image.path,
        filename: image.path.split('/').last,
      ));
      print("📸 Image Attached: ${image.path}");
    } else {
      print("❌ No Image Selected");
    }

    try {
      print("🔗 API Calling...");
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print("🌐 Response: $responseData");

      if (response.statusCode == 201) {
        print("✅ Registration Successful");
        return {"status": true, "message": "Registration successful"};
      } else {
        print("❌ Registration Failed: ${json.decode(responseData)?['message'] ?? 'Unknown Error'}");
        return {"status": false, "message": json.decode(responseData)?['message'] ?? 'Unknown Error'};
      }
    } catch (e) {
      print("🔥API Error: $e");
      return {"status": false, "message": e.toString()};
    }
  }
}
