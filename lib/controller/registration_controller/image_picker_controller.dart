import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImagePickerController extends GetxController {
  var imageFile = Rxn<File>();

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imageFile.value = File(image.path);
    }
  }

  Future<String?> uploadImage(String userId, File file) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$userId');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return null;
    }
  }
}
