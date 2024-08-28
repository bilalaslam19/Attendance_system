import 'package:get/get.dart';

class GenderController extends GetxController {
  var selectedGender = ''.obs;

  void setSelectedGender(String gender) {
    selectedGender.value = gender;
  }
}
