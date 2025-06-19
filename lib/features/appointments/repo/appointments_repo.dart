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

    if (response == null) {
      throw Exception('Failed to create appointment');
    }

    return AppointmentModel.fromMap(response);
  }

  Future getDoctorBySpec(String specialization) async {
    final response = await supabaseClient
        .from('doctors')
        .select('*')
        .eq('specialization', specialization);

    return response;
  }

  Future<List<AppointmentModel>> fetchAppointments(String userId) async {
    final response = await supabaseClient
        .from('appointments')
        .select('*, doctors (full_name, specialization)')
        .eq('patient_id', userId)
        .order('scheduled_at', ascending: false);

    print('App: $response');

    return (response as List)
        .map((json) => AppointmentModel.fromMap(json as Map<String, dynamic>))
        .toList();
  }
}
