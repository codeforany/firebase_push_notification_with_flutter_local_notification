import 'package:flutter/material.dart';
import 'package:push_notification_demo/common/push_notification_helper.dart';
import 'package:push_notification_demo/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationHelper.initialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
