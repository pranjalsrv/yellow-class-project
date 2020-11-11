
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yellow_class_project/controllers/user_controller.dart';
import 'package:yellow_class_project/models/user.dart';

class FirebaseAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User> firebaseUser = Rx<User>();
  RxBool loadDone = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );

  static FirebaseAuthController get to => Get.find();

  // UserController userController = UserController.to;

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.idTokenChanges());
  }

  Future<void> silentSignInWithOldUser({ApiUser user}) async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signInSilently();
    print("[FirebaseAuthController] Silent sign in with old user");
    if (!googleSignInAccount.isNull) {
      // print("123123"+googleSignInAccount.email);
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await _auth.signInWithCredential(credential);
      UserController.to.user = user;
      print("[FirebaseAuthController] silentSignInWithOldUser");
    } else {
      print("[FirebaseAuthController] Error in silent sign in");
    }
  }

  Future<UserCredential> autoSignInGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount;
      googleSignInAccount = await _googleSignIn.signInSilently();
      if (googleSignInAccount == null) {
        googleSignInAccount = await _googleSignIn.signIn();
        print("[FirebaseAuthController] Not silent sign in");
      }
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCred = await _auth.signInWithCredential(credential);
      return userCred;
    } catch (e, stacktrace) {
      Get.snackbar("[FirebaseAuthController] Error creating Account", e.toString(),
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
      print(stacktrace);
      print(e);
    }
  }

  Future<String> getTokenId() async {
    return await firebaseUser.value.getIdToken().then((value) => value).catchError((error) => print(error));
  }

  void signOut() async {
    await _googleSignIn.signOut();
  }

  Future<ApiUser> signUpWithEmailAndPassword(
      {@required String email,
      @required String password,
      String firstName,
      String lastName,
      DateTime dateOfBirth}) async {
    try {
      UserCredential _authResult =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      ApiUser user;
      if (_authResult.additionalUserInfo.isNewUser) {
        print(_authResult.user.photoURL);
        ApiUser newUser = new ApiUser(
            email: _authResult.user.email,
            firebaseUid: _authResult.user.uid,
            phoneNumber: "",
            photoUrl:
                "https://upload.wikimedia.org/wikipedia/commons/5/5d/Kamchatka_Brown_Bear_near_Dvuhyurtochnoe_on_2015-07-23.jpg"); //TODO: Set default profile image
        // user = await createUserInBackend(user: newUser);
      } else {
        //Old user, get from hive, if not present get from backend
        user = await UserController().getUserFromFirebase(firebaseUid: _authResult.user.uid);
      }
      UserController.to.user = user;
      Get.snackbar("[FirebaseAuthController] Account logged in", "${user.email}",
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
      print("[FirebaseAuthController] signUpWithEmailAndPassword");
      return user;
      // Get.offAllNamed("/home");
    } catch (e, traceback) {
      print(traceback);
      Get.snackbar(
        "[FirebaseAuthController] Error signing in",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<ApiUser> logInWithEmailAndPassword({@required String email, @required String password}) async {
    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      ApiUser user = await UserController().getUserFromFirebase(firebaseUid: _authResult.user.uid);

      UserController.to.user = user;
      Get.snackbar("Account logged in", "${user.email}",
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
      print("logInWithEmailAndPassword");
      return user;
      // Get.offAllNamed("/home");
    } catch (e, traceback) {
      print(traceback);
      Get.snackbar(
        "Error signing in",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
