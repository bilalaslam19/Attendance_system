import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  String uid;
  String name;
  String rollNo;
  DateTime date;
  String status; // Ensure this is a String

  AttendanceModel({
    required this.uid,
    required this.name,
    required this.rollNo,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rollNo': rollNo,
      'date': Timestamp.fromDate(date),
      'status': status, // Ensure this is a String
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      uid: map['uid'] ?? '', // Ensure defaults if necessary
      name: map['name'] ?? '',
      rollNo: map['rollNo'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] ?? 'Absent', // Default to 'Absent' if null
    );
  }
}
