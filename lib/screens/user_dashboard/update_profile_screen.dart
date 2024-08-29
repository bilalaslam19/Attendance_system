// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:attendence/widgets/button.dart';
import 'package:get/get.dart';
import 'package:attendence/controller/registration_controller/image_picker_controller.dart';
import '../../controller/registration_controller/registration_controller.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ImagePickerController imageController =
      Get.put(ImagePickerController());
  final RegistrationController registrationController =
      Get.put(RegistrationController());

  @override
  @override
  void initState() {
    super.initState();
    registrationController.getUserData();
    // registrationController
    //     .editUserProfile(); // Fetch user data when screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: imageController.imageFile.value != null
                            ? FileImage(imageController.imageFile.value!)
                            : null,
                        child: imageController.imageFile.value == null
                            ? const Icon(Icons.person, size: 64)
                            : null,
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () async {
                            // ignore: avoid_print
                            print("image selected");
                            await imageController.getImage();
                            registrationController.selectedImage.value =
                                imageController.imageFile.value;
                          },
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              TextField(
                controller: registrationController.nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.5),
              TextField(
                controller: registrationController.fatherNameController,
                decoration: const InputDecoration(
                  labelText: "Father's Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.5),
              TextField(
                controller: registrationController.addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.5),
              DropdownButtonFormField<String>(
                value: registrationController.selectedGender.value,
                onChanged: (value) {
                  setState(() {
                    registrationController.selectedGender.value = value!;
                  });
                },
                items: ["Male", "Female", "Other"]
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  registrationController.editUserProfile();
                },
                text: 'update',
              )
            ],
          ),
        ),
      ),
    );
  }
}
