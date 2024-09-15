import 'package:attendence/screens/user_dashboard/view_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/userpanel_controller/viewdetail_controller.dart';
import '../admin_controller.dart/userdetail_controller.dart';

import 'all_records.dart';

class UserDetailScreen extends StatefulWidget {
  final String rollNo;

  const UserDetailScreen(this.rollNo, {super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with SingleTickerProviderStateMixin {
  final UserDetaillController userDetaillController =
      Get.put(UserDetaillController());
  final ViewdetailController viewdetailController =
      Get.put(ViewdetailController());

  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      userDetaillController.fetchUserDataByRollNo(widget.rollNo);
      viewdetailController.fetchUserAttendanceData(widget.rollNo);
    });

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.deepPurple[400],
          centerTitle: true,
          title: Text(
            tabController.index == 0 ? "Profile" : "Attendance",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 25.0,
            ),
          ),
          bottom: TabBar(controller: tabController, tabs: const [
            Tab(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.details,
                color: Colors.white,
              ),
            ),
          ]),
          leading: InkWell(
            onTap: () => Get.to(() => const AllRecords()),
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Obx(() {
            var user = userDetaillController.selectedUser.value;
            if (user == null) {
              return userDetaillController.isUserLoading.value
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Colors.deepPurple))
                  : const Center(child: Text('No user details available.'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 270,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.deepPurple[300],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Name: ${user.name ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                            const SizedBox(
                              height: 16.5,
                            ),
                            Text('Father Name: ${user.fatherName ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                            const SizedBox(
                              height: 16.5,
                            ),
                            Text('Roll No: ${user.rollNo ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                            const SizedBox(
                              height: 16.5,
                            ),
                            Text('Address: ${user.address ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                            const SizedBox(
                              height: 16.5,
                            ),
                            Text('Gender: ${user.gender ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                            const SizedBox(
                              height: 16.5,
                            ),
                            Text('Phone: ${user.phone ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                            const SizedBox(
                              height: 16.5,
                            ),
                            Text('Course: ${user.course ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
          Obx(() {
            if (viewdetailController.groupedAttendanceData.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewdetailController.groupedAttendanceData.isEmpty) {
              return const Center(child: Text('No attendance data available.'));
            } else {
              return ListView.builder(
                itemCount: viewdetailController.groupedAttendanceData.length,
                itemBuilder: (context, index) {
                  var date = viewdetailController.groupedAttendanceData.keys
                      .toList()[index];
                  var records =
                      viewdetailController.groupedAttendanceData[date]!;

                  return InkWell(
                    onLongPress: () {
                      setState(() {
                        viewdetailController.groupedAttendanceData.remove(date);
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                                'Date: ${date.toLocal().toShortDateString()}'),
                            tileColor: Colors.deepPurple[300],
                            textColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          ...records.map((data) {
                            Color statusColor;
                            if (data['status'] == 'Absent') {
                              statusColor = Colors.redAccent;
                            } else if (data['status'] == 'Present') {
                              statusColor = Colors.green;
                            } else {
                              statusColor = Colors.grey;
                            }

                            return ListTile(
                              title: Text('Name: ${data['name']}'),
                              subtitle: Text(
                                  'Roll No: ${data['rollNo']}\nStatus: ${data['status']}'),
                              tileColor: statusColor.withOpacity(0.2),
                              textColor: statusColor,
                              contentPadding: const EdgeInsets.all(16),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
        ],
      ),
    );
  }

  Future<void> deleteLeaveRequest(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(docId)
          .delete();
      print('Leave request deleted successfully');
    } catch (e) {
      print('Error deleting leave request: $e');
      throw Exception('Failed to delete leave request');
    }
  }
}

// extension DateTimeExtension on DateTime {
//   String toShortDateString() {
//     return "$day-$month-$year";
//   }
// }
