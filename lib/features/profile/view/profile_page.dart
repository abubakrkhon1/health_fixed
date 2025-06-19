import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:health_fixed/core/providers/providers.dart';
import 'package:health_fixed/core/providers/supabase_client.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:health_fixed/core/theme/app_colors.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userModelProvider);

    Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) async {
      final result = await showDialog<bool>(
        context: context,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(
                        dialogContext,
                      ).pop(false), // Return false for cancel
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.of(
                        dialogContext,
                      ).pop(true), // Return true for logout
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Logout'),
                ),
              ],
            ),
      );

      if (result == true) {
        try {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (loadingContext) =>
                    const Center(child: CircularProgressIndicator()),
          );

          // Logout from Supabase
          await supabaseClient.auth.signOut();

          // Clear user data from Riverpod state
          ref.invalidate(userModelProvider);

          // Hide loading dialog
          if (context.mounted) {
            context.pop(); // Use GoRouter to close loading dialog
          }

          // Navigate to onboarding screen using GoRouter
          if (context.mounted) {
            context.go('/onboarding');
          }
        } catch (error) {
          // Hide loading dialog if shown
          if (context.mounted) {
            context.pop(); // Use GoRouter to close loading dialog
          }

          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: ${error.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.bell),
            onPressed: () {
              // Use GoRouter for navigation
              context.push(
                '/notifications',
              ); // Make sure this route exists in your GoRouter config
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.push('/profile/settings'), // Use GoRouter
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: user.when(
                          data: (user) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullName ?? 'User',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? 'email@mail.com',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.phone ?? '+123-456-78-90',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          },
                          error:
                              (err, _) => const Text(
                                'Error occurred',
                                style: TextStyle(color: Colors.white),
                              ),
                          loading:
                              () => const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'General',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Setting Items
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SettingItem(
                      icon: LucideIcons.user,
                      color: Colors.lightBlue,
                      title: 'Account Information',
                      subtitle: 'Change your account information',
                      onTap:
                          () =>
                              context.push('/profile/settings'), // Use GoRouter
                    ),
                    SettingItem(
                      icon: LucideIcons.heartPulse,
                      color: Colors.green,
                      title: 'Insurance Detail',
                      subtitle: 'Add your insurance info',
                      onTap:
                          () => context.push(
                            '/profile/insurance',
                          ), // Use GoRouter
                    ),
                    SettingItem(
                      icon: LucideIcons.fileText,
                      color: Colors.orange,
                      title: 'Medical Records',
                      subtitle: 'History about your medical records',
                      onTap:
                          () => context.push(
                            '/profile/medical-records',
                          ), // Use GoRouter
                    ),
                    SettingItem(
                      icon: LucideIcons.shieldCheck,
                      color: Colors.purple,
                      title: 'Clinic Info',
                      subtitle: 'Information about our Clinic',
                      onTap:
                          () => context.push('/appointments'), // Use GoRouter
                    ),
                    SettingItem(
                      icon: LucideIcons.settings,
                      color: Colors.blue,
                      title: 'Settings',
                      subtitle: 'Manage & Settings',
                      onTap: () => context.push('/settings'), // Use GoRouter
                    ),
                    SettingItem(
                      icon: LucideIcons.logOut,
                      color: Colors.redAccent,
                      title: 'Logout',
                      subtitle: 'Log out from your account',
                      onTap: () => showLogoutDialog(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const SettingItem({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: color),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
