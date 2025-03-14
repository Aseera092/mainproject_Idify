

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idfy_user_application/service/api_service.dart'; // Import your ApiService

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController date = TextEditingController();
  final TextEditingController complaint = TextEditingController();
  final TextEditingController description = TextEditingController();
  String? selectedCategory;
  bool _isLoading = false;

  final List<String> categories = [
    'Electrical',
    'Plumbing',
    'Neighbor',
    'Safety',
    'Maintenance',
    'Road',
    'Other'
  ];

  File? complaintImage;

  // Get category color
  Color getCategoryColor(String? category) {
    if (category == null) return Colors.grey;

    switch (category.toLowerCase()) {
      case 'electrical':
        return Colors.amber;
      case 'plumbing':
        return Colors.blue;
      case 'neighbor':
        return Colors.purple;
      case 'safety':
        return Colors.red;
      case 'maintenance':
        return Colors.teal;
      case 'road':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Get category icon
  IconData getCategoryIcon(String? category) {
    if (category == null) return Icons.category;

    switch (category.toLowerCase()) {
      case 'electrical':
        return Icons.electrical_services;
      case 'plumbing':
        return Icons.water_damage;
      case 'neighbor':
        return Icons.people;
      case 'safety':
        return Icons.health_and_safety;
      case 'maintenance':
        return Icons.build;
      case 'road':
        return Icons.directions_car;
      default:
        return Icons.report_problem;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        complaintImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade900,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade900,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        date.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId');
        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User ID not found')),
          );
          return;
        }
         String formattedDate;
      if (date.text.isEmpty) {
        // If date is empty, use current date
        formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(DateTime.now().toUtc());
      } else {
        try {
          formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
              .format(DateTime.parse(date.text).toUtc());
        } catch (e) {
          // If parsing fails, use current date
          formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(DateTime.now().toUtc());
        }
      }
        Map<String, dynamic> complaintData = {
          'Date': formattedDate,
          'Complaint': complaint.text,
          'category': selectedCategory,
          'Description': description.text,
          'userId': userId,
        };
        await ApiService.addComplaint(complaintData);

        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(width: 10),
                  Text("Success"),
                ],
              ),
              content: Text(
                  "Your complaint has been submitted successfully. You can track its status in the complaints section."),
              actions: [
                TextButton(
                  child: Text("OK", style: TextStyle(color: Colors.blue.shade900)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
        _clearForm();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint: $e')),
        );
      }
    }
  }

  void _clearForm() {
    setState(() {
      date.clear();
      complaint.clear();
      description.clear();
      selectedCategory = null;
      complaintImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IDIFY",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade900, Colors.blue.shade50],
                  stops: const [0.0, 0.3],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header section
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "File a New Complaint",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Please provide detailed information about your issue",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                
                // Form section
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category selection
                        Text(
                          "Complaint Category",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16, 
                            color: Colors.grey.shade700
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              prefixIcon: Icon(
                                selectedCategory != null 
                                    ? getCategoryIcon(selectedCategory) 
                                    : Icons.category,
                                color: selectedCategory != null 
                                    ? getCategoryColor(selectedCategory) 
                                    : Colors.grey,
                              ),
                            ),
                            value: selectedCategory,
                            hint: Text("Select complaint category"),
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            items: categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Row(
                                  children: [
                                    Icon(
                                      getCategoryIcon(category),
                                      color: getCategoryColor(category),
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(category),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                            validator: (value) => value == null ? "Please select a category" : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        // Title field
                        Text(
                          "Complaint Title",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16, 
                            color: Colors.grey.shade700
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: complaint,
                          decoration: InputDecoration(
                            hintText: "Brief title for your complaint",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Icon(Icons.title, color: Colors.blue.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? "Please enter a complaint title" : null,
                        ),
                        SizedBox(height: 20),
                        
                        // Description Field
                        Text(
                          "Complaint Description",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16, 
                            color: Colors.grey.shade700
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: description,
                          decoration: InputDecoration(
                            hintText: "Provide detailed information about your complaint",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 80),
                              child: Icon(Icons.description, color: Colors.blue.shade700),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                            ),
                          ),
                          maxLines: 5,
                          validator: (value) => value!.isEmpty ? "Please enter a description" : null,
                        ),
                        SizedBox(height: 20),
                        
                        // Date Field
                        Text(
                          "Date of Request",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16, 
                            color: Colors.grey.shade700
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: date,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Select date",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                            suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                          validator: (value) => value!.isEmpty ? "Please select a date" : null,
                        ),
                        SizedBox(height: 20),
                        
                        // Image Upload
                        Text(
                          "Supporting Evidence",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16, 
                            color: Colors.grey.shade700
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: complaintImage != null ? Colors.green : Colors.grey.shade300,
                              width: complaintImage != null ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              if (complaintImage != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    complaintImage!,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 16),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _pickImage,
                                    icon: Icon(Icons.image),
                                    label: Text(complaintImage == null ? "Upload Image" : "Change Image"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  if (complaintImage != null) ...[
                                    SizedBox(width: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          complaintImage = null;
                                        });
                                      },
                                      icon: Icon(Icons.delete_outline),
                                      label: Text("Remove"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade100,
                                        foregroundColor: Colors.red,
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (complaintImage == null) ...[
                                SizedBox(height: 10),
                                Text(
                                  "Add a photo to help us better understand your complaint",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              "SUBMIT COMPLAINT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                // Help text
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber.shade800,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Your complaint will be reviewed by our team and you'll receive updates on its status.",
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}