// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/gender_Controller.dart';

// class Dropdown extends StatelessWidget {
//   const Dropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final GenderController genderController = Get.find();

//     return Obx(() {
//       return SizedBox(
//         width: double.infinity, // Ensures it takes the full width of its parent
//         child: DropdownButtonFormField<String>(
//           value: genderController.selectedGender.value.isEmpty
//               ? null
//               : genderController.selectedGender.value,
//           onChanged: (value) {
//             if (value != null) {
//               genderController.setSelectedGender(value);
//             }
//           },
//           items: ["Male", "Female", "Other"]
//               .map((gender) => DropdownMenuItem(
//                     value: gender,
//                     child: Text(gender),
//                   ))
//               .toList(),
//           decoration: const InputDecoration(
//             labelText: "Gender",
//             border: OutlineInputBorder(),
//           ),
//         ),
//       );
//     });
//   }
// }
