import 'package:attendence/Admin_Panel/admin_controller.dart/user_controller.dart';
import 'package:attendence/Admin_Panel/screen/all_records.dart';
import 'package:attendence/Admin_Panel/screen/attendance_screen.dart';
import 'package:attendence/controller/auth_controller/signup_controller.dart';
import 'package:attendence/controller/userpanel_controller/viewdetail_controller.dart';
import 'package:attendence/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final SignupController signupController = Get.put(SignupController());

  final ViewdetailController viewdetailController =
      Get.put(ViewdetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(0, 100),
          child: AppBar(
            backgroundColor: Colors.deepPurple[400],
            centerTitle: true,
            title: const Text(
              "Admin Screen",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 25.0),
            ),
            leading: const SizedBox(),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      title: " All Records",
                      icon: Icons.details,
                      onPressed: () {
                        Get.to(() => const AllRecords());
                      },
                    ),
                  ),
                  const SizedBox(width: 13.0),
                  Expanded(
                    child: CustomCard(
                      title: "Attendence",
                      icon: Icons.check_circle_outline,
                      onPressed: () {
                        Get.to(() => AttendanceScreen());
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      title: "System Report",
                      icon: Icons.report_gmailerrorred,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 13.0),
                  Expanded(
                    child: CustomCard(
                      title: "Leave Approval",
                      icon: Icons.leave_bags_at_home_sharp,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomCard(
                title: "LogOut",
                icon: Icons.logout_outlined,
                onPressed: () {
                  signupController.logout();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
