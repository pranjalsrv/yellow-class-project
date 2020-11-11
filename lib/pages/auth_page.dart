import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yellow_class_project/controllers/auth_controller.dart';
import 'package:yellow_class_project/controllers/user_controller.dart';
import 'package:yellow_class_project/models/user.dart';
import 'package:yellow_class_project/pages/home_page.dart';
import 'package:yellow_class_project/pages/phone_auth_page.dart';

class AuthPage extends StatefulWidget {
  static String routeName = "/auth_page";

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Yellow Class',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 40),
            Container(
              // margin: EdgeInsets.all(24),
              // alignment: Alignment.centerLeft,
              child: Text(
                "Let's get you started!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: OutlineButton(
                onPressed: () {
                  Navigator.pushNamed(context, PhoneAuthPage.routeName);
                },
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                borderSide: BorderSide(color: Color(0xff3B916E)),
                highlightedBorderColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone),
                    SizedBox(
                      width: 18,
                    ),
                    Text(
                      "Continue with Phone Number",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: OutlineButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, PhoneAuthPage.routeName);
            //     },
            //     padding: EdgeInsets.symmetric(vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     borderSide: BorderSide(color: Color(0xff3B916E)),
            //     highlightedBorderColor: Colors.transparent,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.mail),
            //         SizedBox(
            //           width: 18,
            //         ),
            //         Text(
            //           "Continue with Email",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 16,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: OutlineButton(
                onPressed: () async {
                  FirebaseAuthController firebaseAuthController = FirebaseAuthController.to;
                  UserController userController = UserController.to;
                  UserCredential userCred = await firebaseAuthController.autoSignInGoogle();
                  ApiUser user;
                  if (userCred.additionalUserInfo.isNewUser) {
                    print("[] New user google sign in");
                    //New user
                    user = userController.createNewUser(newUser: userCred.user);
                    Get.offAndToNamed(HomePage.routeName);
                    // user = await createUserInBackend(user: newUser);
                  } else {
                    //Old user, get from hive, if not present get from backend
                    print("[] Fetch user with Firebase UID");
                    user = await userController.getUserFromFirebase(firebaseUid: userCred.user.uid);
                    UserController.to.user = user;
                    Get.offAndToNamed(HomePage.routeName);
                  }

                  Get.snackbar("Account logged in", "${user.email}",
                      snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
                  print("[] Google sign in complete");
                },
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                borderSide: BorderSide(color: Color(0xff3B916E)),
                highlightedBorderColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/google_logo.png",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Text(
                      "Continue with Google",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
