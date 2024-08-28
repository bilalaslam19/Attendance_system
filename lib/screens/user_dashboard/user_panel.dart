import 'package:attendence/controller/registration_controller/registration_controller.dart';
import 'package:attendence/screens/user_dashboard/leave.dart';
import 'package:attendence/screens/user_dashboard/view_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/userpanel_controller/userprofile_controller.dart';
import '../../screens/user_dashboard/mark_attendence.dart';
import '../../screens/user_dashboard/user_profile.dart';
import '../../widgets/box_container.dart';
import '../../widgets/custom_container.dart';
import '../auth_ui.dart/login.dart';

class UserPanel extends StatefulWidget {
  const UserPanel({super.key});

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  final UserprofileController userprofileController =
      Get.put(UserprofileController());
  final RegistrationController registrationController =
      Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Obx(() {
                  if (userprofileController.userData.value == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var data = userprofileController.userData.value!;
                    return CustomContainer(
                      title: 'Welcome!  \n${data['name']} ',
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w200),
                    );
                  }
                }),
                Positioned(
                  bottom: -70,
                  left: 40,
                  child: BoxContainer(
                    title: 'Profile',
                    icon: Icons.person_2_sharp,
                    onPressed: () {
                      Get.to(() => const UserProfile());
                    },
                  ),
                ),
                Positioned(
                  bottom: -70,
                  right: 40,
                  child: BoxContainer(
                    title: 'Attendance',
                    icon: Icons.check_circle_outline,
                    onPressed: () {
                      Get.to(() => const MarkAttendance());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BoxContainer(
                        title: 'Leave',
                        icon: Icons.leave_bags_at_home,
                        onPressed: () {
                          Get.to(() => const Leave());
                        },
                      ),
                      BoxContainer(
                        title: 'View Detail',
                        icon: Icons.book_online_rounded,
                        onPressed: () {
                          Get.to(() => ViewDetail());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoxContainer(
                        title: 'Log Out',
                        icon: Icons.logout_outlined,
                        onPressed: () {
                          Get.defaultDialog(
                            title: "LogOut",
                            content:
                                const Text("Are you sure you want to LogOut?"),
                            textConfirm: "Confirm",
                            textCancel: "Cancel",
                            backgroundColor: Colors.white,
                            confirmTextColor: Colors.white,
                            cancelTextColor: Colors.black,
                            onCancel: () => Navigator.pop(context),
                            onConfirm: () => Get.to(() => const Login()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
