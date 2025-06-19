class AppointmentModel {
  final String id;
  final String doctor_id;
  final String user_id;
  final String scheduled_at;
  final String status;
  final String notes;
  final String? doctor_name;
  final String? doctor_spec;

  AppointmentModel({
    required this.id,
    required this.doctor_id,
    required this.user_id,
    required this.scheduled_at,
    required this.status,
    required this.notes,
    this.doctor_name,
    this.doctor_spec,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as String,
      doctor_id: map['doctor_id'] as String,
      user_id: map['patient_id'] as String,
      scheduled_at: map['scheduled_at'] as String,
      status: map['status'] as String,
      notes: map['notes']?.toString() ?? '',
      doctor_name: map['doctors']?['full_name'], // <- safe access
      doctor_spec: map['doctors']?['specialization'],
    );
  }
}
