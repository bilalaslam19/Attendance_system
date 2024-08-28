//  var user = userDetaillController.selectedUser.value;
//             if (user == null) {
//               return userDetaillController.isUserLoading.value
//                   ? const Center(
//                       child:
//                           CircularProgressIndicator(color: Colors.deepPurple))
//                   : const Center(child: Text('No user details available.'));
//             } else {
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SizedBox(
//                   height: 270,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Card(
//                       color: Colors.deepPurple[300],
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Name: ${user.name ?? 'N/A'}',
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w200)),
//                             Text('Father Name: ${user.fatherName ?? 'N/A'}',
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w200)),
//                             Text('Roll No: ${user.rollNo ?? 'N/A'}',
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w200)),
//                             Text('Address: ${user.address ?? 'N/A'}',
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w200)),
//                             Text('Gender: ${user.gender ?? 'N/A'}',
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w200)),
//                             Text('Phone: ${user.phone ?? 'N/A'}',
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w200)),
//                             Text('Course: ${user.course ?? 'N/A'}',
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w200)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }


//             Obx(() {
//             var attendanceData = userDetaillController.attendanceRecords;
//             if (attendanceData.isEmpty) {
//               return userDetaillController.isAttendanceLoading.value
//                   ? const Center(child: CircularProgressIndicator())
//                   : const Center(child: Text('No attendance data available.'));
//             } else {
//               return Expanded(
//                 child: ListView.builder(
//                   itemCount: attendanceData.length,
//                   itemBuilder: (context, index) {
//                     var date = DateTime.parse(attendanceData[index]['date']);
//                     var records = attendanceData.where(
//                         (record) => DateTime.parse(record['date']) == date);

//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 16),
//                       child: Column(
//                         children: [
//                           ListTile(
//                             title: Text(
//                                 'Date: ${date.toLocal().toShortDateString()}'),
//                             tileColor: Colors.deepPurple[300],
//                             textColor: Colors.white,
//                             contentPadding: const EdgeInsets.all(16),
//                           ),
//                           ...records.map((data) {
//                             Color statusColor;
//                             if (data['status'] == 'Absent') {
//                               statusColor = Colors.redAccent;
//                             } else if (data['status'] == 'Present') {
//                               statusColor = Colors.green;
//                             } else {
//                               statusColor = Colors.grey;
//                             }

//                             return ListTile(
//                               title: Text('Name: ${data['name']}'),
//                               subtitle: Text(
//                                   'Roll No: ${data['rollNo']}\nStatus: ${data['status']}'),
//                               tileColor: statusColor.withOpacity(0.2),
//                               textColor: statusColor,
//                               contentPadding: const EdgeInsets.all(16),
//                             );
//                           }),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//           }),