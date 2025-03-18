import 'package:flutter/material.dart';
import 'package:idfy_user_application/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberProfilePage extends StatefulWidget {
  final String memberId;

  const MemberProfilePage({Key? key, required this.memberId}) : super(key: key);
  

  @override
  _MemberProfilePageState createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage> {
  Map<String, dynamic>? memberData;
  bool isLoading = true;
  String errorMessage = '';
  

@override
void initState() {
  super.initState();
  print("Fetching data for member ID: ${widget.memberId}");
  
  fetchMemberData();
}

  Future<void> fetchMemberData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      
      final Map<String, dynamic> response = await ApiService.getMemberById(widget.memberId);
      debugPrint("Member data: ${response.toString()}");
      
      if (!mounted) return;
      setState(() {
        memberData = response;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (memberData == null)
              ? Center(child: Text(errorMessage.isNotEmpty ? errorMessage : "Failed to load profile."))
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
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              memberData?['name'] ?? "User Name",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              memberData?['district'] ?? "District",
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
                              memberData?['email'] ?? "user@example.com",
                              Icons.email,
                            ),
                            _buildInfoCard(
                              context,
                              "Phone",
                              memberData?['mobileNo']?.toString() ?? "+1 (123) 456-7890",
                              Icons.phone,
                            ),
                            _buildInfoCard(
                              context,
                              "Ward",
                              memberData?['ward'] ?? "Ward",
                              Icons.location_on,
                            ),
                            _buildInfoCard(
                              context,
                              "Country",
                              memberData?['country'] ?? "Country",
                              Icons.flag,
                            ),
                            _buildInfoCard(
                              context,
                              "Status",
                              memberData?['status'] ?? "online",
                              Icons.online_prediction,
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

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title option tapped")),
          );
        },
      ),
    );
  }
}