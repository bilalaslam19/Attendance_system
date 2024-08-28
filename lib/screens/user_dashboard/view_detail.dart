import 'package:attendence/controller/userpanel_controller/viewdetail_controller.dart';
import 'package:attendence/screens/user_dashboard/user_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewDetail extends StatelessWidget {
  final ViewdetailController viewdetailController =
      Get.put(ViewdetailController());

  // ViewDetail({super.key}) {
  //   viewdetailController.fetchUserAttendanceData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          leading: InkWell(
            onTap: () => Get.to(const UserPanel()),
            child: Card(
                shadowColor: Colors.white,
                color: Colors.deepPurple[400],
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                )),
          ),
          title: const Text(
            'Attendance Details',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w200),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple[400],
        ),
      ),
      body: Obx(() {
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
              var records = viewdetailController.groupedAttendanceData[date]!;

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      title:
                          Text('Date: ${date.toLocal().toShortDateString()}'),
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
              );
            },
          );
        }
      }),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return "$day-$month-$year";
  }
}
