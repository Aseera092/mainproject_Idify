import 'package:flutter/material.dart';
import 'package:idfy_user_application/homepage.dart';
import 'package:idfy_user_application/login.dart';
import 'package:idfy_user_application/memberProfileView.dart';

void main() {
  runApp(const Welcome());
}

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IDify Verification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            elevation: 3,
          ),
        ),
      ),
      home: const DisqusVerificationScreen(),
    );
  }
}

class DisqusVerificationScreen extends StatelessWidget {
  const DisqusVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      body: Container(
        // Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/bg4.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: isSmallScreen ? screenSize.width * 0.95 : 450,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header with improved styling
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'IDify',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 1.2,
                          ),
                        ),
                         Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.home, color: Colors.grey[600], size: isSmallScreen ? 18 : 20),
                            onPressed: () {
                              // Navigate to home page
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()), // Replace HomePage with your actual home page widget
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          // IconButton(
                          //   icon: Icon(Icons.account_circle, color: Colors.grey[600], size: isSmallScreen ? 20 : 22),
                          //   onPressed: () {
                          //     // Navigate to profile page
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(builder: (context) => ViewProfile()), // Replace ProfilePage with your actual profile page widget
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1),
                  
                  // Welcome message with improved styling
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: isSmallScreen ? 18 : 20, color: Colors.black87, height: 1.3),
                        children: [
                          const TextSpan(text: 'Welcome, '),
                          TextSpan(
                            text: 'Successfully registered',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: '!'),
                        ],
                      ),
                    ),
                  ),
                  
                  // Verify button with blue theme and better styling
                 
                  
                  // Welcome section with better spacing and styling
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to IDify!',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Waiting for admin to verify your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 15,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Divider(height: 1, color: Colors.grey[300]),
                  
                  // Email information with improved styling
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        
                        const SizedBox(height: 12),
                        Text(
                          'nedumbasserylb@gmail.com',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}