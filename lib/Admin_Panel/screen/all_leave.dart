import 'package:attendence/Admin_Panel/screen/admin_screen.dart';
import 'package:attendence/model/attendence_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_controller.dart/leave_service.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final LeaveService _leaveService = LeaveService();
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  final String _status = 'Leave';

  Future<List<AttendanceModel>>? _leaveRequests;

  void _fetchLeaveRequests() {
    setState(() {
      _leaveRequests =
          _leaveService.getFilteredLeaveRequests(_fromDate, _toDate, _status);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: const Text("Leave Request",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w200)),
        centerTitle: true,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.deepPurple[300],
                  title: const Text(
                    'Filter Leave Requests',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w200),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DatePicker(
                        label: 'From Date',
                        selectedDate: _fromDate,
                        onDateChanged: (date) =>
                            setState(() => _fromDate = date),
                      ),
                      DatePicker(
                        label: 'To Date',
                        selectedDate: _toDate,
                        onDateChanged: (date) => setState(() => _toDate = date),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _fetchLeaveRequests();
                      },
                      child: const Text(
                        'Apply',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AttendanceModel>>(
        future: _leaveRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No leave requests found.',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ));
          }

          List<AttendanceModel> leaveList = snapshot.data!;

          return ListView.builder(
            itemCount: leaveList.length,
            itemBuilder: (context, index) {
              final leave = leaveList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.deepPurple[200],
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name : ${leave.name}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          "RollNo : ${leave.rollNo}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          "Description: ${leave.description}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(height: 12.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () async {
                                  try {
                                    await _leaveService.approveLeave(leave);
                                    setState(() {
                                      leaveList.removeAt(index);
                                    });

                                    Get.snackbar(
                                      'Success',
                                      'Leave approved and marked as Leave',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } catch (e) {
                                    Get.snackbar(
                                      'Error',
                                      'Failed to approve leave: $e',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                child: const Text(
                                  "Approve",
                                  style: TextStyle(color: Colors.white),
                                )),
                            const SizedBox(width: 20),
                            TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  await _leaveService.updateLeaveStatus(
                                      leave.id, "Absent");

                                  setState(() {
                                    leaveList.removeAt(index);
                                  });

                                  Get.snackbar(
                                    'Success',
                                    'Leave request canceled and marked as Absent.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                child: const Text("Cancel",
                                    style: TextStyle(color: Colors.white)))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (newDate != null) onDateChanged(newDate);
            },
            child: Text('${selectedDate.toLocal()}'.split(' ')[0]),
          ),
        ),
      ],
    );
  }
}
