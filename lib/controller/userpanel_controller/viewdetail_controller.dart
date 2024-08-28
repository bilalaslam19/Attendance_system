import 'package:attendence/controller/userpanel_controller/userprofile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewdetailController extends GetxController {
  final RxMap<DateTime, List<Map<String, dynamic>>> groupedAttendanceData =
      RxMap({});
  final UserprofileController userprofileController =
      Get.put(UserprofileController());
  Future<void> fetchUserAttendanceData() async {
    try {
      String? rollNo =
          Get.put(UserprofileController()).userData.value?['rollNo'];

      if (rollNo != null) {
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
      } else {
        Get.snackbar("Error", "Roll number not found.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch attendance data: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
