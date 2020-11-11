import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yellow_class_project/controllers/user_controller.dart';

import 'home_page.dart';
import 'auth_page.dart';

class SplashPage extends StatefulWidget {
  static String routeName = "/splash_page";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  UserController userController = UserController.to;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? AuthPage()
        : HomePage();
  }
}
