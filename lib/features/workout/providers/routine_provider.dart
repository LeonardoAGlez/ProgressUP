import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/user_provider.dart';
import '../services/routine_generator.dart';

/// Provider que genera la rutina semanal basada en el perfil del usuario.
/// Se re-calcula automáticamente si los datos del usuario cambian.
final generatedRoutineProvider = Provider<AsyncValue<GeneratedRoutine>>((ref) {
  final userAsync = ref.watch(userProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return const AsyncValue.data(GeneratedRoutine(splitName: 'Sin usuario', days: []));
      return AsyncValue.data(RoutineGenerator.generate(user));
    },
    loading: () => const AsyncLoading(),
    error: (e, s) => AsyncError(e, s),
  );
});

/// Provider del día seleccionado para entrenar (índice).
final selectedDayIndexProvider = StateProvider<int>((ref) => 0);
