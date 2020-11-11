import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yellow_class_project/pages/auth_page.dart';
import 'package:yellow_class_project/pages/home_page.dart';
import 'package:yellow_class_project/pages/phone_auth_page.dart';
import 'package:yellow_class_project/pages/splash_page.dart';
import 'package:yellow_class_project/pages/video_player_page.dart';
import 'package:yellow_class_project/utils/page_transition.dart';
import 'package:yellow_class_project/utils/theme.dart';

import 'init_bindings.dart';
import 'models/user.dart';

///Hive command:
///flutter packages pub run build_runner build --delete-conflicting-outputs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); //Initializing Hive
  Hive.registerAdapter(ApiUserAdapter());
  await Hive.openBox<ApiUser>('userBox');

  runApp(YellowClassApp());
}

class YellowClassApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Get.snackbar("Error", snapshot.error.toString());
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              enableLog: true,
              debugShowCheckedModeBanner: false,
              title: 'Yellow Class',
              initialBinding: InitBindings(),
              initialRoute: SplashPage.routeName,
              theme: AppTheme().darkTheme,
              getPages: [
                GetPage(
                  name: SplashPage.routeName,
                  page: () => SplashPage(),
                  customTransition: CustomSharedAxisTransition(),
                  opaque: true,
                ),
                GetPage(
                  name: AuthPage.routeName,
                  page: () => AuthPage(),
                  customTransition: CustomSharedAxisTransition(),
                  opaque: true,
                ),
                GetPage(
                  name: HomePage.routeName,
                  page: () => HomePage(),
                  customTransition: CustomSharedAxisTransition(),
                  opaque: true,
                ),
                GetPage(
                  name: PhoneAuthPage.routeName,
                  page: () => PhoneAuthPage(),
                  customTransition: CustomSharedAxisTransition(),
                  opaque: true,
                ),
                GetPage(
                  name: VideoPlayerPage.routeName,
                  page: () => VideoPlayerPage(),
                  customTransition: CustomSharedAxisTransition(),
                  opaque: true,
                ),
              ],
            );
          }
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }
}
