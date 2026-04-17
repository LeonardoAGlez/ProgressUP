import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';
import '../../../shared/widgets/neon_button.dart';

// Mock exercises
const _exercises = [
  {'name': 'Press de Banca', 'targetSets': 4, 'targetReps': 10, 'weight': '80kg'},
  {'name': 'Press Militar', 'targetSets': 3, 'targetReps': 12, 'weight': '50kg'},
  {'name': 'Fondos de Tríceps', 'targetSets': 3, 'targetReps': 0, 'weight': 'BW'},
  {'name': 'Curl de Bíceps', 'targetSets': 3, 'targetReps': 12, 'weight': '20kg'},
  {'name': 'Jalón al Pecho', 'targetSets': 4, 'targetReps': 10, 'weight': '70kg'},
];

class WorkoutTrackerScreen extends ConsumerStatefulWidget {
  const WorkoutTrackerScreen({super.key});

  @override
  ConsumerState<WorkoutTrackerScreen> createState() =>
      _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends ConsumerState<WorkoutTrackerScreen>
    with SingleTickerProviderStateMixin {
  final Map<int, List<Map<String, dynamic>>> _completedSets = {};
  bool _workoutStarted = false;
  late final AnimationController _timerCtrl;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _timerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(hours: 24),
    );
  }

  @override
  void dispose() {
    _timerCtrl.dispose();
    super.dispose();
  }

  void _startWorkout() {
    setState(() => _workoutStarted = true);
    _runTimer();
  }

  void _runTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _workoutStarted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              if (_workoutStarted) _buildTimer(),
              _buildProgressIndicator(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _exercises.length,
                  itemBuilder: (context, i) => _buildExerciseCard(i),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
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
              const Text(
                'Push Day 💥',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          NeonCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              '$_totalSetsCompleted/$_totalSetsTarget Series',
              style: const TextStyle(
                color: AppColors.neonCyan,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: NeonCard(
        borderColor: AppColors.neonCyan.withOpacity(0.3),
        glowColor: AppColors.neonCyan.withOpacity(0.15),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer_outlined, color: AppColors.neonCyan, size: 20),
            const SizedBox(width: 10),
            Text(
              _timerString,
              style: const TextStyle(
                color: AppColors.neonCyan,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
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
                // Sets done chips
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
                if (!isDone && _workoutStarted)
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

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: _workoutStarted
          ? _progress >= 1.0
              ? NeonButton(
                  label: '🎉 FINALIZAR ENTRENAMIENTO',
                  onPressed: _finishWorkout,
                  color: AppColors.success,
                )
              : NeonButton(
                  label: 'PAUSAR',
                  onPressed: () =>
                      setState(() => _workoutStarted = false),
                  isOutlined: true,
                )
          : NeonButton(
              label: '⚡ INICIAR ENTRENAMIENTO',
              onPressed: _startWorkout,
            ),
    );
  }

  void _finishWorkout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¡Workout Completo! 🎉',
          style: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '+150 XP ganados',
              style: TextStyle(
                color: AppColors.neonGold,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tiempo: $_timerString',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CERRAR',
              style: TextStyle(color: AppColors.neonPink),
            ),
          ),
        ],
      ),
    );
  }
}
