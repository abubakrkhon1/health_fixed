class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String gender;
  final String dob; // Or DateTime if you want to parse it

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.gender,
    required this.dob,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['full_name'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
      dob: map['dob'] as String,
    );
  }
}
