import 'dart:io';
import 'package:attendence/screens/user_dashboard/user_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../screens/user_dashboard/mark_attendence.dart';
import '../../screens/user_dashboard/user_registration.dart';

class RegistrationController extends GetxController {
  // TextEditingControllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  final RxnString selectedGender = RxnString(null);

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final Rxn<File> selectedImage = Rxn<File>();

  late Map<String, dynamic> userData = {};

  // Populate fields for editing
  void populateFields(Map<String, dynamic> userData) {
    nameController.text = userData['name'] ?? '';
    fatherNameController.text = userData['fatherName'] ?? '';
    rollNoController.text = userData['rollNo'] ?? '';
    addressController.text = userData['address'] ?? '';
    phoneController.text = userData['phone'] ?? '';
    courseController.text = userData['course'] ?? '';
    selectedGender.value = userData['gender'] ?? '';

    if (userData['imageUrl'] != null && userData['imageUrl'].isNotEmpty) {
      selectedImage.value = File(userData['imageUrl']);
    } else {
      selectedImage.value = null;
    }
  }

  // Method to handle user registration
  Future<void> onRegistration() async {
    String name = nameController.text;
    String fatherName = fatherNameController.text;
    String rollNo = rollNoController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String course = courseController.text;
    String? gender = selectedGender.value;

    if (_validateFields(
        name, fatherName, rollNo, address, phone, course, gender)) {
      try {
        User? user = auth.currentUser;
        if (user != null) {
          String uid = user.uid;
          String imageUrl = await uploadImage(uid);

          Map<String, dynamic> userData = {
            "name": name,
            "fatherName": fatherName,
            "rollNo": rollNo,
            "address": address,
            "gender": gender,
            "phone": phone,
            "course": course,
            "imageUrl": imageUrl,
          };

          await firestore.collection('users').doc(uid).set(userData);

          Get.snackbar("Success", "User data saved successfully!",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          Get.off(() => const UserPanel());
        } else {
          Get.snackbar("Error", "User is not logged in.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to save data: $e",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } else {
      Get.snackbar("Error", "Please fill in all fields and select an image.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  bool _validateFields(String name, String fatherName, String rollNo,
      String address, String phone, String course, String? gender) {
    return name.isNotEmpty &&
        fatherName.isNotEmpty &&
        rollNo.isNotEmpty &&
        address.isNotEmpty &&
        phone.isNotEmpty &&
        course.isNotEmpty &&
        gender != null &&
        selectedImage.value != null;
  }

  // Image upload method
  Future<String> uploadImage(String uid) async {
    if (selectedImage.value == null) {
      return '';
    }
    try {
      Reference ref = storage.ref().child('user_images').child(uid);
      UploadTask uploadTask = ref.putFile(selectedImage.value!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  // Method to edit user profile
  // Method to edit user profile
  Future<void> editUserProfile() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          populateFields(snapshot.data()!);
          Get.to(() =>
              const UserRegistration()); // Navigate to the registration screen for editing
        } else {
          Get.snackbar("Error", "User data not found.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to load user data: $e",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }

  // Method to save edited profile data
  Future<void> saveUserProfile() async {
    String name = nameController.text;
    String fatherName = fatherNameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String course = courseController.text;
    String? gender = selectedGender.value;

    if (_validateFields(name, fatherName, rollNoController.text, address, phone,
        course, gender)) {
      try {
        User? user = auth.currentUser;
        if (user != null) {
          String uid = user.uid;
          String imageUrl = await uploadImage(uid);

          Map<String, dynamic> updatedUserData = {
            "name": name,
            "fatherName": fatherName,
            "address": address,
            "gender": gender,
            "phone": phone,
            "course": course,
            "imageUrl": imageUrl,
          };

          await firestore.collection('users').doc(uid).update(updatedUserData);

          Get.snackbar("Success", "User profile updated successfully!",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          Get.off(() => const UserPanel());
        } else {
          Get.snackbar("Error", "User is not logged in.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to update profile: $e",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } else {
      Get.snackbar("Error", "Please fill in all fields and select an image.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // Method to get user data
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          return snapshot.data();
        } else {
          Get.snackbar("Error", "User data not found.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          return null;
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to load user data: $e",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return null;
      }
    } else {
      Get.snackbar("Error", "User is not logged in.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return null;
    }
  }

  Future<void> fetchUserDataAndNavigate() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data();
          if (data != null) {
            Get.to(() => const MarkAttendance());
          }
        } else {
          Get.snackbar("Error", "User data not found.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to load user data: $e",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } else {
      Get.snackbar("Error", "User is not logged in.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> saveAttendance(
      DateTime selectedDate, bool isPresent, userData) async {
    try {
      final attendanceData = {
        'name': userData['name'],
        'rollNo': userData['rollNo'],
        'date': selectedDate,
        'status': isPresent ? 'Present' : 'Absent'
      };

      await FirebaseFirestore.instance
          .collection('data')
          .doc('${userData['rollNo']}_${selectedDate.toString()}')
          .set(attendanceData);

      Get.snackbar(
        "Success",
        "Attendance marked successfully!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.to(() => const UserPanel());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to mark attendance: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearFields() {
    nameController.clear();
    fatherNameController.clear();
    rollNoController.clear();
    addressController.clear();
    phoneController.clear();
    courseController.clear();
    selectedGender.value = null;
    selectedImage.value = null;
  }
}
