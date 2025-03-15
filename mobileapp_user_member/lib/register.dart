

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:idfy_user_application/welcomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'service/api_service.dart';
import 'viewprofile.dart'; // Import viewprofile.dart

class Register extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  File? _rationCardImage;
  final picker = ImagePicker();
  bool _isLoading = false;
  String _latitude='0',_longitude='0';
  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alternatePhoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _rationCardNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _wardNoController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _rationCardImage = File(pickedFile.path);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image Selected Successfully"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No Image Selected"),
            backgroundColor: Colors.amber,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) => {
      print(value),
      _latitude = value.latitude.toString(),
      _longitude = value.longitude.toString()
    });
  }

  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}



  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (_rationCardImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please upload your ration card image"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      String? base64Image;
      if (_rationCardImage != null) {
        List<int> imageBytes = await _rationCardImage!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      try {
        var response = ApiService.createUser({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'MobileNo': _phoneController.text,
          'alternateMobileNo': _alternatePhoneController.text,
          'Address': _addressController.text,
          'dob': _dobController.text,
          'pincode': _pincodeController.text,
          'longitude': _longitude, // Default value
          'latitude': _latitude, // Default value
          'district': _districtController.text,
          'country': _countryController.text,
          'rationCardNo': _rationCardNoController.text,
          'upload_rationcard': base64Image,
          'password': _passwordController.text,
          'wardNo': _wardNoController.text,
        });

        response.then((onValue) async {
          setState(() {
            _isLoading = false;
          });

          try {
            final responseData = json.decode(utf8.decode(onValue.bodyBytes));

            if (responseData != null && responseData['status'] == true && responseData['data'] is List && responseData['data'].isNotEmpty) {
              final userData = responseData['data'][0];
              if (userData != null && userData['_id'] != null) {
                String userId = userData['_id'].toString();
                print("User ID: $userId");

                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('userId', userId);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Registration Successful"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _clearFields();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Viewprofileuser(userId: userId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Registration Successful, but user ID not found."),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Welcome()),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Registration Failed: Invalid response format."),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Registration Failed: ${e.toString()}"),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Welcome()),
            );
          }
        }).catchError((onError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Registration Failed: ${onError.toString()}"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Welcome()),
          );
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Registration Failed: $e"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _clearFields() {
    setState(() {
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _alternatePhoneController.clear();
      _addressController.clear();
      _dobController.clear();
      _pincodeController.clear();
      _districtController.clear();
      _countryController.clear();
      _rationCardNoController.clear();
      _rationCardImage = null;
      _passwordController.clear();
      _wardNoController.clear();
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    if (value.length < 10) {
      return "Phone number must be at least 10 digits";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return "Pincode is required";
    }
    if (value.length != 6 || int.tryParse(value) == null) {
      return "Please enter a valid 6-digit pincode";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IDify Registration"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.withOpacity(0.1), Colors.white],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "Create Your Account",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Personal Information Section
                      _buildSectionHeader("Personal Information"),
                      _buildCustomTextField(
                        controller: _firstNameController, 
                        label: "First Name",
                        icon: Icons.person,
                        validator: (value) => value!.isEmpty ? "First name is required" : null,
                      ),
                      _buildCustomTextField(
                        controller: _lastNameController, 
                        label: "Last Name",
                        icon: Icons.person_outline,
                        validator: (value) => value!.isEmpty ? "Last name is required" : null,
                      ),
                      _buildCustomTextField(
                        controller: _emailController, 
                        label: "Email",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      _buildCustomTextField(
                        controller: _passwordController, 
                        label: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                        validator: _validatePassword,
                      ),
                      
                      // Contact Information Section
                      _buildSectionHeader("Contact Information"),
                      _buildCustomTextField(
                        controller: _phoneController, 
                        label: "Phone Number",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      _buildCustomTextField(
                        controller: _alternatePhoneController, 
                        label: "Alternate Phone Number",
                        icon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isNotEmpty && value.length < 10 ? "Enter valid phone number" : null,
                      ),
                      
                      // Address Section
                      _buildSectionHeader("Address Details"),
                      _buildCustomTextField(
                        controller: _addressController, 
                        label: "Address",
                        icon: Icons.home,
                        validator: (value) => value!.isEmpty ? "Address is required" : null,
                      ),
                      _buildCustomTextField(
                        controller: _pincodeController, 
                        label: "Pincode",
                        icon: Icons.location_on,
                        keyboardType: TextInputType.number,
                        validator: _validatePincode,
                      ),
                      DropdownButtonFormField<int>(
                        value: int.tryParse(_wardNoController.text),
                        decoration: InputDecoration(
                          labelText: "Ward No",
                          prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: List.generate(19, (index) => index + 1)
                            .map((wardNo) => DropdownMenuItem(
                                  value: wardNo,
                                  child: Text(wardNo.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _wardNoController.text = value.toString();
                          });
                        },
                        validator: (value) => value == null ? "Ward No is required" : null,
                      ), 
                      SizedBox(height: 10,),
                         _buildCustomTextField(
                        controller: _districtController, 
                        label: "District",
                        icon: Icons.location_city,
                        validator: (value) => value!.isEmpty ? "District is required" : null,
                      ),
                      _buildCustomTextField(
                        controller: _countryController, 
                        label: "Country",
                        icon: Icons.flag,
                        validator: (value) => value!.isEmpty ? "Country is required" : null,
                      ),
                      
                      // ID Information Section
                      _buildSectionHeader("Identification"),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Date of Birth",
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          ),
                          child: Text(
                            _dobController.text.isEmpty ? "Select Date" : _dobController.text,
                            style: TextStyle(
                              color: _dobController.text.isEmpty ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildCustomTextField(
                        controller: _rationCardNoController, 
                        label: "Ration Card Number",
                        icon: Icons.credit_card,
                        validator: (value) => value!.isEmpty ? "Ration card number is required" : null,
                      ),
                      SizedBox(height: 16),
                      
                      // Ration Card Upload Section
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Upload Ration Card",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                if (_rationCardImage != null) ...[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _rationCardImage!,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                                ElevatedButton.icon(
                                  onPressed: _pickImage,
                                  icon: Icon(Icons.upload_file),
                                  label: Text(_rationCardImage == null ? "Select Image" : "Change Image"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Register Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerUser,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "REGISTER",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        obscureText: isPassword,
        validator: validator,
      ),
    );
  }
}