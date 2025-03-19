import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:idfy_user_application/homepage.dart';
import 'package:idfy_user_application/memberHome.dart';
import 'package:idfy_user_application/register.dart';
import 'package:idfy_user_application/welcomepage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'service/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      try {
        final response = await ApiService.login({
          "email": email,
          "password": password,
        });

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print(data);
          String role = data['role'];
          SharedPreferences prefs = await SharedPreferences.getInstance();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Successful")),
          );
          if (role == 'user') {
            String userId = data['userDetails']['_id'];
            await prefs.setString('role', role);
            await prefs.setString('userId', userId);
            String homeId = data['userDetails']['homedetails']['homeId'];
            await prefs.setString('homeId', homeId);
            String status = data['userDetails']['status'];
            print(status);
            if (status == 'Pending' || status == 'Reject') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserHomePage()),
              );
            }
          } else if (role == 'member') {
            String userId = data['memberDetails']['_id'];
            await prefs.setString('role', role);
            await prefs.setString('userId', userId);
            String wardNo = data['memberDetails']['ward'];
            await prefs.setString('wardNo', wardNo);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MemberHomePage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid email or password")),
            );
          }
          // else if (role == 'admin') {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text("Admin login not allowed here")),
          //   );
          // }
          // else if (role == 'panchayath') {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text("Panchayath login not allowed here")),
          //   );
          // }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email or password")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.blue,
              ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/image/logo.png", height: 120),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your email";
                    }
                    final emailRegExp = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}");
                    if (!emailRegExp.hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: const Text("User Registration"),
                    ),
                    const SizedBox(height: 4),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
