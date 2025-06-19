import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_fixed/core/providers/supabase_client.dart';
import 'package:health_fixed/features/appointments/model/doctor_model.dart';
import 'package:health_fixed/features/appointments/viewmodel/appointments_viewmodel.dart';

class NewAppointmentPage extends ConsumerStatefulWidget {
  const NewAppointmentPage({super.key});

  @override
  ConsumerState<NewAppointmentPage> createState() => _NewAppointmentPageState();
}

class _NewAppointmentPageState extends ConsumerState<NewAppointmentPage> {
  DateTime? _selectedDate;
  String? selectedSpecialization;
  DoctorModel? selectedDoctor;
  List<DoctorModel> doctors = [];

  @override
  Widget build(BuildContext context) {
    final patientId = supabaseClient.auth.currentUser?.id;
    final vm = ref.watch(appointmentsViewmodelProvider);

    // ref.listen(appointmentsViewmodelProvider, (prev, next) {
    //   if (next is AsyncData) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Appointment created successfully')),
    //     );
    //   } else if (next is AsyncError) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Error creating appointment')),
    //     );
    //   }
    // });

    List<String> specs = ['Cardiology', 'Endocrinology', 'Ophtalmology'];

    return Scaffold(
      appBar: AppBar(title: Text('New Appointment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select your doctor\'s specialization'),
              DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select specialization'),
                value: selectedSpecialization,
                items:
                    specs
                        .map(
                          (spec) =>
                              DropdownMenuItem(value: spec, child: Text(spec)),
                        )
                        .toList(),
                onChanged: (newValue) async {
                  if (newValue == null) return;

                  final fetchedDoctors = await ref
                      .read(appointmentsViewmodelProvider.notifier)
                      .getDoctorsBySpecialization(newValue);
                  print(fetchedDoctors);

                  setState(() {
                    selectedSpecialization = newValue;
                    doctors = fetchedDoctors;
                    selectedDoctor = null;
                  });
                },
              ),
              const SizedBox(height: 12),

              const Text('Select your doctor'),
              if (selectedSpecialization != null)
                doctors.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No doctors found for this specialization',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                    : DropdownButton<DoctorModel>(
                      isExpanded: true,
                      hint: const Text('Select doctor'),
                      value: selectedDoctor,
                      items:
                          doctors
                              .map(
                                (doc) => DropdownMenuItem(
                                  value: doc,
                                  child: Text('Dr. ${doc.fullName}'),
                                ),
                              )
                              .toList(),
                      onChanged: (newValue) {
                        setState(() => selectedDoctor = newValue);
                      },
                    ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : 'Date: ${_selectedDate!.toLocal()}',
                    ),
                  ),
                  TextButton(
                    child: const Text('Pick Date'),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time == null) return;
                      setState(() {
                        _selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    vm is AsyncLoading
                        ? null
                        : () {
                          if (_selectedDate == null ||
                              selectedDoctor == null ||
                              selectedSpecialization == null ||
                              patientId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fill all fields')),
                            );
                            return;
                          }

                          ref
                              .read(appointmentsViewmodelProvider.notifier)
                              .createAppointment(
                                doctorId: selectedDoctor!.id,
                                patientId: patientId,
                                scheduledAt: _selectedDate!,
                              );
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    vm is AsyncLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          'Create Appointment',
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
