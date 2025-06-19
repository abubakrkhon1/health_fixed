import 'package:health_fixed/core/providers/supabase_client.dart';
import 'package:health_fixed/features/appointments/model/appointment_model.dart';
import 'package:health_fixed/features/appointments/model/doctor_model.dart';
import 'package:health_fixed/features/appointments/repo/appointments_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointments_viewmodel.g.dart';

@riverpod
class AppointmentsViewmodel extends _$AppointmentsViewmodel {
  late AppointmentsRepo _appointmentsRepo;

  @override
  FutureOr<List<AppointmentModel>> build() async {
    _appointmentsRepo = ref.read(appointmentsRepoProvider);

    // Optional: fetch initial data right away
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      return await _appointmentsRepo.fetchAppointments(userId);
    }

    return [];
  }

  Future<void> createAppointment({
    required String doctorId,
    required String patientId,
    required DateTime scheduledAt,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _appointmentsRepo.createAppointment(
        doctorId: doctorId,
        patientId: patientId,
        scheduledAt: scheduledAt,
      );

      await fetchAppointments(patientId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<List<DoctorModel>> getDoctorsBySpecialization(
    String specialization,
  ) async {
    final result = await _appointmentsRepo.getDoctorBySpec(specialization);
    return (result as List)
        .map((doc) => DoctorModel.fromMap(doc as Map<String, dynamic>))
        .toList();
  }

  Future<void> fetchAppointments(String userId) async {
    try {
      state = const AsyncValue.loading();
      final appointments = await _appointmentsRepo.fetchAppointments(userId);
      state = AsyncValue.data(appointments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
