import 'package:attendence/model/attendence_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AttendanceModel>> getFilteredLeaveRequests(
      DateTime from, DateTime to, String status) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('data')
          .where('status', isEqualTo: status)
          .get();

      return querySnapshot.docs
          .map((doc) => AttendanceModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch leave requests: $e");
    }
  }

  Future<void> approveLeave(AttendanceModel leave) async {
    await _firestore.collection('data').doc(leave.id).update({
      'status': 'Leave',
    });
  }

  Future<void> updateLeaveStatus(String leaveId, String status) async {
    await FirebaseFirestore.instance
        .collection('data')
        .doc(leaveId)
        .update({'status': status});
  }
}
