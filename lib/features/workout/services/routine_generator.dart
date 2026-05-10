import '../../../shared/models/models.dart';
import '../models/exercise_model.dart';
import '../models/exercise_library.dart';

// ─── Modelos de salida ──────────────────────────

class WorkoutDay {
  final String dayLabel;
  final String emoji;
  final List<Map<String, dynamic>> exercises;
  const WorkoutDay({required this.dayLabel, required this.emoji, required this.exercises});
}

class GeneratedRoutine {
  final String splitName;
  final List<WorkoutDay> days;
  const GeneratedRoutine({required this.splitName, required this.days});
}

// ─── Generador ──────────────────────────────────

class RoutineGenerator {
  RoutineGenerator._();

  /// Genera una rutina semanal basada en los datos del usuario.
  static GeneratedRoutine generate(UserModel user) {
    final level = _mapLevel(user);
    final goal = _mapGoal(user.objetivo);
    final freq = _mapFrequency(user.diasSemana);
    final canSquat = user.sentadilla != 'No puedo / no sé';
    final maxSkill = level == ExerciseDifficulty.principiante ? 5 : (level == ExerciseDifficulty.intermedio ? 7 : 10);

    final split = _determineSplit(freq, level);
    final dayTemplates = _getDayTemplates(split);

    final days = dayTemplates.map((tmpl) {
      final exercises = _selectExercises(
        patterns: tmpl.patterns,
        level: level,
        goal: goal,
        maxSkill: maxSkill,
        canSquat: canSquat,
        exerciseCount: _exerciseCount(level),
        setsPerExercise: _setsCount(level),
        repsRange: _repsRange(level, goal),
      );
      return WorkoutDay(dayLabel: tmpl.label, emoji: tmpl.emoji, exercises: exercises);
    }).toList();

    return GeneratedRoutine(splitName: split, days: days);
  }

  // ─── Mapeo desde datos de onboarding ──────────

  static ExerciseDifficulty _mapLevel(UserModel user) {
    final tiempo = user.tiempoEntrenando ?? '';
    final squat = user.sentadilla ?? '';

    if (tiempo == 'Menos de 3 meses') return ExerciseDifficulty.principiante;
    if (tiempo == '3–12 meses' && (squat == 'No puedo / no sé' || squat == 'Menos de mi peso corporal')) {
      return ExerciseDifficulty.principiante;
    }
    if (tiempo == 'Más de 3 años' && squat == 'Más de 1.5× peso') {
      return ExerciseDifficulty.avanzado;
    }
    return ExerciseDifficulty.intermedio;
  }

  static TrainingGoal _mapGoal(String? objetivo) {
    switch (objetivo) {
      case 'Bajar peso': return TrainingGoal.bajarPeso;
      case 'Ganar músculo': return TrainingGoal.ganarMusculo;
      case 'Mejorar resistencia': return TrainingGoal.mejorarResistencia;
      case 'Competir': return TrainingGoal.competir;
      default: return TrainingGoal.mantenerme;
    }
  }

  static int _mapFrequency(String? dias) {
    switch (dias) {
      case '1–2 días': return 2;
      case '3–4 días': return 4;
      case '5 o más días': return 5;
      default: return 3;
    }
  }

  // ─── Split ────────────────────────────────────

  static String _determineSplit(int freq, ExerciseDifficulty level) {
    if (freq <= 2) return 'Full Body';
    if (freq == 3 && level == ExerciseDifficulty.principiante) return 'Full Body x3';
    if (freq == 3) return 'Upper/Lower/Full';
    if (freq == 4) return 'Upper/Lower';
    if (level == ExerciseDifficulty.avanzado) return 'PPL x2';
    return 'Push/Pull/Legs/Upper/Lower';
  }

  // ─── Plantillas de día ────────────────────────

  static List<_DayTemplate> _getDayTemplates(String split) {
    switch (split) {
      case 'Full Body':
        return [
          _DayTemplate('Full Body A', '💪', [MovementPattern.pushHorizontal, MovementPattern.pullVertical, MovementPattern.kneeHinge, MovementPattern.hipHinge, MovementPattern.core]),
          _DayTemplate('Full Body B', '🔥', [MovementPattern.pushVertical, MovementPattern.pullHorizontal, MovementPattern.kneeHinge, MovementPattern.core, MovementPattern.cardio]),
        ];
      case 'Full Body x3':
        return [
          _DayTemplate('Full Body A', '💪', [MovementPattern.pushHorizontal, MovementPattern.pullVertical, MovementPattern.kneeHinge, MovementPattern.core]),
          _DayTemplate('Full Body B', '🔥', [MovementPattern.pushVertical, MovementPattern.pullHorizontal, MovementPattern.hipHinge, MovementPattern.core]),
          _DayTemplate('Full Body C', '⚡', [MovementPattern.pushHorizontal, MovementPattern.pullVertical, MovementPattern.kneeHinge, MovementPattern.cardio]),
        ];
      case 'Upper/Lower/Full':
        return [
          _DayTemplate('Upper', '💪', [MovementPattern.pushHorizontal, MovementPattern.pushVertical, MovementPattern.pullVertical, MovementPattern.pullHorizontal]),
          _DayTemplate('Lower', '🦵', [MovementPattern.kneeHinge, MovementPattern.hipHinge, MovementPattern.core]),
          _DayTemplate('Full Body', '🔥', [MovementPattern.pushHorizontal, MovementPattern.pullVertical, MovementPattern.kneeHinge, MovementPattern.core]),
        ];
      case 'Upper/Lower':
        return [
          _DayTemplate('Upper A', '💪', [MovementPattern.pushHorizontal, MovementPattern.pushVertical, MovementPattern.pullVertical, MovementPattern.pullHorizontal]),
          _DayTemplate('Lower A', '🦵', [MovementPattern.kneeHinge, MovementPattern.hipHinge, MovementPattern.core]),
          _DayTemplate('Upper B', '🔥', [MovementPattern.pushHorizontal, MovementPattern.pullVertical, MovementPattern.pullHorizontal, MovementPattern.pushVertical]),
          _DayTemplate('Lower B', '⚡', [MovementPattern.kneeHinge, MovementPattern.hipHinge, MovementPattern.core, MovementPattern.cardio]),
        ];
      case 'PPL x2':
        return [
          _DayTemplate('Push', '💥', [MovementPattern.pushHorizontal, MovementPattern.pushVertical, MovementPattern.pushHorizontal]),
          _DayTemplate('Pull', '🏋️', [MovementPattern.pullVertical, MovementPattern.pullHorizontal, MovementPattern.pullHorizontal]),
          _DayTemplate('Legs', '🦵', [MovementPattern.kneeHinge, MovementPattern.hipHinge, MovementPattern.core]),
          _DayTemplate('Push', '💥', [MovementPattern.pushHorizontal, MovementPattern.pushVertical, MovementPattern.pushHorizontal]),
          _DayTemplate('Pull', '🏋️', [MovementPattern.pullVertical, MovementPattern.pullHorizontal, MovementPattern.pullHorizontal]),
          _DayTemplate('Legs', '🦵', [MovementPattern.kneeHinge, MovementPattern.hipHinge, MovementPattern.core]),
        ];
      default: // Push/Pull/Legs/Upper/Lower
        return [
          _DayTemplate('Push', '💥', [MovementPattern.pushHorizontal, MovementPattern.pushVertical, MovementPattern.pushHorizontal]),
          _DayTemplate('Pull', '🏋️', [MovementPattern.pullVertical, MovementPattern.pullHorizontal, MovementPattern.pullHorizontal]),
          _DayTemplate('Legs', '🦵', [MovementPattern.kneeHinge, MovementPattern.hipHinge, MovementPattern.core]),
          _DayTemplate('Upper', '💪', [MovementPattern.pushHorizontal, MovementPattern.pullVertical, MovementPattern.pushVertical, MovementPattern.pullHorizontal]),
          _DayTemplate('Lower', '🔥', [MovementPattern.kneeHinge, MovementPattern.hipHinge, MovementPattern.core, MovementPattern.cardio]),
        ];
    }
  }

  // ─── Volumen por nivel ────────────────────────

  static int _exerciseCount(ExerciseDifficulty l) => l == ExerciseDifficulty.principiante ? 5 : (l == ExerciseDifficulty.intermedio ? 6 : 7);
  static int _setsCount(ExerciseDifficulty l) => l == ExerciseDifficulty.principiante ? 3 : (l == ExerciseDifficulty.intermedio ? 4 : 4);
  static ({int min, int max}) _repsRange(ExerciseDifficulty l, TrainingGoal g) {
    if (g == TrainingGoal.bajarPeso) return (min: 12, max: 15);
    if (g == TrainingGoal.competir) return (min: 3, max: 6);
    if (l == ExerciseDifficulty.principiante) return (min: 10, max: 15);
    return (min: 8, max: 12);
  }

  // ─── Selección de ejercicios ──────────────────

  static List<Map<String, dynamic>> _selectExercises({
    required List<MovementPattern> patterns,
    required ExerciseDifficulty level,
    required TrainingGoal goal,
    required int maxSkill,
    required bool canSquat,
    required int exerciseCount,
    required int setsPerExercise,
    required ({int min, int max}) repsRange,
  }) {
    final selected = <Map<String, dynamic>>[];
    final usedIds = <String>{};

    // 1. Un ejercicio compuesto por cada patrón pedido
    for (final pattern in patterns) {
      if (selected.length >= exerciseCount) break;

      var candidates = ExerciseLibrary.query(maxLevel: level, pattern: pattern, goal: goal, maxSkill: maxSkill);

      // Regla especial: si no puede sentadilla con barra, excluirla
      if (!canSquat) {
        candidates = candidates.where((e) => e.id != 'barbell_squat').toList();
      }

      // Evitar repetidos
      candidates = candidates.where((e) => !usedIds.contains(e.id)).toList();

      if (candidates.isEmpty) {
        // Fallback: cualquier ejercicio del patrón sin filtro de goal
        candidates = ExerciseLibrary.query(maxLevel: level, pattern: pattern, maxSkill: maxSkill)
            .where((e) => !usedIds.contains(e.id) && (canSquat || e.id != 'barbell_squat'))
            .toList();
      }

      if (candidates.isNotEmpty) {
        // Preferir compuestos primero
        candidates.sort((a, b) {
          if (a.isCompound != b.isCompound) return a.isCompound ? -1 : 1;
          return a.fatigue.compareTo(b.fatigue);
        });
        final pick = candidates.first;
        usedIds.add(pick.id);
        selected.add(pick.toTrackerMap(
          targetSets: setsPerExercise,
          targetReps: repsRange.min,
        ));
      }
    }

    // 2. Rellenar con aislamiento si falta volumen
    if (selected.length < exerciseCount) {
      final isoPool = ExerciseLibrary.all
          .where((e) => !e.isCompound && e.difficulty.index <= level.index && !usedIds.contains(e.id))
          .toList()
        ..shuffle();
      for (final iso in isoPool) {
        if (selected.length >= exerciseCount) break;
        usedIds.add(iso.id);
        selected.add(iso.toTrackerMap(
          targetSets: setsPerExercise - 1,
          targetReps: repsRange.max,
        ));
      }
    }

    return selected;
  }
}

// ─── Helper interno ─────────────────────────────

class _DayTemplate {
  final String label;
  final String emoji;
  final List<MovementPattern> patterns;
  const _DayTemplate(this.label, this.emoji, this.patterns);
}
