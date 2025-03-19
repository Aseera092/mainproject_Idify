import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:idfy_user_application/login.dart';
import 'package:idfy_user_application/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
// Your home/dashboard page

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define routes
      routes: {
        '/': (context) => const SplashScreen(),
      },
      initialRoute: '/',
      title: 'User Application',
    );
  }
}

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Initialize Firebase for background handlers
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   debugPrint('Received background message: ${message.notification?.title}');
//   if (message.notification != null) {
//     FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
//     await plugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//         iOS: DarwinInitializationSettings(),
//       ),
//     );
//     await plugin.show(
//       123456,
//       message.notification?.title,
//       message.notification?.body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//     );
//   }
// }

void initNotification() async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final messaging = FirebaseMessaging.instance;

    // Subscribe to common topic for all users
    await messaging.subscribeToTopic("global");
    debugPrint("✅ Subscribed to: global");

    // Get user ID and ward ID from shared preferences
    final homeId = pref.getString("homeId");
    final wardId = pref.getString("wardNo");

    if (homeId != null) {
      await messaging.subscribeToTopic(homeId); // User-specific notifications
      debugPrint("✅ Subscribed to: $homeId");
    }
    print(wardId);
    if (wardId != null) {
      await messaging.subscribeToTopic("ward_$wardId"); // Ward-based notifications
      debugPrint("✅ Subscribed to: ward_$wardId");
    }

    // Request permission for notifications
    await messaging.requestPermission();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Received message: ${message.notification}');
      
      if (message.notification != null) {
        FlutterLocalNotificationsPlugin plugin =
            FlutterLocalNotificationsPlugin();
        await plugin.initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings(),
          ),
        );

        await plugin.show(
          123456,
          message.notification?.title,
          message.notification?.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

  } catch (e) {
    print("Error initializing notification: $e");
  }
}

