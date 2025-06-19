import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserProfile?>((ref) => null);

class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String gender;
  final String dob;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.gender,
    required this.dob,
  });
}
