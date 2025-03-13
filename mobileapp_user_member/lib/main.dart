import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:idfy_user_application/login.dart';
import 'package:idfy_user_application/splashScreen.dart';
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
    final messaging = FirebaseMessaging.instance;
    await messaging.subscribeToTopic("IDIFY-News");
    await messaging.requestPermission();
    // final token = await messaging.getToken();
    // debugPrint('Token: $token');
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Received message: ${message.notification?.title}');
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
    print(e);
  }
}
