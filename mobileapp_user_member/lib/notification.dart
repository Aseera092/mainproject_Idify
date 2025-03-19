import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service/api_service.dart';

// Make sure to use this class name when navigating from homepage.dart
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo.shade800,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Filter functionality
              _showFilterOptions(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // More options
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: NotificationBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade800,
        child: const Icon(Icons.mark_chat_read, color: Colors.white),
        onPressed: () {
          // Mark all as read
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'All notifications marked as read',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Notifications',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),
            _buildFilterOption(context, 'All', Icons.all_inclusive),
            _buildFilterOption(context, 'Unread', Icons.mark_email_unread),
            _buildFilterOption(context, 'Priority', Icons.priority_high),
            _buildFilterOption(context, 'Recent', Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // Apply filter logic
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo.shade700),
            const SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
      items: [
        PopupMenuItem(
          child: Text('Mark all as read', style: GoogleFonts.poppins()),
          onTap: () {},
        ),
        PopupMenuItem(
          child: Text('Settings', style: GoogleFonts.poppins()),
          onTap: () {},
        ),
        PopupMenuItem(
          child: Text('Help', style: GoogleFonts.poppins()),
          onTap: () {},
        ),
      ],
    );
  }

  // Move this method outside of the class to make it global
  // This will be used by NotificationBody
}

// Method for showing notification details - accessible by both classes
void showNotificationDetails(BuildContext context, int notificationNumber, String title, String message, DateTime time) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade800,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('MMM dd, yyyy • HH:mm').format(time),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // if (notificationNumber % 2 == 0) // Just for example, show image for even numbers
                  //   Container(
                  //     height: 200,
                  //     width: double.infinity,
                  //     margin: const EdgeInsets.only(bottom: 20),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade200,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Icon(
                  //       Icons.image,
                  //       size: 50,
                  //       color: Colors.grey.shade400,
                  //     ),
                  //   ),
                  const Divider(),
                  // const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     buildActionButton(
                  //       context,
                  //       Icons.reply,
                  //       'Reply',
                  //       Colors.blue.shade700,
                  //     ),
                  //     buildActionButton(
                  //       context, 
                  //       Icons.delete,
                  //       'Delete',
                  //       Colors.red.shade700,
                  //     ),
                  //     buildActionButton(
                  //       context,
                  //       Icons.archive,
                  //       'Archive',
                  //       Colors.amber.shade700,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildActionButton(BuildContext context, IconData icon, String label, Color color) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
      // Handle action
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          radius: 25,
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class NotificationBody extends StatefulWidget {
  @override
  _NotificationBodyState createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
    getNotification();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void getNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await ApiService.getNotificationbyHome(pref.getString("homeId") ?? '');
    
    // List of possible icons and colors to randomly choose from
    final icons = [
      Icons.star, Icons.notification_important, Icons.info, 
      Icons.warning, Icons.event, Icons.message, Icons.update
    ];
    final colors = [
      Colors.amber, Colors.blue, Colors.red, Colors.green, 
      Colors.purple, Colors.orange, Colors.teal
    ];

      _notifications = response.map<NotificationItem>((item) {
        // Random selection of priority, icon, and color
        final random = DateTime.now().millisecondsSinceEpoch;
        final priority = NotificationPriority.values[random % 3];
        final icon = icons[random % icons.length];
        final color = colors[random % colors.length];

        return NotificationItem(
          id: random,
          title: item['title'] ?? 'Notification',
          message: item['body'] ?? 'No message content',
          time: DateTime.parse(item['createdAt'] ?? DateTime.now().toIso8601String()),
          isRead: false,
          priority: priority,
          icon: icon,
          color: color,
        );
      }).toList();
      setState(() {
        _notifications = _notifications;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.indigo.shade50,
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Swipe notifications to dismiss or tap for details",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.indigo.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: Colors.indigo.shade800,
            onRefresh: () async {
              // Simulate refresh
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, int index) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index / _notifications.length,
          (index + 1) / _notifications.length,
          curve: Curves.easeOut,
        ),
      ),
    );

    String timeAgo = _getTimeAgo(notification.time);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: Dismissible(
          key: Key(notification.id.toString()),
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.delete, color: Colors.red.shade700),
          ),
          secondaryBackground: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.archive, color: Colors.indigo.shade700),
          ),
          onDismissed: (direction) {
            // Handle dismiss
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: notification.isRead ? Colors.white : Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Use the global function now instead of the class method
                  showNotificationDetails(
                    context,
                    notification.id,
                    notification.title,
                    notification.message,
                    notification.time,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNotificationIcon(notification),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: GoogleFonts.poppins(
                                      fontWeight: notification.isRead
                                          ? FontWeight.w500
                                          : FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (!notification.isRead)
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade700,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  timeAgo,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                _getPriorityBadge(notification.priority),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationItem notification) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: notification.color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        notification.icon,
        color: notification.color,
        size: 24,
      ),
    );
  }

  Widget _getPriorityBadge(NotificationPriority priority) {
    Color color;
    String text;

    switch (priority) {
      case NotificationPriority.high:
        color = Colors.red.shade700;
        text = "High";
        break;
      case NotificationPriority.medium:
        color = Colors.amber.shade700;
        text = "Medium";
        break;
      case NotificationPriority.low:
        color = Colors.green.shade700;
        text = "Low";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No Notifications",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You're all caught up!",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: Text(
              "Refresh",
              style: GoogleFonts.poppins(),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Refresh logic
            },
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return DateFormat('MMM d').format(time);
    }
  }
}

enum NotificationPriority { high, medium, low }

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final NotificationPriority priority;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.priority,
    required this.icon,
    required this.color,
  });
}