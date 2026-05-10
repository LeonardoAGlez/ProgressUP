import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';
import '../../../shared/models/models.dart';
import '../providers/workout_provider.dart';
import '../services/pdf_export_service.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  String _formatDuration(int? seconds) {
    if (seconds == null) return '--';
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}  '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(allWorkoutsProvider);
    final workouts = workoutsAsync.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, workouts),
              Expanded(
                child: workoutsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.neonPink),
                  ),
                  error: (e, _) => Center(
                    child: Text('Error: $e',
                        style:
                            const TextStyle(color: AppColors.error)),
                  ),
                  data: (workouts) => workouts.isEmpty
                      ? _buildEmpty()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: workouts.length,
                          itemBuilder: (_, i) => _buildWorkoutCard(
                              workouts[i], i),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<WorkoutModel> workouts) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Si hay pila de Navigator (ej: vino del modal de reporte),
                  // hacer pop. Si no (vino de go_router como /profile → /history),
                  // regresar a /profile con go.
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/profile');
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary, size: 16),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'HISTORIAL',
                    style: TextStyle(
                      color: AppColors.neonPink,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'Mis Entrenamientos',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (workouts.isNotEmpty)
            _ExportMenuButton(workouts: workouts),
        ],
      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center_rounded,
              color: AppColors.textDisabled, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Aún no hay entrenamientos',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Inicia tu primer rutina 💪',
            style: TextStyle(color: AppColors.textDisabled, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutModel w, int index) {
    final hasEjercicios = w.ejerciciosCompletados.isNotEmpty;
    final totalSeries = w.ejerciciosCompletados
        .fold<int>(0, (a, e) => a + (e['seriesCompletadas'] as int? ?? 0));
    final durStr = _formatDuration(w.duracion);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: NeonCard(
        padding: const EdgeInsets.all(16),
        borderColor: AppColors.neonPink.withValues(alpha: 0.15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Título, fecha y botón PDF ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        w.title ?? 'Entrenamiento',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              color: AppColors.textSecondary, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(w.fecha),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // XP badge + PDF button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.neonGold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.neonGold.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '+${w.puntosGenerados} XP',
                        style: const TextStyle(
                          color: AppColors.neonGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PdfButton(
                      workout: w,
                      timerString: durStr,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // ── Stats row ──
            Row(
              children: [
                _MiniStat(
                  icon: Icons.timer_outlined,
                  label: durStr,
                  color: AppColors.neonCyan,
                ),
                const SizedBox(width: 16),
                _MiniStat(
                  icon: Icons.fitness_center_rounded,
                  label: '$totalSeries series',
                  color: AppColors.neonPink,
                ),
                const SizedBox(width: 16),
                _MiniStat(
                  icon: Icons.list_alt_rounded,
                  label: '${w.ejerciciosCompletados.length} ejercicios',
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            // ── Ejercicios detalle (si hay datos) ──
            if (hasEjercicios) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.surfaceElevated, height: 1),
              const SizedBox(height: 10),
              ...w.ejerciciosCompletados.map((e) => _EjercicioRow(e: e)),
            ],
          ],
        ),
      )
          .animate()
          .fadeIn(
              delay: Duration(milliseconds: 60 * index), duration: 400.ms)
          .slideY(begin: 0.06, end: 0),
    );
  }
}

// ── Botón de exportar PDF ──────────────────────────────────────────────────
class _ExportMenuButton extends StatefulWidget {
  const _ExportMenuButton({required this.workouts});
  final List<WorkoutModel> workouts;

  @override
  State<_ExportMenuButton> createState() => _ExportMenuButtonState();
}

class _ExportMenuButtonState extends State<_ExportMenuButton> {
  bool _loading = false;

  Future<void> _exportAggregated(String period) async {
    setState(() => _loading = true);
    try {
      final now = DateTime.now();
      DateTime startDate;
      if (period == 'Semanal') {
        startDate = now.subtract(Duration(days: now.weekday - 1));
      } else if (period == 'Mensual') {
        startDate = DateTime(now.year, now.month, 1);
      } else {
        startDate = DateTime(2000); // Total
      }

      final filteredWorkouts = widget.workouts
          .where((w) => w.fecha.isAfter(startDate.subtract(const Duration(days: 1))))
          .toList()
          // Ordenar de más antiguo a más reciente para el reporte, o dejarlo como está.
          // En historial están más reciente a más antiguo, tal vez en el reporte también sirva.
          ;

      if (filteredWorkouts.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No hay entrenamientos en este periodo.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      await PdfExportService.exportAggregatedReport(
        periodName: period,
        workouts: filteredWorkouts,
        startDate: startDate,
        endDate: now,
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
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 36, height: 36,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: AppColors.neonCyan, strokeWidth: 2),
        ),
      );
    }

    return PopupMenuButton<String>(
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.neonCyan.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.3)),
        ),
        child: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.neonCyan, size: 18),
      ),
      padding: EdgeInsets.zero,
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: _exportAggregated,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Semanal',
          child: Text('Reporte Semanal', style: TextStyle(color: AppColors.textPrimary)),
        ),
        const PopupMenuItem(
          value: 'Mensual',
          child: Text('Reporte Mensual', style: TextStyle(color: AppColors.textPrimary)),
        ),
        const PopupMenuItem(
          value: 'Total',
          child: Text('Reporte Total', style: TextStyle(color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}

// ── Botón de exportar PDF individual ─────────────────────────────────────────
class _PdfButton extends StatefulWidget {
  const _PdfButton({required this.workout, required this.timerString});
  final WorkoutModel workout;
  final String timerString;

  @override
  State<_PdfButton> createState() => _PdfButtonState();
}

class _PdfButtonState extends State<_PdfButton> {
  bool _loading = false;

  Future<void> _export() async {
    setState(() => _loading = true);
    try {
      await PdfExportService.exportWorkoutReport(
        title: widget.workout.title ?? 'Entrenamiento',
        timerString: widget.timerString,
        xpEarned: widget.workout.puntosGenerados ?? 0,
        fecha: widget.workout.fecha,
        ejercicios: widget.workout.ejerciciosCompletados,
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
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading ? null : _export,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.neonCyan.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: AppColors.neonCyan.withValues(alpha: 0.3), width: 1),
        ),
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.neonCyan),
              )
            : const Icon(Icons.picture_as_pdf_outlined,
                color: AppColors.neonCyan, size: 18),
      ),
    );
  }
}



class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _EjercicioRow extends StatelessWidget {
  const _EjercicioRow({required this.e});
  final Map<String, dynamic> e;

  @override
  Widget build(BuildContext context) {
    final done = e['seriesCompletadas'] as int? ?? 0;
    final target = e['seriesTarget'] as int? ?? 0;
    final complete = done >= target;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(
            complete
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: complete ? AppColors.success : AppColors.textDisabled,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              e['name'] as String? ?? '',
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '$done/$target series',
            style: TextStyle(
              color: complete ? AppColors.success : AppColors.neonPink,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
