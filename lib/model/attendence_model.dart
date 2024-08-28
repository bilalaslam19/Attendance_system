import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  String name;
  String rollNo;
  DateTime date;
  bool isPresent;
  bool isAbsent;

  AttendanceModel({
    required this.name,
    required this.rollNo,
    required this.date,
    this.isPresent = false,
    this.isAbsent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rollNo': rollNo,
      'date': Timestamp.fromDate(date),
      'isPresent': isPresent,
      'isAbsent': isAbsent,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      name: map['name'],
      rollNo: map['rollNo'],
      date: (map['date'] as Timestamp).toDate(),
      isPresent: map['isPresent'] ?? false,
      isAbsent: map['isAbsent'] ?? false,
    );
  }
}
