import 'package:go_router/go_router.dart';
import 'package:health_fixed/features/appointments/view/appointments_page.dart';
import 'package:health_fixed/features/auth/view/signup_screen.dart';
import 'package:health_fixed/features/main_nav/view/main_nav_page.dart';
import 'package:health_fixed/features/medication/view/medication_page.dart';
import 'package:health_fixed/features/onboarding_screen/view/onboarding_screen.dart';
import 'package:health_fixed/features/profile/view/insurance_page.dart';
import 'package:health_fixed/features/profile/view/profile_settings_page.dart';
import 'package:health_fixed/features/profile/view/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

import '../features/auth/view/login_screen.dart';

// Create a stream that notifies when auth state changes
Stream<bool> get authStateStream => Supabase
    .instance
    .client
    .auth
    .onAuthStateChange
    .map((data) => data.session != null);

final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,

  // Add refreshListenable to listen to auth changes
  refreshListenable: AuthNotifier(),

  redirect: (context, state) {
    // Get current session
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;

    // Define routes that don't require auth
    final publicRoutes = ['/onboarding', '/login', '/sign_up'];
    final isPublicRoute = publicRoutes.contains(state.fullPath);

    print(
      'Redirect check - isLoggedIn: $isLoggedIn, currentPath: ${state.fullPath}',
    );

    // If not logged in and trying to access protected route
    if (!isLoggedIn && !isPublicRoute) {
      print('Redirecting to onboarding - not logged in');
      return '/onboarding';
    }

    // If logged in and on public routes, redirect to main app
    if (isLoggedIn && isPublicRoute) {
      print('Redirecting to main app - already logged in');
      return '/';
    }

    return null;
  },

  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainNavigationPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/main_nav',
      builder: (context, state) => const MainNavigationPage(),
    ),
    GoRoute(
      path: '/profile/settings',
      builder: (context, state) => const ProfileSettingsPage(),
    ),
    GoRoute(
      path: '/profile/insurance',
      builder: (context, state) => const InsurancePage(),
    ),
    GoRoute(
      path: '/profile/medical-records',
      builder: (context, state) => const MedicationPage(),
    ),
    GoRoute(
      path: '/appointments',
      builder: (context, state) => const AppointmentsPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

// Create a custom notifier that listens to Supabase auth changes
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    // Listen to auth state changes and notify GoRouter
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      print('Auth state changed: ${data.session != null}');
      notifyListeners(); // This triggers GoRouter to re-evaluate routes
    });
  }
}

// Alternative approach using a provider (if you prefer this method)
class AuthChangeNotifier extends ChangeNotifier {
  static final _instance = AuthChangeNotifier._internal();
  factory AuthChangeNotifier() => _instance;
  AuthChangeNotifier._internal() {
    _init();
  }

  void _init() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
}
