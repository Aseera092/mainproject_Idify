import 'package:flutter/material.dart';

class ViewProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(
              //   "Profile",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     shadows: [
              //       Shadow(
              //         blurRadius: 10.0,
              //         color: Colors.black.withOpacity(0.3),
              //         offset: Offset(0, 2),
              //       ),
              //     ],
              //   ),
              // ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color.fromARGB(255, 197, 199, 208), const Color.fromARGB(255, 226, 227, 231)],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'profileImage',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('./assets/image/bg2.jpeg'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // User Name with decorative line
                  Text(
                    "John Doe",
                    style: TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Decorative divider
                  Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Email with icon
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.grey),
                      SizedBox(width: 6),
                      Text(
                        "johndoe@example.com",
                        style: TextStyle(
                          fontSize: 16, 
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  
                  // Profile Details with enhanced cards
                  Text(
                    "CONTACT INFO",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Phone Number Card
                  _buildInfoCard(
                    context: context,
                    icon: Icons.phone,
                    title: "Phone",
                    subtitle: "+91 9876543210",
                    color: Colors.green,
                  ),
                  SizedBox(height: 12),
                  
                  // Location Card
                  _buildInfoCard(
                    context: context,
                    icon: Icons.location_on,
                    title: "Location",
                    subtitle: "Nedumbassery, Kerala",
                    color: Colors.orange,
                  ),
                  SizedBox(height: 12),
                  
                  // Additional card for more info
                  _buildInfoCard(
                    context: context,
                    icon: Icons.work,
                    title: "Occupation",
                    subtitle: "Software Developer",
                    color: Colors.blue,
                  ),
                  SizedBox(height: 40),
                  
                  // Edit Profile Button with animation
                  InkWell(
                    onTap: () {
                      // Navigate to Edit Profile
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo.shade700, Colors.indigo.shade400],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "EDIT PROFILE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to create consistent info cards
  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}