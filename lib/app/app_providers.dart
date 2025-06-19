import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final authStateProvider = StreamProvider((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange.map((event) => event.session);
});

final isLoggedInProvider = Provider<bool>((ref) {
  final session = ref.watch(authStateProvider).value;
  return session?.user != null;
});
