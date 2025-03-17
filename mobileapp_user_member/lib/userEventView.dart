// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// // Model class for Event


// class ViewEventPage extends StatefulWidget {
//   const ViewEventPage({Key? key}) : super(key: key);

//   @override
//   _ViewEventPageState createState() => _ViewEventPageState();
// }

// class _ViewEventPageState extends State<ViewEventPage> {
//   final EventService _eventService = EventService();
//   List<Event> _events = [];
//   bool _isLoading = true;
//   Event? _selectedEvent;
  
//   // Form controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _timeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _wardNoController = TextEditingController();
//   DateTime? _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _fetchEvents();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _timeController.dispose();
//     _descriptionController.dispose();
//     _locationController.dispose();
//     _wardNoController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchEvents() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final events = await _eventService.getEvents();
//       setState(() {
//         _events = events;
//       });
//     } catch (e) {
//       _showToast('Failed to fetch events: $e', isError: true);
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _handleEdit(Event event) {
//     setState(() {
//       _selectedEvent = event;
//       _nameController.text = event.nameOfEvent;
//       _selectedDate = event.date;
//       _timeController.text = event.time;
//       _descriptionController.text = event.description;
//       _locationController.text = event.location;
//       _wardNoController.text = event.wardNoSelection;
//     });
    
//     _showEditDialog();
//   }

//   Future<void> _handleUpdate() async {
//     if (_selectedEvent == null) return;

//     try {
//       final updatedEvent = Event(
//         id: _selectedEvent!.id,
//         nameOfEvent: _nameController.text,
//         date: _selectedDate,
//         time: _timeController.text,
//         description: _descriptionController.text,
//         location: _locationController.text,
//         wardNoSelection: _wardNoController.text,
//       );

//       final response = await _eventService.updateEvent(_selectedEvent!.id, updatedEvent);
      
//       _showToast(response['message'] ?? 'Event updated successfully!');
//       await _fetchEvents();
//       Navigator.of(context).pop(); // Close the dialog
//     } catch (e) {
//       _showToast('Failed to update event: $e', isError: true);
//     }
//   }

//   Future<void> _handleDelete(String eventId) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Delete'),
//         content: const Text('Are you sure you want to delete this event?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         final response = await _eventService.deleteEvent(eventId);
//         _showToast(response['message'] ?? 'Event deleted successfully!');
//         await _fetchEvents();
//       } catch (e) {
//         _showToast('Failed to delete event: $e', isError: true);
//       }
//     }
//   }

//   void _showEditDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Event'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Event Name'),
//               ),
//               const SizedBox(height: 12),
//               InkWell(
//                 onTap: () async {
//                   final DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: _selectedDate ?? DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null) {
//                     setState(() {
//                       _selectedDate = picked;
//                     });
//                   }
//                 },
//                 child: InputDecorator(
//                   decoration: const InputDecoration(labelText: 'Date'),
//                   child: Text(
//                     _selectedDate != null
//                         ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
//                         : 'Select Date',
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _timeController,
//                 decoration: const InputDecoration(labelText: 'Time'),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _locationController,
//                 decoration: const InputDecoration(labelText: 'Location'),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _wardNoController,
//                 decoration: const InputDecoration(labelText: 'Ward No'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: _handleUpdate,
//             child: const Text('Update Event'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showToast(String message, {bool isError = false}) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: isError ? Colors.red : Colors.green,
//       textColor: Colors.white,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('View Events'),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _events.isEmpty
//                 ? const Center(child: Text('No events available.'))
//                 : GridView.builder(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       childAspectRatio: 0.8,
//                     ),
//                     itemCount: _events.length,
//                     itemBuilder: (context, index) {
//                       final event = _events[index];
//                       return Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 event.nameOfEvent,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Date: ${event.date != null ? DateFormat('yyyy-MM-dd').format(event.date!) : "N/A"}',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                               Text(
//                                 'Time: ${event.time}',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                               Text(
//                                 'Description: ${event.description}',
//                                 style: const TextStyle(fontSize: 14),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 'Location: ${event.location}',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                               Text(
//                                 'Ward No: ${event.wardNoSelection}',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                               const Spacer(),
//                               ElevatedButton(
//                                 onPressed: () => _handleEdit(event),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.amber,
//                                   minimumSize: const Size.fromHeight(36),
//                                 ),
//                                 child: const Text('Edit Event'),
//                               ),
//                               const SizedBox(height: 8),
//                               ElevatedButton(
//                                 onPressed: () => _handleDelete(event.id),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                   minimumSize: const Size.fromHeight(36),
//                                 ),
//                                 child: const Text('Delete Event'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//       ),
//     );
//   }
// }