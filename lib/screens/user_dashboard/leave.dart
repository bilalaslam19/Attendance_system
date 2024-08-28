import 'package:attendence/controller/userpanel_controller/userprofile_controller.dart';
import 'package:attendence/screens/user_dashboard/user_panel.dart';
import 'package:attendence/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Leave extends StatefulWidget {
  const Leave({super.key});

  @override
  State<Leave> createState() => _LeaveState();
}

class _LeaveState extends State<Leave> {
  final UserprofileController userprofileController =
      Get.put(UserprofileController());

  @override
  void initState() {
    super.initState();
    userprofileController.leaveController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.deepPurple[300],
          title: const Text(
            'Leave',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w200,
              fontStyle: FontStyle.normal,
            ),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Get.to(const UserPanel()),
            child: Card(
              shadowColor: Colors.white,
              color: Colors.deepPurple[300],
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16.5),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Card(
                color: Colors.deepPurple[300],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    maxLines: 5,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                    controller: userprofileController.leaveController,
                    onSubmitted: (value) {
                      userprofileController.leaveController.clear();
                    },
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    cursorColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              text: "Submit",
              onPressed: () {
                userprofileController.saveLeaveRequest(
                    userprofileController.leaveController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
