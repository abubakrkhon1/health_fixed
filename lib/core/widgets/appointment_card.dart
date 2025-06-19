import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class appointmentCard extends StatelessWidget {
  const appointmentCard({
    super.key,
    required this.context,
    required this.appointmentType,
    required this.date,
    required this.time,
    required this.doctor,
    required this.doctorType,
  });

  final BuildContext context;
  final String appointmentType;
  final String date;
  final String time;
  final String doctor;
  final String doctorType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Appointment Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointmentType,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.calendarClock,
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 6),
                      Text(
                        date,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 14),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "• $time",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.more_vert, size: 20),
            ],
          ),
          SizedBox(height: 16),
          // Doctor Info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: Colors.green),
                      SizedBox(width: 6),
                      Text(
                        doctorType,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
