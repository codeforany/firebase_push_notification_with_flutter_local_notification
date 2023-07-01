import 'package:flutter/material.dart';
import 'package:push_notification_demo/common/globs.dart';
import 'package:push_notification_demo/common/push_notification_helper.dart';
import 'package:push_notification_demo/view/home_view.dart';
import 'package:push_notification_demo/view/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
SharedPreferences? prefs;
Map userPayload = {};
bool pushRedirect = false;
Map pushPayload = {};


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  if(Globs.udValueBool(Globs.userLogin)) {
    userPayload = Globs.udValue(Globs.userPayload);
  }
  
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
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
