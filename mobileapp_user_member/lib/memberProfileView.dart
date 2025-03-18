import 'package:flutter/material.dart';
import 'package:idfy_user_application/service/api_service.dart'; // Ensure correct import

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
    _fetchMemberData();
  }

  Future<void> _fetchMemberData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final response = await ApiService.getUser(widget.memberId); // Assuming getUser fetches member data
      setState(() {
        memberData = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load member profile: $e';
      });
      print('Error fetching member data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : memberData == null
                  ? const Center(child: Text('Member data not found.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileHeader(context),
                          const SizedBox(height: 20),
                          _buildProfileDetails(context),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: 70,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            memberData?['firstName'] ?? 'Member Name',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            memberData?['Address'] ?? 'Member Bio',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildInfoCard(context, 'email', memberData?['email'] ?? 'N/A', Icons.email),
        _buildInfoCard(context, 'Phone', memberData?['MobileNo'] ?? 'N/A', Icons.phone),
        _buildInfoCard(context, 'Location', memberData?['district'] ?? 'N/A', Icons.location_on),
        // Add more details as needed
      ],
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
}