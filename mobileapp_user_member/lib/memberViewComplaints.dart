import 'package:flutter/material.dart';

class ComplaintsPage extends StatefulWidget {
  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  List<Map<String, dynamic>> complaints = [
    {'id': 1, 'text': 'Water leakage issue', 'status': 'Pending'},
    {'id': 2, 'text': 'Street light not working', 'status': 'Pending'},
    {'id': 3, 'text': 'Road damage complaint', 'status': 'Pending'},
  ];

  void updateComplaintStatus(int id, String status) {
    setState(() {
      complaints = complaints.map((complaint) {
        if (complaint['id'] == id) {
          return {'id': id, 'text': complaint['text'], 'status': status};
        }
        return complaint;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint $id marked as $status')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Complaints', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[900],
      ),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          var complaint = complaints[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complaint['text'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Status: ${complaint['status']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => updateComplaintStatus(complaint['id'], 'Approved'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text('Approve'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateComplaintStatus(complaint['id'], 'Rejected'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ComplaintsPage(),
    debugShowCheckedModeBanner: false,
  ));
}
