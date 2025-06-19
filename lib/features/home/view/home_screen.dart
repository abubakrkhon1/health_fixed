import 'dart:io' show Platform;
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:health_fixed/core/providers/providers.dart';
import 'package:health_fixed/core/providers/supabase_client.dart';
import 'package:health_fixed/features/appointments/viewmodel/appointments_viewmodel.dart';
import 'package:health_fixed/features/profile/view/profile_settings_page.dart';
import 'package:health_fixed/core/widgets/appointment_card.dart';
import 'package:health_fixed/core/widgets/bottom_nav_provider.dart';
import 'package:intl/intl.dart';

import 'package:lucide_icons/lucide_icons.dart';

import 'package:health_fixed/features/notifications/view/notifications_page.dart';
import 'package:health_fixed/core/theme/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color.fromARGB(255, 110, 185, 255)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context, ref),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            top: 20.0,
                          ),
                          child: _dividerText(
                            context: context,
                            text: 'Quick Services',
                          ),
                        ),
                        _buildQuickServices(context, ref),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _dividerText(
                                context: context,
                                text: 'My Appointments',
                              ),
                              TextButton(
                                onPressed: () => context.push('/appointments'),
                                child: Text(
                                  'View all',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              fetchedAppointments.when(
                                data: (appointments) {
                                  if (appointments.isEmpty) {
                                    return Text('No appointments found');
                                  }
                                  final now = DateTime.now();
                                  final upcoming =
                                      appointments
                                          .where(
                                            (a) => DateTime.parse(
                                              a.scheduled_at,
                                            ).isAfter(now),
                                          )
                                          .toList();
                                  return Column(
                                    children:
                                        upcoming.map((appointment) {
                                          final dateTime = DateTime.parse(
                                            appointment.scheduled_at,
                                          );

                                          final formattedDate = DateFormat(
                                            'dd MMMM yyyy',
                                          ).format(dateTime); // 2025-06-19
                                          final formattedTime = DateFormat(
                                            'HH:mm',
                                          ).format(dateTime);
                                          print(dateTime);
                                          return appointmentCard(
                                            context: context,
                                            appointmentType: appointment.status,
                                            date: formattedDate,
                                            time: formattedTime,
                                            doctor: appointment.doctor_name!,
                                            doctorType:
                                                appointment.doctor_spec!,
                                          );
                                        }).toList(),
                                  );
                                },
                                error: (err, st) => Text(err.toString()),
                                loading:
                                    () => const CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickServices(BuildContext context, WidgetRef ref) {
    final services = [
      {
        'label': 'Consultation',
        'asset': 'assets/images/doctor-app.png',
        'index': 2,
      },
      {
        'label': 'Medicines',
        'asset': 'assets/images/medicines.png',
        'index': 1,
      },
      {
        'label': 'Ambulance',
        'asset': 'assets/images/ambulance.png',
        'index': 0,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            services.map((service) {
              return GestureDetector(
                onTap: () {
                  ref.read(bottomNavProvider.notifier).state =
                      service['index'] as int;
                },
                child: _quickServiceCard(
                  context: context,
                  label: service['label'] as String,
                  assetPath: service['asset'] as String,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _quickServiceCard({
    context,
    required String label,
    required String assetPath,
  }) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Image.asset(assetPath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userModelProvider);
    return asyncUser.when(
      data:
          (user) => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push('/profile/settings');
                          },
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                              'assets/images/user.png',
                            ),
                          ),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Platform.isIOS
                                  ? CupertinoColors.systemGrey6
                                  : Colors.white,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            shadowColor: MaterialStateProperty.all(
                              Colors.black,
                            ),
                            elevation: MaterialStateProperty.all(5),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationsPage(),
                              ),
                            );
                          },
                          icon: Icon(LucideIcons.bell),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome!',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium?.copyWith(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                user?.fullName ?? 'User',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Have a nice day',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                              SizedBox(height: 22),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  LucideIcons.siren,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Urgent care',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 14,
                                  ),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset('assets/images/doctor.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
      loading:
          () => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileSettingsPage(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                              'assets/images/user.png',
                            ),
                          ),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Platform.isIOS
                                  ? CupertinoColors.systemGrey6
                                  : Colors.white,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            shadowColor: MaterialStateProperty.all(
                              Colors.black,
                            ),
                            elevation: MaterialStateProperty.all(5),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationsPage(),
                              ),
                            );
                          },
                          icon: Icon(LucideIcons.bell),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome!',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium?.copyWith(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                width: 160, // approximate width of name text
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              SizedBox(height: 6),
                              Text(
                                'Have a nice day',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                              SizedBox(height: 22),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  LucideIcons.siren,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Urgent care',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 14,
                                  ),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset('assets/images/doctor.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
      error: (e, _) => Text('Error: $e'),
    );
  }

  Widget _dividerText({required BuildContext context, required String text}) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
