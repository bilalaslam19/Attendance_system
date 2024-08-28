import 'package:attendence/controller/registration_controller/registration_controller.dart';
import 'package:attendence/controller/userpanel_controller/userprofile_controller.dart';
import 'package:attendence/screens/user_dashboard/user_panel.dart';
import 'package:attendence/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_calender.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  DateTime _selectedDate = DateTime.now();
  bool _isPresent = true;
  bool _isToday = true;

  @override
  void initState() {
    super.initState();
    _checkIfToday(_selectedDate);
  }

  void _checkIfToday(DateTime date) {
    setState(() {
      _isToday = date.isAtSameMomentAs(DateTime.now().toLocal().startOfDay);
    });
  }

  final UserprofileController userprofileController =
      Get.put(UserprofileController());
  final RegistrationController registrationController =
      Get.put(RegistrationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () {
                      Get.off(const UserPanel());
                    },
                    child: SizedBox(
                      height: 50,
                      child: Card(
                          color: Colors.deepPurple[400],
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 40,
                          )),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Attendence",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            )),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomCalender(
                onDateSelected: (date) {
                  if (!_isToday) {
                    setState(() {
                      _selectedDate = date;
                      _checkIfToday(date);
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(12.0),
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 230,
              width: double.infinity,
              child: Card(
                color: const Color.fromARGB(255, 172, 139, 230),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          if (userprofileController.userData.value == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            var data = userprofileController.userData.value!;
                            return CustomText(
                              title:
                                  'Name : ${data['name']} \nRollNo :  ${data['rollNo']}',
                            );
                          }
                        }),
                        const SizedBox(height: 10),
                        Text(
                          "Date: ${DateFormat.yMMMd().format(_selectedDate)}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(height: 16.5),
                        Text(
                          "Status: ${_isPresent ? 'Present' : 'Absent'}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _isPresent,
                  onChanged: _isToday
                      ? null
                      : (value) {
                          setState(() {
                            _isPresent = value!;
                          });
                        },
                ),
                const Text(
                  "Present",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Radio<bool>(
                  value: false,
                  groupValue: _isPresent,
                  onChanged: _isToday
                      ? null
                      : (value) {
                          setState(() {
                            _isPresent = value!;
                          });
                        },
                ),
                const Text("Absent"),
              ],
            ),
          ),
          Center(
            child: CustomButton(
                text: "Submit",
                onPressed: () {
                  registrationController.saveAttendance(
                    _selectedDate,
                    _isPresent,
                    userprofileController.userData.value!,
                  );
                }),
          )
        ],
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
}
