class UserModel {
  String? name;
  String? fatherName;
  String? rollNo;
  String? address;
  String? gender;
  String? phone;
  String? course;
  String? imageUrl;

  UserModel({
    this.name,
    this.fatherName,
    this.rollNo,
    this.address,
    this.gender,
    this.phone,
    this.course,
    this.imageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return UserModel();

    return UserModel(
      name: map['name'] as String?,
      fatherName: map['fatherName'] as String?,
      rollNo: map['rollNo'] as String?,
      address: map['address'] as String?,
      gender: map['gender'] as String?,
      phone: map['phone'] as String?,
      course: map['course'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fatherName': fatherName,
      'rollNo': rollNo,
      'address': address,
      'gender': gender,
      'phone': phone,
      'course': course,
      'imageUrl': imageUrl,
    };
  }
}
