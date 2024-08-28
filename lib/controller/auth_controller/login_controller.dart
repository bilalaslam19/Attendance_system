import 'package:attendence/controller/userpanel_controller/userprofile_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../screens/user_dashboard/user_panel.dart';

class LoginController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final UserprofileController userprofileController =
      Get.put(UserprofileController());

  Future<void> onLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Clear any old user data
      // userprofileController.userData.clear();

      // Fetch new user data
      await userprofileController.fetchUserData();

      // Navigate to the user panel
      // Get.offAllNamed('/userPanel'); // Replace with your user panel route
    } catch (e) {
      Get.snackbar("Error", "Failed to log in: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
