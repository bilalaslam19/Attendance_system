import 'package:attendence/Admin_Panel/screen/admin_screen.dart';
import 'package:attendence/Admin_Panel/screen/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admin_controller.dart/user_controller.dart';

class AllRecords extends StatelessWidget {
  const AllRecords({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController =
        Get.put(UserController()); // Initialize the controller

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(0, 100),
          child: AppBar(
            backgroundColor: Colors.deepPurple[400],
            centerTitle: true,
            title: const Text(
              "All Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 25.0),
            ),
            leading: InkWell(
              onTap: () => Get.to(const AdminScreen()),
              child: Card(
                shadowColor: Colors.white,
                color: Colors.deepPurple[400],
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          )),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (userController.users.isEmpty) {
          return const Center(child: Text('No user records found.'));
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView.builder(
              itemCount: userController.users.length,
              itemBuilder: (BuildContext context, int index) {
                var user = userController.users[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => UserDetailScreen(user['rollNo']));
                  },
                  child: Card(
                    color: Colors.deepPurple[300],
                    child: ListTile(
                        title: Text(
                          'Name: ${user['name'] ?? 'N/A'}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ),
                        subtitle: Text(
                          'Roll No: ${user['rollNo'] ?? 'N/A'}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined,
                            color: Colors.white, size: 20)),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
