import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/models.dart';

/// Últimos 5 workouts (para dashboard)
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

/// Todos los workouts para historial completo
final allWorkoutsProvider = FutureProvider<List<WorkoutModel>>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return [];

  final response = await Supabase.instance.client
      .from('workouts')
      .select()
      .eq('user_id', user.id)
      .order('fecha', ascending: false);

  return (response as List).map((e) => WorkoutModel.fromJson(e)).toList();
});
