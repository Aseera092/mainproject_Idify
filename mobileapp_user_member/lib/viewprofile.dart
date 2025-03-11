import 'package:flutter/material.dart';
import 'package:idfy_user_application/service/api_service.dart';

class Viewprofileuser extends StatefulWidget {
  final String userId;

  const Viewprofileuser({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewprofileState createState() => _ViewprofileState();
}

class _ViewprofileState extends State<Viewprofileuser> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await ApiService.getUser(widget.userId);
      setState(() {
        userData = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Add edit profile functionality here
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("Failed to load profile."))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Theme.of(context).primaryColor.withOpacity(0.2),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              userData?['firstName'] ?? "User Name",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              userData?['Address'] ?? "Bio information goes here",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildInfoCard(
                              context,
                              "Email",
                              userData?['email'] ?? "user@example.com",
                              Icons.email,
                            ),
                            _buildInfoCard(
                              context,
                              "Phone",
                              userData?['MobileNo'] ?? "+1 (123) 456-7890",
                              Icons.phone,
                            ),
                            _buildInfoCard(
                              context,
                              "Location",
                              userData?['district'] ?? "New York, USA",
                              Icons.location_on,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Account Settings",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSettingsOption(
                              context,
                              "Privacy",
                              Icons.lock_outline,
                            ),
                            _buildSettingsOption(
                              context,
                              "Notifications",
                              Icons.notifications_none,
                            ),
                            _buildSettingsOption(
                              context,
                              "Help & Support",
                              Icons.help_outline,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        onTap: () {
          // Add settings option functionality here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title option tapped")),
          );
        },
      ),
    );
  }
}