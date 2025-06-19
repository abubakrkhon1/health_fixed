class DoctorModel {
  final String id;
  final String fullName;
  final String specialization;
  final String phone;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.specialization,
    required this.phone,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'],
      fullName: map['full_name'],
      specialization: map['specialization'],
      phone: map['phone'],
    );
  }
}
