import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';
import '../../../shared/widgets/xp_progress_bar.dart';

import '../../../shared/providers/user_provider.dart';
import '../../../shared/models/models.dart';

// ── Mock Data (replaced by Supabase later) ──────────────────────────
const _mockWorkout = {
  'title': 'Push Day 💥',
  'date': 'Hoy • 22 Oct',
  'exercises': [
    {'name': 'Press de Banca', 'sets': '4 Series × 10 Reps'},
    {'name': 'Press Militar', 'sets': '3 Series × 12 Reps'},
    {'name': 'Fondos de Tríceps', 'sets': '3 Series al fallo'},
  ],
};

// ─────────────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: userAsync.when(
            data: (user) {
              if (user == null || user.pesoKg == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) context.go('/onboarding');
                });
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.neonPink),
                );
              }
              return CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(child: _buildHeader(context, user)),
                  // XP Card
                  SliverToBoxAdapter(child: _buildXPCard(user)),
                  // Stats Row
                  SliverToBoxAdapter(child: _buildStatsRow(user)),
                  // Today's Workout
                  SliverToBoxAdapter(child: _buildTodayWorkout(context)),
                  // Quick Actions
                  SliverToBoxAdapter(child: _buildQuickActions(context)),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.neonPink)),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.neonPink, Color(0xFF4A0080)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonPink.withOpacity(0.4),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ).animate().fadeIn(duration: 400.ms).scale(),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, ${user.fullName?.split(' ')[0] ?? 'Atleta'} 💪',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
                Text(
                  'Nivel ${user.nivel} • ${user.rango}',
                  style: const TextStyle(
                    color: AppColors.neonPink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().fadeIn(delay: 150.ms),
              ],
            ),
          ),

          // Notifications + PRO badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textSecondary),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.neonPink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonPink.withOpacity(0.6),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildXPCard(UserModel user) {
    // Calculate next level required XP
    final maxXP = (100 * math.pow(user.nivel + 1, 1.5)).toInt();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: NeonPrimaryCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'XP ACTUAL',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${user.xpTotal} XP',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            // XP Bar (white version)
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                LayoutBuilder(builder: (ctx, c) {
                  final p = user.xpTotal / maxXP;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 1400),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: c.maxWidth * p.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Siguiente nivel: $maxXP XP',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildStatsRow(UserModel user) {
    final stats = [
      {
        'icon': Icons.fitness_center_rounded,
        'value': '${user.diasSemana?.split(' ')[0] ?? '3'} / sem',
        'label': 'Entrenamientos',
        'color': AppColors.neonCyan,
      },
      {
        'icon': Icons.local_fire_department_rounded,
        'value': '${user.streak} d',
        'label': 'Racha Actual',
        'color': AppColors.neonPink,
      },
      {
        'icon': Icons.workspace_premium_rounded,
        'value': user.subscriptionTier,
        'label': 'Plan',
        'color': AppColors.neonGold,
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: stats.asMap().entries.map((e) {
          final stat = e.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: e.key == 0 ? 0 : 6,
                right: e.key == 2 ? 0 : 6,
              ),
              child: NeonCard(
                padding: const EdgeInsets.all(14),
                borderColor: (stat['color'] as Color).withOpacity(0.2),
                glowColor: (stat['color'] as Color).withOpacity(0.1),
                child: Column(
                  children: [
                    Icon(stat['icon'] as IconData,
                        color: stat['color'] as Color, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      stat['value'] as String,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      stat['label'] as String,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    )
        .animate()
        .fadeIn(delay: 350.ms, duration: 500.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildTodayWorkout(BuildContext context) {
    final exercises = _mockWorkout['exercises'] as List;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Entrenamiento de Hoy',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _mockWorkout['date'] as String,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 450.ms),

          const SizedBox(height: 12),

          NeonCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _mockWorkout['title'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                ...exercises.asMap().entries.map((e) {
                  final ex = e.value as Map<String, String>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.neonPink,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonPink.withOpacity(0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ex['name']!,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          ex['sets']!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: 500 + e.key * 100),
                        )
                        .slideX(begin: 0.05, end: 0),
                  );
                }),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/workout'),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('INICIAR ENTRENAMIENTO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 500.ms)
              .slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acciones Rápidas',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 700.ms),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickAction(
                icon: Icons.leaderboard_rounded,
                label: 'Rankings',
                color: AppColors.neonGold,
                onTap: () => context.go('/leaderboard'),
                delay: 750,
              ),
              const SizedBox(width: 12),
              _QuickAction(
                icon: Icons.workspace_premium_rounded,
                label: 'PRO',
                color: AppColors.neonCyan,
                onTap: () => context.go('/subscription'),
                delay: 850,
              ),
              const SizedBox(width: 12),
              _QuickAction(
                icon: Icons.people_rounded,
                label: 'Social',
                color: AppColors.neonPurple,
                onTap: () => context.go('/social'),
                delay: 950,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: NeonCard(
          padding: const EdgeInsets.all(16),
          borderColor: color.withOpacity(0.3),
          glowColor: color.withOpacity(0.1),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms)
          .scale(begin: const Offset(0.9, 0.9)),
    );
  }
}
