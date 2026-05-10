import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

final workoutServiceProvider = Provider((ref) => WorkoutService());

class WorkoutService {
  final SupabaseClient _client = Supabase.instance.client;

  int _calculateLevel(int xp) {
    int lvl = 1;
    while (xp >= (100 * math.pow(lvl + 1, 1.5)).toInt()) {
      lvl++;
    }
    return lvl;
  }

  String _calculateRank(int level) {
    if (level < 6) return 'Novato';
    if (level < 11) return 'Constante';
    if (level < 21) return 'Atleta';
    if (level < 36) return 'Competidor';
    if (level < 50) return 'Elite';
    return 'Leyenda';
  }

  /// Guarda el entrenamiento con el detalle de ejercicios completados.
  /// [ejerciciosCompletados] es una lista de mapas con:
  ///   - 'name': nombre del ejercicio
  ///   - 'seriesCompletadas': int
  ///   - 'seriesTarget': int
  ///   - 'weight': String
  ///   - 'reps': int
  Future<int> saveWorkout({
    required int durationSeconds,
    required int volume,
    required String title,
    required List<Map<String, dynamic>> ejerciciosCompletados,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return 0;

    // Calcular XP
    int xpEarned = 50; // Base XP

    if (durationSeconds > 75 * 60) {
      xpEarned += 30;
    } else if (durationSeconds > 45 * 60) {
      xpEarned += 20;
    }

    int volumeXp = (volume ~/ 1000) * 10;
    if (volumeXp > 200) volumeXp = 200;
    xpEarned += volumeXp;

    // 1. Insertar workout con ejercicios completados
    await _client.from('workouts').insert({
      'user_id': userId,
      'duracion': durationSeconds,
      'puntos_generados': xpEarned,
      'title': title,
      'ejercicios_completados': ejerciciosCompletados,
    });

    // 2. Actualizar puntos y streak del usuario
    final userRes = await _client
        .from('users')
        .select('puntos_semana, xp_total, streak, nivel')
        .eq('id', userId)
        .maybeSingle();

    if (userRes != null) {
      final currentXP = userRes['xp_total'] as int? ?? 0;
      final currentPuntos = userRes['puntos_semana'] as int? ?? 0;
      final currentStreak = userRes['streak'] as int? ?? 0;

      final newStreak = currentStreak + 1;
      final newTotalXP = currentXP + xpEarned;
      final newLevel = _calculateLevel(newTotalXP);
      final newRank = _calculateRank(newLevel);

      await _client.from('users').update({
        'xp_total': newTotalXP,
        'puntos_semana': currentPuntos + xpEarned,
        'streak': newStreak,
        'nivel': newLevel,
        'rango': newRank,
      }).eq('id', userId);

      await _client.from('xp_logs').insert({
        'user_id': userId,
        'tipo': 'workout_base',
        'xp': xpEarned,
        'metadata': {'duration': durationSeconds, 'volume': volume, 'title': title},
      });
    }

    return xpEarned;
  }
}
