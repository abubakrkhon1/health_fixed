import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_fixed/features/auth/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userProvider = StateProvider<User?>(
  (ref) => Supabase.instance.client.auth.currentUser,
);

final userModelProvider = FutureProvider<UserModel?>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) return null;

  final data =
      await Supabase.instance.client
          .from('clients')
          .select()
          .eq('id', user.id)
          .maybeSingle();

  if (data != null) {
    return UserModel.fromMap(data);
  }
  return null;
});
