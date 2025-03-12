import 'package:flutter/material.dart';
import 'package:idfy_user_application/aboutus.dart';
import 'package:idfy_user_application/memberProfileView.dart';
import 'package:idfy_user_application/notification.dart';
import 'package:idfy_user_application/complaint.dart';
import 'package:idfy_user_application/trackComplaintas.dart';
import 'package:idfy_user_application/viewprofile.dart'; // Import Viewprofileuser

import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idfy_user_application/memberSupportchat.dart';

class UserHomePage extends StatefulWidget {
  // Change to StatefulWidget
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  // Create State class
  String? _id;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('userId');
      print(_id);
      if (_id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID not found')),
        );
      }
    });
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'IDify',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo[700],
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                'Welcome back!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[800],
                ),
              ),
            ),
            CarouselSlider(
              items: [
                "carousel1.jpg",
                "carousel2.jpg",
                "carousel3.jpg",
              ].map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/image/$item",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 0.85,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Quick Actions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo[800],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  // _buildFeatureTile(
                  //   icon: Icons.person_outline,
                  //   title: "My Profile",
                  //   subtitle: "View your details",
                  //   color: Colors.blue[700]!,
                  //   onTap: () {
                  //     if (_userId == null) {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) =>
                  //               Viewprofileuser(userId: _userId!),
                  //         ),
                  //       );
                  //     } else {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(content: Text('User ID not found')),
                  //       );
                  //     }
                  //   },
                  // ),
                  _buildFeatureTile(
                    icon: Icons.report_problem_outlined,
                    title: "Register",
                    subtitle: "New complaint",
                    color: Colors.orange[700]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Request()),
                    ),
                  ),
                  _buildFeatureTile(
                    icon: Icons.track_changes,
                    title: "Track",
                    subtitle: "Your complaints",
                    color: Colors.green[700]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackComplaints()),
                    ),
                  ),
                  _buildFeatureTile(
                    icon: Icons.info_outline,
                    title: "About Us",
                    subtitle: "Learn more",
                    color: Colors.purple[700]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()),
                    ),
                  ),
                  _buildFeatureTile(
                    icon: Icons.person_2,
                    title: "Profile",
                    subtitle: "View your profile",
                    color: Colors.purple[700]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Viewprofileuser(userId: _id!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Recent Activities',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo[800],
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildRecentActivityCard(
              title: "Complaint #1283",
              description: "Your complaint is being processed",
              date: "March 8, 2025",
              status: "In Progress",
              statusColor: Colors.amber,
            ),
            _buildRecentActivityCard(
              title: "Notification",
              description: "Your profile has been verified",
              date: "March 5, 2025",
              status: "Completed",
              statusColor: Colors.green,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement map functionality here
        },
        backgroundColor: Colors.indigo[700],
        child: const Icon(Icons.map, color: Colors.white),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard({
    required String title,
    required String description,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo[800]!,
              Colors.indigo[600]!,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, size: 45, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    _buildDrawerItem(
                      context,
                      icon: Icons.home_outlined,
                      title: "Home",
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.person_outline,
                      title: "View Profile",
                      onTap: () {
                        print(" $_id"); // Print userId

                        if (_id != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Viewprofileuser(userId: _id!),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User ID not found')),
                          );
                        }
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationPage())),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.report_problem_outlined,
                      title: "Complaint Registration",
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Request())),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.track_changes,
                      title: "Track Complaints",
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrackComplaints())),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.info_outline,
                      title: "About Us",
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsPage())),
                    ),
                    const Divider(),
                    _buildDrawerItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SupportChatPage()),
                        );
                      },
                    ),
                      _buildDrawerItem(
                      context,
                      icon: Icons.logout,
                      title: "Logout",
                      color: Colors.red[700]!,
                      onTap: () => logout(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.indigo,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
