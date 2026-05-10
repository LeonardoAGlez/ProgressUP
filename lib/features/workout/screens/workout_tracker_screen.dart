import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';
import '../../../shared/widgets/neon_button.dart';
import '../services/workout_service.dart';
import '../services/pdf_export_service.dart';
import '../../../shared/providers/user_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/routine_provider.dart';
import 'package:go_router/go_router.dart';

enum _WorkoutState { idle, running, paused }

class WorkoutTrackerScreen extends ConsumerStatefulWidget {
  const WorkoutTrackerScreen({super.key});

  @override
  ConsumerState<WorkoutTrackerScreen> createState() =>
      _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends ConsumerState<WorkoutTrackerScreen>
    with SingleTickerProviderStateMixin {
  final Map<int, List<Map<String, dynamic>>> _completedSets = {};
  _WorkoutState _state = _WorkoutState.idle;
  Duration _elapsed = Duration.zero;
  bool _isSaving = false;

  /// Ejercicios del día seleccionado (dinámicos)
  List<Map<String, dynamic>> get _exercises {
    final routineAsync = ref.read(generatedRoutineProvider);
    final dayIndex = ref.read(selectedDayIndexProvider);
    return routineAsync.when(
      data: (routine) => routine.days.isNotEmpty
          ? routine.days[dayIndex % routine.days.length].exercises
          : [],
      loading: () => [],
      error: (_, __) => [],
    );
  }

  String get _dayLabel {
    final routineAsync = ref.read(generatedRoutineProvider);
    final dayIndex = ref.read(selectedDayIndexProvider);
    return routineAsync.when(
      data: (routine) => routine.days.isNotEmpty
          ? '${routine.days[dayIndex % routine.days.length].dayLabel} ${routine.days[dayIndex % routine.days.length].emoji}'
          : 'Workout',
      loading: () => 'Cargando...',
      error: (_, __) => 'Workout',
    );
  }

  void _startWorkout() {
    setState(() => _state = _WorkoutState.running);
    _runTimer();
  }

  void _pauseWorkout() {
    setState(() => _state = _WorkoutState.paused);
  }

  void _resumeWorkout() {
    setState(() => _state = _WorkoutState.running);
    _runTimer();
  }

  void _runTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _state == _WorkoutState.running) {
        setState(() => _elapsed += const Duration(seconds: 1));
        _runTimer();
      }
    });
  }

  String get _timerString {
    final h = _elapsed.inHours;
    final m = _elapsed.inMinutes % 60;
    final s = _elapsed.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      _completedSets[exerciseIndex] ??= [];
      _completedSets[exerciseIndex]!.add({
        'reps': _exercises[exerciseIndex]['targetReps'],
        'weight': _exercises[exerciseIndex]['weight'],
        'done': true,
      });
    });
  }

  int get _totalSetsCompleted =>
      _completedSets.values.fold(0, (a, b) => a + b.length);

  int get _totalSetsTarget =>
      _exercises.fold(0, (a, b) => a + (b['targetSets'] as int));

  double get _progress =>
      _totalSetsTarget > 0 ? _totalSetsCompleted / _totalSetsTarget : 0;

  int get _totalVolume {
    int v = 0;
    for (var sets in _completedSets.values) {
      for (var s in sets) {
        final wStr = s['weight'] as String;
        final reps = s['reps'] as int;
        final w = double.tryParse(wStr.replaceAll('kg', '').trim()) ?? 0.0;
        v += (w * reps).toInt();
      }
    }
    return v;
  }

  /// Construye la lista de ejercicios para guardar en BD
  List<Map<String, dynamic>> _buildEjerciciosReport() {
    return List.generate(_exercises.length, (i) {
      final ex = _exercises[i];
      final sets = _completedSets[i] ?? [];
      return {
        'name': ex['name'],
        'seriesCompletadas': sets.length,
        'seriesTarget': ex['targetSets'],
        'weight': ex['weight'],
        'reps': ex['targetReps'],
      };
    }).where((e) => (e['seriesCompletadas'] as int) > 0).toList();
  }

  // ──────────────────────────────────────────────
  // Detener entrenamiento → mostrar diálogo confirmación
  // ──────────────────────────────────────────────
  void _confirmStop() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¿Detener entrenamiento?',
          style: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Se guardará el progreso actual y se generará un reporte.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            // Usar dialogCtx para el pop del propio diálogo
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop(); // cierra SOLO este diálogo
              _stopAndSave();               // llama inmediatamente, sin nav extra
            },
            child: const Text('Detener',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Guardar y mostrar reporte
  // ──────────────────────────────────────────────
  Future<void> _stopAndSave() async {
    // Usar estado en pantalla en lugar de un loading dialog anidado.
    // Esto evita completamente el navigator lock.
    setState(() {
      _state = _WorkoutState.paused;
      _isSaving = true;
    });

    try {
      final report = _buildEjerciciosReport();
      final xpEarned = await ref.read(workoutServiceProvider).saveWorkout(
            durationSeconds: _elapsed.inSeconds,
            volume: _totalVolume,
            title: _dayLabel,
            ejerciciosCompletados: report,
          );

      if (mounted) {
        ref.invalidate(userProvider);
        ref.invalidate(allWorkoutsProvider);
        ref.invalidate(recentWorkoutsProvider);
        // Quitar loading y mostrar reporte: sin ninguna operación de navigator previa.
        setState(() => _isSaving = false);
        _showWorkoutReport(xpEarned, report);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _showWorkoutReport(int xpEarned, List<Map<String, dynamic>> report) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // dialogCtx = contexto del propio diálogo, seguro para hacer pop
      builder: (dialogCtx) => _WorkoutReportDialog(
        timerString: _timerString,
        workoutTitle: _dayLabel,
        xpEarned: xpEarned,
        report: report,
        onClose: () {
          Navigator.of(dialogCtx).pop(); // cierra solo el diálogo
          // Delay para que la animación del pop termine antes de navegar
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted) context.go('/history');
          });
        },
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Finalizar completo (todas las series hechas)
  // ──────────────────────────────────────────────
  void _finishWorkout() => _stopAndSave();

  // ──────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isRunning = _state == _WorkoutState.running;
    final isPaused = _state == _WorkoutState.paused;
    final isIdle = _state == _WorkoutState.idle;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration:
                const BoxDecoration(gradient: AppColors.backgroundGradient),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  if (!isIdle) _buildTimer(isPaused),
                  _buildProgressIndicator(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _exercises.length,
                      itemBuilder: (context, i) => _buildExerciseCard(i),
                    ),
                  ),
                  _buildBottomBar(isRunning, isPaused, isIdle),
                ],
              ),
            ),
          ),
          // Overlay de guardado — no usa ningún dialog
          if (_isSaving)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.neonPink),
                    SizedBox(height: 16),
                    Text(
                      'Guardando entrenamiento...',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WORKOUT TRACKER',
                style: TextStyle(
                  color: AppColors.neonPink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              Text(
                _dayLabel,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          Row(
            children: [
              NeonCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Text(
                  '$_totalSetsCompleted/$_totalSetsTarget Series',
                  style: const TextStyle(
                    color: AppColors.neonCyan,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => context.push('/history'),
                child: NeonCard(
                  padding: const EdgeInsets.all(9),
                  child: const Icon(
                    Icons.history_rounded,
                    color: AppColors.neonPink,
                    size: 20,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildTimer(bool isPaused) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: NeonCard(
        borderColor: isPaused
            ? AppColors.neonGold.withOpacity(0.4)
            : AppColors.neonCyan.withOpacity(0.3),
        glowColor: isPaused
            ? AppColors.neonGold.withOpacity(0.12)
            : AppColors.neonCyan.withOpacity(0.15),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPaused ? Icons.pause_circle_outline : Icons.timer_outlined,
              color: isPaused ? AppColors.neonGold : AppColors.neonCyan,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              _timerString,
              style: TextStyle(
                color: isPaused ? AppColors.neonGold : AppColors.neonCyan,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            if (isPaused) ...[
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.neonGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PAUSADO',
                  style: TextStyle(
                    color: AppColors.neonGold,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progreso',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.neonPink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              LayoutBuilder(builder: (c, constraints) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: 6,
                  width: constraints.maxWidth * _progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      colors: [AppColors.neonPink, AppColors.neonCyan],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonPink.withOpacity(0.5),
                        blurRadius: 6,
                      )
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(int index) {
    final ex = _exercises[index];
    final completed = _completedSets[index]?.length ?? 0;
    final target = ex['targetSets'] as int;
    final isDone = completed >= target;
    final isActive = _state == _WorkoutState.running;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        padding: const EdgeInsets.all(16),
        borderColor: isDone
            ? AppColors.success.withOpacity(0.3)
            : AppColors.neonPink.withOpacity(0.15),
        glowColor: isDone
            ? AppColors.success.withOpacity(0.1)
            : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ex['name'] as String,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${ex['targetSets']} series × '
                        '${ex['targetReps'] == 0 ? 'al fallo' : '${ex['targetReps']} reps'} '
                        '• ${ex['weight']}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isDone)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '✓ LISTO',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ...List.generate(target, (s) {
                  final setDone = s < completed;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: setDone
                            ? AppColors.neonPink.withOpacity(0.3)
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: setDone
                              ? AppColors.neonPink
                              : AppColors.textDisabled,
                        ),
                        boxShadow: setDone
                            ? [
                                BoxShadow(
                                  color: AppColors.neonPink.withOpacity(0.4),
                                  blurRadius: 8,
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        setDone ? Icons.check_rounded : null,
                        color: AppColors.neonPink,
                        size: 16,
                      ),
                    ),
                  );
                }),
                const Spacer(),
                if (!isDone && isActive)
                  GestureDetector(
                    onTap: () => _addSet(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.neonPink, Color(0xFF8B00CC)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonPink.withOpacity(0.4),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: const Text(
                        '+ Serie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(
          delay: Duration(milliseconds: 100 + index * 80), duration: 400.ms),
    );
  }

  Widget _buildBottomBar(bool isRunning, bool isPaused, bool isIdle) {
    if (isIdle) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: NeonButton(
          label: '⚡ INICIAR ENTRENAMIENTO',
          onPressed: _startWorkout,
        ),
      );
    }

    if (isRunning) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: _progress >= 1.0
            ? NeonButton(
                label: '🎉 FINALIZAR ENTRENAMIENTO',
                onPressed: _finishWorkout,
                color: AppColors.success,
              )
            : NeonButton(
                label: '⏸ PAUSAR',
                onPressed: _pauseWorkout,
                isOutlined: true,
              ),
      );
    }

    // isPaused → mostrar REANUDAR y DETENER
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeonButton(
            label: '▶ REANUDAR',
            onPressed: _resumeWorkout,
            color: AppColors.neonCyan,
          ),
          const SizedBox(height: 10),
          NeonButton(
            label: '⏹ DETENER Y GUARDAR',
            onPressed: _confirmStop,
            color: AppColors.error,
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Diálogo de Reporte Final
// ──────────────────────────────────────────────
class _WorkoutReportDialog extends StatefulWidget {
  const _WorkoutReportDialog({
    required this.timerString,
    required this.workoutTitle,
    required this.xpEarned,
    required this.report,
    required this.onClose,
  });

  final String timerString;
  final String workoutTitle;
  final int xpEarned;
  final List<Map<String, dynamic>> report;
  final VoidCallback onClose;

  @override
  State<_WorkoutReportDialog> createState() => _WorkoutReportDialogState();
}

class _WorkoutReportDialogState extends State<_WorkoutReportDialog> {
  bool _exporting = false;

  Future<void> _exportPdf() async {
    setState(() => _exporting = true);
    try {
      await PdfExportService.exportWorkoutReport(
        title: widget.workoutTitle,
        timerString: widget.timerString,
        xpEarned: widget.xpEarned,
        fecha: DateTime.now(),
        ejercicios: widget.report,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppColors.neonPink.withValues(alpha: 0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPink.withValues(alpha: 0.15),
              blurRadius: 40,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonPink.withValues(alpha: 0.15),
                    AppColors.neonCyan.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const Text('🏋️ Reporte de Entrenamiento',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                          icon: Icons.timer_outlined,
                          label: 'Duración',
                          value: widget.timerString,
                          color: AppColors.neonCyan),
                      _StatChip(
                          icon: Icons.bolt,
                          label: 'XP ganados',
                          value: '+${widget.xpEarned}',
                          color: AppColors.neonGold),
                    ],
                  ),
                ],
              ),
            ),
            // Lista de ejercicios
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EJERCICIOS COMPLETADOS',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.report.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'No se completó ninguna serie.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    else
                      ...widget.report.map(
                          (e) => _ExerciseReportRow(exercise: e)),
                  ],
                ),
              ),
            ),
            // Botones
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exportar PDF
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _exporting ? null : _exportPdf,
                      icon: _exporting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.neonCyan,
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf_outlined,
                              size: 18, color: AppColors.neonCyan),
                      label: Text(
                        _exporting ? 'Exportando...' : 'EXPORTAR PDF',
                        style: const TextStyle(
                          color: AppColors.neonCyan,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.neonCyan, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Ver historial
                  NeonButton(
                    label: 'VER HISTORIAL',
                    onPressed: widget.onClose,
                    color: AppColors.neonPink,
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _ExerciseReportRow extends StatelessWidget {
  const _ExerciseReportRow({required this.exercise});
  final Map<String, dynamic> exercise;

  @override
  Widget build(BuildContext context) {
    final done = exercise['seriesCompletadas'] as int;
    final target = exercise['seriesTarget'] as int;
    final isComplete = done >= target;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isComplete
            ? AppColors.success.withOpacity(0.08)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete
              ? AppColors.success.withOpacity(0.25)
              : AppColors.neonPink.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: isComplete ? AppColors.success : AppColors.textSecondary,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              exercise['name'] as String,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$done/$target series',
            style: TextStyle(
              color: isComplete ? AppColors.success : AppColors.neonPink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
