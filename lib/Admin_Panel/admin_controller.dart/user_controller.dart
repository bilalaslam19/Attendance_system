import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var users = <Map<String, dynamic>>[].obs; // Observable list of user data
  var isLoading = true.obs; // Observable for loading state

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers(); // Fetch users when the controller is initialized
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading(true);
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      users.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
