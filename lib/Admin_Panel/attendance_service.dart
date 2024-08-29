import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/attendence_model.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AttendanceModel>> getTodayAttendance() async {
    // Get the current date
    DateTime today = DateTime.now();

    // Define the start and end of the day
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay =
        DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Query Firestore for documents within today's date range
    QuerySnapshot querySnapshot = await _firestore
        .collection(
            'data') // Ensure this matches your Firestore collection name
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    // Convert the documents into AttendanceModel instances and return the list
    return querySnapshot.docs
        .map((doc) =>
            AttendanceModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
