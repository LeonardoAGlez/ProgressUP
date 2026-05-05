import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/models.dart';

final recentWorkoutsProvider = FutureProvider<List<WorkoutModel>>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return [];

  final response = await Supabase.instance.client
      .from('workouts')
      .select()
      .eq('user_id', user.id)
      .order('fecha', ascending: false)
      .limit(5);

  return (response as List).map((e) => WorkoutModel.fromJson(e)).toList();
});
