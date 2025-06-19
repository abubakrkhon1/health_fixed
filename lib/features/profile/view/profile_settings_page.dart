import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_fixed/core/providers/providers.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userModelProvider);
    return asyncUser.when(
      data:
          (user) => Scaffold(
            appBar: AppBar(
              title: Text('Profile Settings'),
              backgroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user?.id ?? 'ID'),
                  Text(user?.fullName ?? 'No name'),
                  Text(user?.email ?? 'Email'),
                  Text(user?.gender ?? 'Gender'),
                  Text(user?.dob ?? 'DOB'),
                  Text(user?.phone ?? 'Phone'),
                ],
              ),
            ),
          ),
      error: (e, _) => Text('$e'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
