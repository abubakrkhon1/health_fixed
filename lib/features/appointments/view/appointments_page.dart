import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_fixed/core/providers/supabase_client.dart';
import 'package:health_fixed/core/widgets/appointment_card.dart';
import 'package:health_fixed/features/appointments/viewmodel/appointments_viewmodel.dart';
import 'package:intl/intl.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key, this.title});

  final String? title;

  @override
  ConsumerState<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<AppointmentsPage> {
  bool showUpcoming = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId != null) {
        ref
            .read(appointmentsViewmodelProvider.notifier)
            .fetchAppointments(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fetchedAppointments = ref.watch(appointmentsViewmodelProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Appointments')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => showUpcoming = true),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  showUpcoming
                                      ? Colors.white
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Text(
                              'Upcoming',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    showUpcoming ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => showUpcoming = false),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  !showUpcoming
                                      ? Colors.white
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Text(
                              'Past',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    !showUpcoming ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                fetchedAppointments.when(
                  data: (appointments) {
                    if (appointments.isEmpty) {
                      return Text('No appointments found');
                    }

                    final now = DateTime.now();
                    final upcoming =
                        appointments
                            .where(
                              (a) =>
                                  DateTime.parse(a.scheduled_at).isAfter(now),
                            )
                            .toList();
                    final past =
                        appointments
                            .where(
                              (a) =>
                                  DateTime.parse(a.scheduled_at).isBefore(now),
                            )
                            .toList();

                    final displayedAppointments =
                        showUpcoming ? upcoming : past;

                    if (displayedAppointments.isEmpty) {
                      return Text(
                        showUpcoming
                            ? 'No upcoming appointments'
                            : 'No past appointments',
                      );
                    }

                    return Column(
                      children:
                          displayedAppointments.map((appointment) {
                            final dateTime = DateTime.parse(
                              appointment.scheduled_at,
                            );

                            final formattedDate = DateFormat(
                              'dd MMMM yyyy',
                            ).format(dateTime);
                            final formattedTime = DateFormat(
                              'HH:mm',
                            ).format(dateTime);

                            return appointmentCard(
                              context: context,
                              appointmentType: appointment.status,
                              date: formattedDate,
                              time: formattedTime,
                              doctor: appointment.doctor_name ?? 'Unknown',
                              doctorType: appointment.doctor_spec ?? 'General',
                            );
                          }).toList(),
                    );
                  },
                  error: (error, st) => Text('$error'),
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
