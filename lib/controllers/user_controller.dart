import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:yellow_class_project/models/user.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  Rx<ApiUser> _user = ApiUser().obs;

  ApiUser get user => _user.value;

  var userBox = Hive.box<ApiUser>('userBox');

  set user(ApiUser value) => this._user.value = value;

  @override
  void onInit() {
    super.onInit();
    ApiUser hiveUser = fetchFromHive();
    user = hiveUser;
    _user.listen((user) => saveToHive(user: user, save: true));
  }

  void createUserInFirebase({ApiUser newUser}) {
    print("[UserProvider] Creating user in firebase");
    FirebaseFirestore.instance.collection('user').doc(newUser.firebaseUid).set(newUser.toJson(newUser));
  }

  ApiUser createNewUser({User newUser, String phoneNumber = ""}) {
    print("[UserProvider] Creating user in provider");
    user = ApiUser(
        photoUrl: newUser.photoURL,
        email: newUser.email,
        name: newUser.displayName,
        firebaseUid: newUser.uid,
        phoneNumber: phoneNumber);
    createUserInFirebase(newUser: user);
    saveToHive(user: user);
    return user;
  }

  Future<ApiUser> getUserFromFirebase({String firebaseUid}) async {
    var response = await FirebaseFirestore.instance.collection('user').doc(firebaseUid).get();
    ApiUser fireUser = ApiUser.fromJson(response.data());
    print(fireUser.toJson(fireUser));
    return fireUser;
  }



  ApiUser fetchFromHive() {
    ApiUser hiveUser = userBox.get("user");
    if (hiveUser != null) {
      print("[UserController] Fetched user from Hive");
      user = hiveUser;
      return user;
    } else {
      print("[UserController] No saved user in Hive");
      return null;
    }
  }

  void saveToHive({ApiUser user, bool save = false}) {
    if (save) {
      print("[UserController] Changes in user saved to Hive");
      userBox.put("user", user);
    }
  }

}
