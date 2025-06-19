import 'package:flutter/material.dart';
import 'package:health_fixed/core/widgets/medicationCard.dart';

const medicationsList = [
  {
    'title': 'Metformin',
    'subtitle': 'Take 2 pills every morning',
    'type': 'medication',
  },
  {
    'title': 'Lisinopril',
    'subtitle': 'Take 1 pill every day',
    'type': 'medication',
  },
  {
    'title': 'Atorvastatin',
    'subtitle': 'Take 1 pill at bedtime',
    'type': 'medication',
  },
  {
    'title': 'Aspirin 81mg',
    'subtitle': 'Once a day at 08:00',
    'type': 'medication',
  },
];

const supplementList = [
  {
    'title': 'Metformin',
    'subtitle': 'Take 2 pills every morning',
    'type': 'supplement',
  },
  {
    'title': 'Lisinopril',
    'subtitle': 'Take 1 pill every day',
    'type': 'supplement',
  },
  {
    'title': 'Atorvastatin',
    'subtitle': 'Take 1 pill at bedtime',
    'type': 'supplement',
  },
  {
    'title': 'Aspirin 81mg',
    'subtitle': 'Once a day at 08:00',
    'type': 'supplement',
  },
  {
    'title': 'Aspirin 81mg',
    'subtitle': 'Once a day at 08:00',
    'type': 'supplement',
  },
  {
    'title': 'Aspirin 81mg',
    'subtitle': 'Once a day at 08:00',
    'type': 'supplement',
  },
  {
    'title': 'Aspirin 81mg',
    'subtitle': 'Once a day at 08:00',
    'type': 'supplement',
  },
];

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key, this.title});

  final String? title;

  @override
  State<MedicationPage> createState() => _MedicationPage();
}

class _MedicationPage extends State<MedicationPage> {
  bool showMedications = true;

  @override
  Widget build(BuildContext context) {
    final currentList = showMedications ? medicationsList : supplementList;

    return Scaffold(
      appBar: AppBar(title: Text('Medications and supplements')),
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
                          onTap: () => setState(() => showMedications = true),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  showMedications
                                      ? Colors.white
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Text(
                              'Medications',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    showMedications
                                        ? Colors.black
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => showMedications = false),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  !showMedications
                                      ? Colors.white
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Text(
                              'Supplements',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    !showMedications
                                        ? Colors.black
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Appointments List
                ...currentList.map((medication) {
                  return MedicationCard(
                    type: medication['type']!,
                    title: medication['title']!,
                    subTitle: medication['subtitle']!,
                    // context: context,
                    // appointmentType: appointment['appointmentType']!,
                    // time: appointment['time']!,
                    // doctor: appointment['doctor']!,
                    // date: appointment['date']!,
                    // doctorType: appointment['doctorType']!,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
