
import 'package:get/get.dart';
import 'package:yellow_class_project/controllers/auth_controller.dart';

import 'controllers/user_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<FirebaseAuthController>(FirebaseAuthController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
  }
}
