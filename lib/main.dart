import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nurseryapplication_/screens/UI/splash_screen.dart';

// Define Android notification channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This is a description',
  enableVibration: true,
  importance: Importance.high,
  playSound: true,
);

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message (optional actions like data processing)
  print("Handling a background message: ${message.messageId}");
  print('Notification Message: ${message.data}');

  // If you need to show a notification in the background,
  // use a platform-specific notification plugin here.
}

Future<void> main() async {
  // Initialize Flutter Local Notifications plugin
  final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Request permission for Firebase Cloud Messaging
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  // Handle messages received while the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Handle when a message is clicked and the app is in the background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print('Message data: ${message.data}');
  });

  // Handle when a message is received while the app is in the background
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    } else {
      print('Message data: ${message.data}');
      // Show local notification
      localNotifications.show(
        message.data.hashCode,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
            styleInformation: const BigTextStyleInformation(''),
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    }
  });

  // Initialize and run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Splash());
  }
}

// Function to initialize local notifications
Future<void> initLocalNotification() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
