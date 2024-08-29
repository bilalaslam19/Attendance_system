import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/user_model.dart';

class UserDetaillController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxMap<DateTime, List<Map<String, dynamic>>> groupedAttendanceData =
      RxMap({});

  Rx<UserModel?> selectedUser = Rx<UserModel?>(null);
  RxBool isUserLoading = false.obs;
  RxBool isAttendanceLoading = false.obs;

  Future<void> fetchUserDataByRollNo(String rollNo) async {
    isUserLoading.value = true;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('users')
          .where('rollNo', isEqualTo: rollNo)
          .get();

      if (snapshot.docs.isNotEmpty) {
        selectedUser.value = UserModel.fromMap(snapshot.docs.first.data());
      } else {
        selectedUser.value = null;
        Get.snackbar(
          "Error",
          "No user found with roll number: $rollNo",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch user data: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUserLoading.value = false;
    }
  }

}