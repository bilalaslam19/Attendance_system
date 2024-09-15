import 'package:attendence/Admin_Panel/screen/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/attendence_model.dart';
import '../attendance_service.dart';

class AttendanceScreen extends StatelessWidget {
  final AttendanceService _attendanceService = AttendanceService();

  AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: PreferredSize(
        preferredSize: const Size(0, 100),
        child: AppBar(
          backgroundColor: Colors.deepPurple[300],
          centerTitle: true,
          title: const Text(
            "Daily Attendance",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 25.0,
            ),
          ),
          leading: InkWell(
            onTap: () => Get.to(const AdminScreen()),
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
      body: FutureBuilder<List<AttendanceModel>>(
        future: _attendanceService.getTodayAttendance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No attendance records found for today.',
              style: TextStyle(color: Colors.white),
            ));
          }

          List<AttendanceModel> attendanceList = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(
                    label: Text(
                  'Name',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'Roll No',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'Date',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'Status',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20),
                )),
              ],
              rows: attendanceList.map((attendance) {
                return DataRow(cells: [
                  DataCell(Text(
                    attendance.name,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )),
                  DataCell(Text(
                    attendance.rollNo,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )),
                  DataCell(Text(
                    "${attendance.date.day}-${attendance.date.month}-${attendance.date.year}",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )),
                  DataCell(
                    Text(
                      attendance.status == 'Present'
                          ? 'Present'
                          : attendance.status == 'Absent'
                              ? 'Absent'
                              : 'Leave',
                      style: TextStyle(
                        color: attendance.status == 'Present'
                            ? Colors.green
                            : attendance.status == 'Absent'
                                ? Colors.red
                                : Colors.grey[800],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
