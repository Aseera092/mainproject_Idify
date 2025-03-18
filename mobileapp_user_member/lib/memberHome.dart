import 'package:flutter/material.dart';
import 'package:idfy_user_application/contactUs.dart';
import 'package:idfy_user_application/memberProfileView.dart';
import 'package:idfy_user_application/memberSupportchat.dart';
import 'package:idfy_user_application/memberViewComplaints.dart';
import 'package:idfy_user_application/memberSettings.dart';
// import 'package:idfy_user_application/viewprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class MemberHomePage extends StatefulWidget {
  const MemberHomePage({Key? key}) : super(key: key);

  @override
  State<MemberHomePage> createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  String memberName = "Member Name";
  String memberEmail = "member@example.com";
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    // Simulate loading user data
    await Future.delayed(const Duration(milliseconds: 800));
    // Here you would fetch actual user data from SharedPreferences or API
    setState(() {
      isLoading = false;
    });
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text('Logout', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Member Dashboard',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: isTablet ? 22 : 18,
          ),
        ),
        backgroundColor: Colors.indigo[900],
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifications feature coming soon', style: GoogleFonts.poppins())),
                );
              },
            ),
          ),
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
        : SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadUserData,
            color: Colors.indigo,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    _buildWelcomeSection(isTablet),
                    
                    const SizedBox(height: 25),
                    
                    // Features header
                    Text(
                      'Quick Actions',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Features grid
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: isTablet ? 3 : 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: [
                        _buildFeatureTile(Icons.report_outlined, "View\nComplaints", Colors.blue[700]!, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ComplaintsPage()),
                          );
                        }),
                        _buildFeatureTile(Icons.contact_mail_outlined, "Contact\nUs", Colors.green[700]!, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Contactus()),
                          );
                        }),
                        _buildFeatureTile(Icons.person_outline, "View\nProfile", Colors.purple[700]!, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MemberProfilePage(memberId: '_id')),
                          );
                        }),
                        _buildFeatureTile(Icons.analytics_outlined, "Analytics", Colors.orange[700]!, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Analytics feature coming soon', style: GoogleFonts.poppins())),
                          );
                        }),
                      ],
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Recent activities section
                    Text(
                      'Recent Activities',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Recent activities list
                    _buildActivityCard(
                      'New complaint submitted',
                      'Road maintenance required in Ward 3',
                      '2 hours ago',
                      Icons.report_problem_outlined,
                      Colors.red[100]!,
                      Colors.red,
                    ),
                    _buildActivityCard(
                      'Complaint resolved',
                      'Streetlight issue in Ward 5 has been fixed',
                      'Yesterday',
                      Icons.check_circle_outline,
                      Colors.green[100]!,
                      Colors.green,
                    ),
                    
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      drawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[900],
        child: const Icon(Icons.support_agent, color: Colors.white),
        onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportChatPage()),
              );
            },
      ),
    );
  }
  
  Widget _buildWelcomeSection(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[900]!, Colors.indigo[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: isTablet ? 40 : 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: isTablet ? 50 : 35,
                  color: Colors.indigo[900],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      memberName,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('12', 'Open\nComplaints'),
                _buildDivider(),
                _buildStatItem('28', 'Resolved\nComplaints'),
                _buildDivider(),
                _buildStatItem('5', 'Today\'s\nUpdates'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
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
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActivityCard(
    String title, 
    String description, 
    String time, 
    IconData icon, 
    Color bgColor, 
    Color? iconColor
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black45,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo[900]!, Colors.indigo[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 45, color: Colors.indigo),
                ),
                const SizedBox(height: 10),
                Text(
                  memberName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  memberEmail,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context, 
            Icons.dashboard_outlined, 
            'Dashboard', 
            () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context,
            Icons.person_outline,
            'View Profile',
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MemberProfilePage(memberId: '_id')),
              );
            },
          ),
          _buildDrawerItem(
            context,
            Icons.report_outlined,
            'Complaints',
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComplaintsPage()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            Icons.contact_mail_outlined,
            'Contact Us',
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Contactus()),
              );
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            Icons.settings_outlined,
            'Settings',
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            Icons.help_outline,
            'Help & Support',
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportChatPage()),
              );
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            Icons.logout,
            'Logout',
            () {
              Navigator.pop(context);
              logout(context);
            },
            isLogout: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem(
    BuildContext context, 
    IconData icon, 
    String title, 
    VoidCallback onTap, 
    {bool isLogout = false}
  ) {
    return ListTile(
      leading: Icon(
        icon, 
        color: isLogout ? Colors.red : Colors.indigo[700],
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: isLogout ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}