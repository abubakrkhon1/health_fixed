// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<void> signIn(String email, String password, WidgetRef ref) async {
    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;

      if (user == null) {
        throw Exception('Signup failed: No user returned.');
      }

      final profile =
          await _supabase
              .from('clients')
              .select('*')
              .eq('id', user.id)
              .single();
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Something went wrong: ${e.toString()}');
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    String number,
    String dob,
    String gender,
  ) async {
    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user;

      if (user == null) {
        throw Exception('Signup failed: No user returned.');
      }

      await _supabase.from('clients').insert({
        'id': user.id,
        'email': email,
        'full_name': name,
        'phone': number,
        'dob': dob,
        'gender': gender,
      });
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Something went wrong: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      print('Signed out');
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  getCurrentUser() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user;
  }
}
