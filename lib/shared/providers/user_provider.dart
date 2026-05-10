import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

final userProvider = FutureProvider<UserModel?>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;

  final response = await Supabase.instance.client
      .from('users')
      .select()
      .eq('id', user.id)
      .maybeSingle();

  if (response == null) return null;

  return UserModel.fromJson(response);
});
