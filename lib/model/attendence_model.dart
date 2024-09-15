import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String name;
  final String rollNo;
  final DateTime date;
  final String status;
  final String description;

  AttendanceModel({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.date,
    required this.status,
    required this.description,
  });

  factory AttendanceModel.fromMap(String id, Map<String, dynamic> data) {
    return AttendanceModel(
      id: id,
      name: data['name'] ?? '',
      rollNo: data['rollNo'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
