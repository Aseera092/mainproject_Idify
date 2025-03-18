import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'service/api_service.dart';


class ComplaintsPage extends StatefulWidget {
  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  Future<List<Map<String, dynamic>>> _complaintsFuture = Future.value([]); // Initialize to avoid LateInitializationError

  @override
  void initState() {
    super.initState();
    init();
     // Example ward number
  }

void init()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString('wardNo') ?? '');
  _complaintsFuture = ApiService.getComplaintsAndUserDetails(prefs.getString('wardNo') ?? '').then((res) { // Ward number to be stored in shared preferences and updated here from shared preferences
      debugPrint('Response: $res'); // Use debugPrint for logging in production
      return Future.value(res);
    }).catchError((error) {
      debugPrint('Error fetching complaints: $error');
      return Future.value([]);
    });
    setState(() {
      
    });
}

  Future<void> updateComplaintStatus(String id, String status) async {
    ApiService.updateComplaintStatus(id, {
      "status":status
    }).then((res)=>{
      print(res),
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint $status')),
    ),
    init()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Complaints', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[900],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No complaints found."));
          }

          var complaints = snapshot.data!;

          return ListView.builder(
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
                        complaint['Complaint'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Status: ${complaint['status']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      if(complaint["status"]?.toLowerCase() == 'pending')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => updateComplaintStatus(complaint['_id'], 'Approved'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: Text('Approve'),
                          ),
                          ElevatedButton(
                            onPressed: () => updateComplaintStatus(complaint['_id'], 'Rejected'),
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'service/api_service.dart';

// class ComplaintsPage extends StatefulWidget {
//   @override
//   _ComplaintsPageState createState() => _ComplaintsPageState();
// }

// class _ComplaintsPageState extends State<ComplaintsPage> {
//   late Future<List<Map<String, dynamic>>> _complaintsFuture;
//   String _wardNo = '3';

//   @override
//   void initState() {
//     super.initState();
//     _loadWardNo();
//   }

//   Future<void> _loadWardNo() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _wardNo = prefs.getString('wardNo') ?? '3';
//       init();
//     });
//   }

//   void init() {
//     _complaintsFuture = ApiService.getmemberComplaints(_wardNo).then((res) { // Corrected: Use _wardNo
//       return Future.value(res);
//     });
//   }

//   Future<void> updateComplaintStatus(String id, String status) async {
//     ApiService.updateComplaintStatus(id, {"status": status}).then((res) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Complaint $status')),
//       );
//       init();
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manage Complaints', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.indigo[900],
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () => _showWardDialog(context),
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _complaintsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No complaints found."));
//           }

//           var complaints = snapshot.data!;

//           return ListView.builder(
//             itemCount: complaints.length,
//             itemBuilder: (context, index) {
//               var complaint = complaints[index];
//               return Card(
//                 margin: EdgeInsets.all(10),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                       complaint['Complaint'],
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                       'Status: ${complaint['status']}',
//                       style: TextStyle(color: Colors.grey),
//                       ),
//                       SizedBox(height: 10),
//                       if (complaint['status'] == 'Pending') ...[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                         ElevatedButton(
//                           onPressed: () => updateComplaintStatus(complaint['_id'], 'Approved'),
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                           child: Text('Approve'),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => updateComplaintStatus(complaint['_id'], 'Rejected'),
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                           child: Text('Reject'),
//                         ),
//                         ],
//                       ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _showWardDialog(BuildContext context) {
//     TextEditingController _wardController = TextEditingController(text: _wardNo);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter Ward Number'),
//           content: TextField(
//             controller: _wardController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(hintText: "Ward Number"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: Text('Save'),
//               onPressed: () async {
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.setString('wardNo', _wardController.text);
//                 _loadWardNo();
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: ComplaintsPage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }