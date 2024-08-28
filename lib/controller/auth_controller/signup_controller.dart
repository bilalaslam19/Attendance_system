import 'package:attendence/controller/userpanel_controller/userprofile_controller.dart';
import 'package:attendence/screens/user_dashboard/user_registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final UserprofileController userprofileController =
      Get.put(UserprofileController());

  void onSignUp() async {
    isLoading.value = true;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      Get.snackbar(
        "Success",
        "Account created successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.to(const UserRegistration());
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage = "The password provided is too weak.";
          break;
        case 'email-already-in-use':
          errorMessage = "The account already exists for that email.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        default:
          errorMessage = "An error occurred. Please try again.";
          break;
      }

      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again later.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();

      userprofileController.userData.value = null;

      Get.to(() => '/login');
    } catch (e) {
      Get.snackbar("Error", "Failed to log out: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
