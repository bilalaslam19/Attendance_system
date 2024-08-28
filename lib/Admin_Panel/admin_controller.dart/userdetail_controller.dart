import 'package:attendence/model/attendence_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/userpanel_controller/userprofile_controller.dart';
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

  Future<void> fetchUserAttendanceByRollNo(String rollNo) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('data')
          .where('rollNo', isEqualTo: rollNo)
          .get();

      Map<DateTime, List<Map<String, dynamic>>> groupedData = {};
      for (var doc in snapshot.docs) {
        var data = doc.data();
        DateTime date = (data['date'] as Timestamp).toDate().toLocal();

        if (groupedData[date] == null) {
          groupedData[date] = [];
        }
        groupedData[date]!.add(data);
      }

      groupedAttendanceData.value = groupedData;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch attendance data: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
