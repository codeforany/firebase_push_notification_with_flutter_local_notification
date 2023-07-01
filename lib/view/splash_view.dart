
import 'package:flutter/material.dart';
import 'package:push_notification_demo/view/home_view.dart';
import 'package:push_notification_demo/view/login_view.dart';

import '../common/globs.dart';
import '../common/push_notification_helper.dart';
import '../main.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    super.initState();
    loadNextAppScreen();
  }

  loadNextAppScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    loadScreen();
    await PushNotificationHelper.initialized();
  }

  void loadScreen(){
    if (Globs.udValueBool(Globs.userLogin)) {
      userPayload = Globs.udValue(Globs.userPayload);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
          (route) => false);
    }else{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false);
    }
    
    
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Icon(Icons.apps, size: 100,),
      ),
    );
  }
}