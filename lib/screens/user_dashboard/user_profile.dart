import 'package:attendence/controller/userpanel_controller/fetch_userdata.dart';
import 'package:attendence/screens/user_dashboard/user_registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/userpanel_controller/userprofile_controller.dart';
import '../../screens/user_dashboard/update_profile_screen.dart';
import '../../widgets/custom_container.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/user_dashboard/user_panel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final UserprofileController userprofileController =
      Get.put(UserprofileController());
  final FetchUserDataController fetchUserDataController =
      Get.put(FetchUserDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 30),
          onPressed: () => Get.off(const UserPanel()),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Get.defaultDialog(
                title: "Update Profile",
                content:
                    const Text("Are you sure you want to update your profile?"),
                textConfirm: "Confirm",
                textCancel: "Cancel",
                backgroundColor: Colors.grey.shade400,
                confirmTextColor: Colors.black,
                cancelTextColor: Colors.black,
                onCancel: () => Navigator.pop(context),
                onConfirm: () => Get.to(() => const UserRegistration()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CustomContainer(
                title: "Profile",
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              Positioned(
                left: 145,
                bottom: -50,
                child: Obx(() {
                  if (userprofileController.userData.value == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var userData = userprofileController.userData.value!;
                    return PhysicalModel(
                      color: Colors.black,
                      elevation: 50.0,
                      shape: BoxShape.circle,
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: userData['imageUrl'] != null
                            ? NetworkImage(userData['imageUrl'])
                            : null,
                        child: userData['imageUrl'] == null
                            ? const Icon(Icons.person,
                                size: 64, color: Colors.white)
                            : null,
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Card(
            elevation: 10,
            shadowColor: Colors.deepPurple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Obx(() {
              if (userprofileController.userData.value == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var userData = userprofileController.userData.value!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name:  ${userData['name'] ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 8),
                      Text('Father Name:  ${userData['fatherName'] ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 8),
                      Text('Roll No:  ${userData['rollNo'] ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 8),
                      Text('Address:  ${userData['address'] ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 8),
                      Text('Phone Number:  ${userData['phone'] ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 8),
                      Text('Course Enrolled:  ${userData['course'] ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 8),
                      Text('Gender: ${userData['gender'] ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                    ],
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
