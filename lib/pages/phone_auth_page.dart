import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yellow_class_project/controllers/auth_controller.dart';
import 'package:yellow_class_project/controllers/user_controller.dart';
import 'package:yellow_class_project/models/user.dart';

class PhoneAuthPage extends StatefulWidget {
  static String routeName = "/phone_auth_page";

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isOTPWidgetVisible = false;
  String _otpString = "";
  String _verificationCode;
  final TextEditingController _phoneController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initPhoneAuth(BuildContext ctx) async {

    final PhoneVerificationFailed verificationFailed = (e) {
      setState(() {
        print(e.message);
        _isLoading = false;
      });
      Get.snackbar(
        "Error",
        "Something went wrong!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    };

    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      print("code sent");
      setState(() {
        _isLoading = false;
        _isOTPWidgetVisible = true;
        _verificationCode = verificationId;
      });
    };

    final PhoneVerificationCompleted verificationCompleted = (AuthCredential authCredential) async {
      try {
        UserController userController = UserController.to;
        UserCredential userCred = await _auth.signInWithCredential(authCredential);
        ApiUser user;
        if (userCred.additionalUserInfo.isNewUser) {
          print("[] New user google sign in");
          //New user
          user = userController.createNewUser(newUser: userCred.user);
          // user = await createUserInBackend(user: newUser);
        } else {
          //Old user, get from hive, if not present get from backend
          print("[] Fetch user with Firebase UID");
          user = await userController.getUserFromFirebase(firebaseUid: userCred.user.uid);
          UserController.to.user = user;
        }

        Get.snackbar("Account logged in",
            "${user.email}",
            snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
        print("[] Google sign in complete");
      } catch (e) {
        Get.snackbar(
          "Error",
          "Something went wrong!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    };

    setState(() {
      _isLoading = true;
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91" + _phoneController.text,
      timeout: Duration(seconds: 90),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {
        print(verificationId);
        print("Timeout");
      },
    );
  }

  Future<void> signInPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationCode,
      smsCode: smsCode,
    );
    try {
      setState(() {
        _isLoading = true;
      });
      UserController userController = UserController.to;
      UserCredential userCred = await _auth.signInWithCredential(credential);
      ApiUser user;
      if (userCred.additionalUserInfo.isNewUser) {
        print("[] New user google sign in");
        //New user
        user = userController.createNewUser(newUser: userCred.user);
        // user = await createUserInBackend(user: newUser);
      } else {
        //Old user, get from hive, if not present get from backend
        print("[] Fetch user with Firebase UID");
        user = await userController.getUserFromFirebase(firebaseUid: userCred.user.uid);
        UserController.to.user = user;
      }

      Get.snackbar("Account logged in",
          "${user.email}",
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
      print("[] Google sign in complete");
    } on PlatformException catch (err) {
      if (err.code == "ERROR_INVALID_VERIFICATION_CODE") {
        Get.snackbar(
          "Error",
          "Invalid OTP",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      _isLoading = false;
      Get.snackbar(
        "Error",
        "Something went wrong!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'News Summarizer',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    enabled: !_isOTPWidgetVisible,
                    validator: (value) {
                      if (value.length < 10) {
                        return 'Please enter a valid number!';
                      }
                      return null;
                    },
                    controller: _phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                      hintText: '8197513721',
                      icon: Icon(Icons.phone, color: Color(0xff3B916E)),
                    ),
                  ),
                  SizedBox(height: 8),
                  Visibility(
                    visible: _isOTPWidgetVisible,
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Edit phone number",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isOTPWidgetVisible = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isOTPWidgetVisible,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text("Enter the OTP received"),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: PinCodeTextField(
                    animationType: AnimationType.slide,
                    textInputType: TextInputType.number,
                    length: 6,
                    backgroundColor: Colors.transparent,
                    enabled: !_isLoading,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    pinTheme: PinTheme(
                      selectedColor: Theme.of(context).accentColor,
                      activeColor: Theme.of(context).accentColor,
                      inactiveColor: Theme.of(context).accentColor,
                      fieldWidth: 40,
                    ),
                    onCompleted: (value) {
                      setState(() {
                        _otpString = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(24),
            width: 100,
            height: 45,
            child: MaterialButton(
              child: (!_isLoading)
                  ? Text(
                "NEXT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              )
                  : Container(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
              disabledColor: Theme.of(context).accentColor.withOpacity(0.7),
              onPressed: (!_isLoading)
                  ? () {
                if (_isOTPWidgetVisible) {
                  signInPhoneNumber(_otpString);
                } else {
                  if (_formkey.currentState.validate()) {
                    initPhoneAuth(context);
                  }
                }
              }
                  : null,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
