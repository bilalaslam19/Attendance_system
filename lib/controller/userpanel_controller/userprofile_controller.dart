import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';
import '../../screens/user_dashboard/user_panel.dart';

class UserprofileController extends GetxController {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          userData.value = snapshot.data();
        } else {
          Get.snackbar("Error", "User data not found.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to fetch user data: $e",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update(updatedData);
        userData.value = updatedData; // Update the observable with new data
        Get.defaultDialog(
          title: "Success",
          middleText: "Profile updated successfully!",
          backgroundColor: Colors.green,
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: Colors.white),
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Error",
          middleText: "Failed to update profile: $e",
          backgroundColor: Colors.red,
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: Colors.white),
        );
      }
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Reference ref = _storage.ref().child('user_images').child(user.uid);
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }
      return null;
    } catch (e) {
      Get.defaultDialog(
        title: "Error",
        middleText: "Failed to upload image: $e",
        backgroundColor: Colors.red,
        titleStyle: const TextStyle(color: Colors.white),
        middleTextStyle: const TextStyle(color: Colors.white),
      );
      return null;
    }
  }

  Future<void> saveUpdateProfile(
      String name, String fatherName, File? imageFile) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    Get.defaultDialog(
      title: "Updating",
      middleText: "Please wait while your profile is being updated.",
      barrierDismissible: false,
      backgroundColor: Colors.blueAccent,
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white),
    );

    Map<String, dynamic> updatedData = {
      'name': name,
      'fatherName': fatherName,
    };

    if (imageFile != null) {
      String? imageUrl = await uploadImage(imageFile);
      if (imageUrl != null) {
        updatedData['imageUrl'] = imageUrl;
      }
    }

    try {
      await updateUserProfile(updatedData);

      Get.back();
      Get.defaultDialog(
        title: "Profile Updated",
        middleText: "Profile updated successfully",
        backgroundColor: Colors.green,
        titleStyle: const TextStyle(color: Colors.white),
        middleTextStyle: const TextStyle(color: Colors.white),
      );
    } catch (error) {
      Get.back();
      Get.defaultDialog(
        title: "Error",
        middleText: "Failed to update profile: $error",
        backgroundColor: Colors.red,
        titleStyle: const TextStyle(color: Colors.white),
        middleTextStyle: const TextStyle(color: Colors.white),
      );
    }
  }

  final TextEditingController leaveController = TextEditingController();

  Future<void> saveLeaveRequest(String leaveDescription) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final leaveData = {
          'name': userData['name'],
          'rollNo': userData['rollNo'],
          'date': DateTime.now(),
          'status': 'Leave',
          'description': leaveDescription,
        };

        await FirebaseFirestore.instance
            .collection('data')
            .doc('${userData['rollNo']}_${DateTime.now().toString()}')
            .set(leaveData);

        Get.snackbar(
          "Success",
          "Leave request submitted successfully!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => const UserPanel());
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to submit leave request: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

Rx<UserModel?> selectedUser = Rx<UserModel?>(null);

Future<void> fetchUserDataByRollNo(String rollNo) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('rollNo', isEqualTo: rollNo)
        .get();

    if (snapshot.docs.isNotEmpty) {
      selectedUser.value = UserModel.fromMap({});
    } else {
      Get.snackbar("Error", "No user found with roll number: $rollNo",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to fetch user data: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }
}
