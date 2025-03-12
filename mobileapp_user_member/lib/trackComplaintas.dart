import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; 

class TrackComplaints extends StatefulWidget {
  @override
  _TrackComplaintsState createState() => _TrackComplaintsState();
}

class _TrackComplaintsState extends State<TrackComplaints> {
  late Future<List<Map<String, dynamic>>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _complaintsFuture = _fetchComplaints();
  }

Future<List<Map<String, dynamic>>> _fetchComplaints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  print(userId);
  
  // Make sure userId exists
  if (userId == null) {
    throw Exception('User ID not found. Please login again.');
   
  }
  
  final url = Uri.parse('http://localhost:8080/complaint/${userId}');

  try {
    final response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['status'] == true) {
        final List<dynamic> data = responseData['data'];
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
        
      }
      throw Exception('Failed to load complaints: ${responseData['message']}');
    } else {
      throw Exception('Failed to load complaints: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to load complaints: $error');
  }
}
  void _deleteComplaint(String complaintId) async {
    // Implement API call to delete complaint by ID
     final url = Uri.parse('http://localhost:8080/complaint/$complaintId');  

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Refresh the complaint list after successful deletion
        setState(() {
          _complaintsFuture = _fetchComplaints();
        });
        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint withdrawn successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to delete complaint: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to delete complaint: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track Complaints',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade100],
            stops: const [0.0, 1.0], // Fixed missing values in stops array
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _complaintsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: Colors.white70,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No complaints found',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You haven\'t filed any complaints yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final complaints = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  final complaint = complaints[index];
                  return Dismissible(
                    key: Key(complaint['id'].toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      // Show dialog to confirm deletion and get reason
                      return await _showDeleteConfirmationDialog(
                          context, complaint['id'].toString());
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Withdraw',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComplaintDetails(
                                complaint: complaint,
                                onDelete: () =>
                                    _showDeleteConfirmationDialog(
                                        context, complaint['id'].toString()),
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(complaint['status'])
                                    .withOpacity(0.2),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ID: ${complaint['id']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(complaint['status']),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      complaint['status'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: getCategoryColor(
                                              complaint['category'])
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      getCategoryIcon(complaint['category']),
                                      size: 30,
                                      color: getCategoryColor(
                                          complaint['category']),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaint['complaint'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Category: ${complaint['category']}',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Filed on: ${complaint['date']}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red.shade300,
                                        ),
                                        onPressed: () =>
                                            _showDeleteConfirmationDialog(
                                                context, complaint['id'].toString()),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to file new complaint page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File New Complaint functionality'),
            ),
          );
        },
        backgroundColor: Colors.blue.shade900,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, String complaintId) async {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Withdraw Complaint'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Are you sure you want to withdraw this complaint?',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please provide a reason for withdrawal:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your reason here',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide a reason for withdrawal';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Withdraw the complaint with the provided reason
                  _deleteComplaint(complaintId);
                  Navigator.of(context).pop(true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('WITHDRAW'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getCategoryColor(String? category) {
    if (category == null) return Colors.grey;

    switch (category.toLowerCase()) {
      case 'electrical':
        return Colors.amber;
      case 'plumbing':
        return Colors.blue;
      case 'neighbor':
        return Colors.purple;
      case 'safety':
        return Colors.red;
      case 'maintenance':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData getCategoryIcon(String? category) {
    if (category == null) return Icons.report_problem;

    switch (category.toLowerCase()) {
      case 'electrical':
        return Icons.electrical_services;
      case 'plumbing':
        return Icons.water_damage;
      case 'neighbor':
        return Icons.people;
      case 'safety':
        return Icons.health_and_safety;
      case 'maintenance':
        return Icons.build;
      default:
        return Icons.report_problem;
    }
  }
}

class ComplaintDetails extends StatelessWidget {
  final Map<String, dynamic> complaint;
  final VoidCallback onDelete;

  const ComplaintDetails({required this.complaint, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complaint Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
            tooltip: 'Withdraw Complaint',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: getStatusColor(complaint['status']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      complaint['status'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Complaint ID: ${complaint['id']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            // Complaint Details Card
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Category
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: getCategoryColor(complaint['category']).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            getCategoryIcon(complaint['category']),
                            color: getCategoryColor(complaint['category']),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                complaint['complaint'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Category: ${complaint['category'] ?? 'General'}',
                                style: TextStyle(
                                  color: getCategoryColor(complaint['category']),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 32),
                    
                    // Date Filed
                    const Text(
                      'Date Filed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.blue.shade900,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          complaint['date'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      complaint['description'] ?? 'No description provided.',
                      style: const TextStyle(fontSize: 16),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Image if available
                    if (complaint['image'] != null) ...[
                      const Text(
                        'Attachment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          complaint['image'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Timeline Card
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Timeline',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Timeline(
                      status: complaint['status'],
                      date: complaint['date'],
                    ),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Withdraw Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Withdraw Complaint',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Feedback Button for resolved complaints
                    if (complaint['status'] == 'Resolved')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Show feedback dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Rate Resolution'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('How satisfied are you with the resolution?'),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: List.generate(
                                          5,
                                          (index) => IconButton(
                                            icon: Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 36,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Thank you for your feedback!'),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Rate Resolution',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 12),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getCategoryColor(String? category) {
    if (category == null) return Colors.grey;
    
    switch (category.toLowerCase()) {
      case 'electrical':
        return Colors.amber;
      case 'plumbing':
        return Colors.blue;
      case 'neighbor':
        return Colors.purple;
      case 'safety':
        return Colors.red;
      case 'maintenance':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData getCategoryIcon(String? category) {
    if (category == null) return Icons.report_problem;
    
    switch (category.toLowerCase()) {
      case 'electrical':
        return Icons.electrical_services;
      case 'plumbing':
        return Icons.water_damage;
      case 'neighbor':
        return Icons.people;
      case 'safety':
        return Icons.health_and_safety;
      case 'maintenance':
        return Icons.build;
      default:
        return Icons.report_problem;
    }
  }
}

// Timeline Widget
class Timeline extends StatelessWidget {
  final String status;
  final String date;

  const Timeline({required this.status, required this.date});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> steps = [
      {'title': 'Filed', 'isCompleted': true, 'date': date},
      {'title': 'Under Review', 'isCompleted': isStepCompleted('Under Review')},
      {'title': 'In Progress', 'isCompleted': isStepCompleted('In Progress')},
      {'title': 'Resolved', 'isCompleted': isStepCompleted('Resolved')},
    ];

    return Column(
      children: List.generate(
        steps.length,
        (index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;
          
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: step['isCompleted'] ? Colors.green : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: step['isCompleted']
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: step['isCompleted'] ? Colors.green : Colors.grey.shade300,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: step['isCompleted'] ? Colors.black : Colors.grey,
                      ),
                    ),
                    if (step['date'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        step['date'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    SizedBox(height: isLast ? 0 : 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool isStepCompleted(String stepName) {
    final statusLowerCase = status.toLowerCase();
    
    if (statusLowerCase == 'resolved' && stepName == 'Resolved') return true;
    if (statusLowerCase == 'in progress' && (stepName == 'In Progress' || stepName == 'Under Review')) return true;
    if (statusLowerCase == 'under review' && stepName == 'Under Review') return true;
    
    return false;
  }
}