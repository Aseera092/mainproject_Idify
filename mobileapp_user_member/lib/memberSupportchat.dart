import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({Key? key}) : super(key: key);

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add initial welcome message from support
    _addMessage(
      "Hello! Welcome to IDFY Support. How can I help you today?",
      MessageType.received,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(String message, MessageType type) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        type: type,
        timestamp: DateTime.now(),
      ));
    });
    
    // Scroll to bottom of chat
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Simulate automated response
  void _simulateResponse(String userMessage) {
    // Simulate typing indicator
    setState(() {
      _isTyping = true;
    });

    // Delayed response to simulate real conversation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTyping = false;
      });
      
      // Simple response logic based on keywords
      String response;
      userMessage = userMessage.toLowerCase();
      
      if (userMessage.contains('hello') || 
          userMessage.contains('hi') || 
          userMessage.contains('hey')) {
        response = "Hello! How can I assist you with your issue today?";
      } else if (userMessage.contains('complaint') || userMessage.contains('issue')) {
        response = "I understand you're having an issue. Could you please provide more details about your complaint so I can assist you better?";
      } else if (userMessage.contains('thank')) {
        response = "You're welcome! Is there anything else I can help you with?";
      } else if (userMessage.contains('help')) {
        response = "I'm here to help! Please let me know what specific assistance you need with your account, complaints, or any other matters.";
      } else if (userMessage.contains('contact') || userMessage.contains('phone') || userMessage.contains('email')) {
        response = "You can reach our support team via email at support@idfy.com or call us at +91 9876543210 during business hours.";
      } else if (userMessage.contains('wait') || userMessage.contains('time')) {
        response = "Our current response time is approximately 24 hours for email inquiries. For urgent matters, please call our support line.";
      } else {
        response = "Thank you for your message. Our support team will review your query and get back to you soon. If your matter is urgent, please call our support line at +91 9876543210.";
      }
      
      _addMessage(response, MessageType.received);
    });
  }

  void _handleSubmit() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _addMessage(message, MessageType.sent);
      _messageController.clear();
      _simulateResponse(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Support Chat',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              'Support Team',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Support Information', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Support Hours:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      Text('Mon-Fri: 9:00 AM - 6:00 PM', style: GoogleFonts.poppins()),
                      Text('Sat: 10:00 AM - 2:00 PM', style: GoogleFonts.poppins()),
                      Text('Sun: Closed', style: GoogleFonts.poppins()),
                      const SizedBox(height: 10),
                      Text('Contact Information:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      Text('Phone: +91 9876543210', style: GoogleFonts.poppins()),
                      Text('Email: support@idfy.com', style: GoogleFonts.poppins()),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close', style: GoogleFonts.poppins(color: Colors.indigo)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat history
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          
          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Text(
                    'Support is typing...',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          
          // Input field
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.indigo[700]),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Attachment feature coming soon', 
                        style: GoogleFonts.poppins())),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[100],
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    onSubmitted: (_) => _handleSubmit(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.indigo[700]),
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.type == MessageType.sent;
    final dateFormat = DateFormat('h:mm a');
    final timeString = dateFormat.format(message.timestamp);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              backgroundColor: Colors.indigo[900],
              radius: 16,
              child: const Icon(Icons.support_agent, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.indigo[700] : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: GoogleFonts.poppins(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeString,
                    style: GoogleFonts.poppins(
                      color: isMe ? Colors.white.withOpacity(0.7) : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// Message data model
class ChatMessage {
  final String text;
  final MessageType type;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.type,
    required this.timestamp,
  });
}

enum MessageType {
  sent,
  received,
}