// import 'package:fpdart/fpdart.dart';
// import 'package:health_fixed/core/failure/failure.dart';
import 'package:health_fixed/core/providers/supabase_client.dart';
import 'package:health_fixed/features/appointments/model/appointment_model.dart';
// import 'package:health_fixed/features/appointments/model/appointment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointments_repo.g.dart';

@riverpod
AppointmentsRepo appointmentsRepo(AppointmentsRepoRef ref) {
  return AppointmentsRepo();
}

class AppointmentsRepo {
  Future<AppointmentModel> createAppointment({
    required String doctorId,
    required String patientId,
    required DateTime scheduledAt,
  }) async {
    try {
      final response =
          await supabaseClient
              .from('appointments')
              .insert({
                'doctor_id': doctorId,
                'patient_id': patientId,
                'scheduled_at': scheduledAt.toIso8601String(),
              })
              .select()
              .single();

      return AppointmentModel.fromMap(response);
    } catch (e) {
      rethrow;
    }
  }

  Future getDoctorBySpec(String specialization) async {
    try {
      final response = await supabaseClient
          .from('doctors')
          .select('*')
          .eq('specialization', specialization);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppointmentModel>> fetchAppointments(String userId) async {
    try {
      final response = await supabaseClient
          .from('appointments')
          .select('*, doctors (full_name, specialization)')
          .eq('patient_id', userId)
          .order('scheduled_at', ascending: false);

      print('App: $response');

      return (response as List)
          .map((json) => AppointmentModel.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
