import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overall Performance', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildAnalyticsCard(
              title: 'Total Complaints',
              value: '50',
              icon: Icons.report_problem,
              color: Colors.blue,
            ),
            _buildAnalyticsCard(
              title: 'Resolved Complaints',
              value: '45',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            _buildAnalyticsCard(
              title: 'Pending Complaints',
              value: '5',
              icon: Icons.pending_actions,
              color: Colors.orange,
            ),
            // SizedBox(height: 24),
            // Text(
            //   'Complaint Trends',
            //   style: GoogleFonts.poppins(
            //   fontSize: isTablet ? 24 : 20,
            //   fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(height: isTablet ? 20 : 16),
            _buildChartPlaceholder(), // Replace with actual chart widget
            SizedBox(height: 24),
            Text('Category Breakdown', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildCategoryBreakdown(isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text('Chart Placeholder', style: GoogleFonts.poppins(color: Colors.grey)),
      ),
    );
  }

  Widget _buildCategoryBreakdown(bool isTablet) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 3 : 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildCategoryItem(category: 'Roads', count: '15', color: Colors.red),
        _buildCategoryItem(category: 'Water', count: '10', color: Colors.blue),
        _buildCategoryItem(category: 'Electricity', count: '10', color: Colors.yellow[700]!),
        _buildCategoryItem(category: 'Waste', count: '10', color: Colors.green),
        _buildCategoryItem(category: 'Other', count: '5', color: Colors.purple),
      ],
    );
  }

  Widget _buildCategoryItem({required String category, required String count, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          Text(count, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}