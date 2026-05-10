import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';
import '../../../shared/widgets/xp_progress_bar.dart';

import '../../../shared/providers/user_provider.dart';
import '../../workout/providers/workout_provider.dart';
import '../../../shared/models/models.dart';
import 'package:intl/intl.dart';

const _achievements = [
  {'icon': '🔥', 'name': 'Semana Perfecta', 'desc': '7 días seguidos', 'unlocked': true},
  {'icon': '💪', 'name': 'Power Lifter', 'desc': '100kg en press', 'unlocked': true},
  {'icon': '⚡', 'name': 'Speed Demon', 'desc': 'Completar en <30min', 'unlocked': true},
  {'icon': '🏆', 'name': 'Top 10 Global', 'desc': 'Alcanzar top 10', 'unlocked': false},
  {'icon': '💎', 'name': 'Elite Status', 'desc': '10.000 XP total', 'unlocked': false},
  {'icon': '🌟', 'name': 'Legendary', 'desc': '365 días streak', 'unlocked': false},
];

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final workoutsAsync = ref.watch(recentWorkoutsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: userAsync.when(
            data: (user) {
              if (user == null || user.pesoKg == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) context.go('/onboarding');
                });
                return const Center(child: CircularProgressIndicator(color: AppColors.neonPink));
              }
              final workouts = workoutsAsync.asData?.value ?? [];

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildProfileHeader(context, user)),
                  SliverToBoxAdapter(child: _buildXPSection(user)),
                  SliverToBoxAdapter(child: _buildStatsSection(user)),
                  SliverToBoxAdapter(child: _buildAchievements()),
                  SliverToBoxAdapter(child: _buildWorkoutHistory(context, workouts)),
                  SliverToBoxAdapter(child: _buildActions(context)),
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

  Widget _buildProfileHeader(BuildContext ctx, UserModel user) {
    final maxXP = ((user.puntosSemana ~/ 1000) + 1) * 1000;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          // Avatar with neon ring
          XPProgressRing(
            currentXP: user.puntosSemana,
            maxXP: maxXP,
            size: 100,
            strokeWidth: 4,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.neonPink, Color(0xFF1A004A)],
                ),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 42),
            ),
          ).animate().fadeIn(duration: 500.ms).scale(),

          const SizedBox(height: 14),

          Text(
            user.fullName ?? 'Atleta',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ).animate().fadeIn(delay: 100.ms),

          Text(
            Supabase.instance.client.auth.currentUser?.email ?? '',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 8),

          // Rank badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.neonPink.withOpacity(0.2),
                  AppColors.neonCyan.withOpacity(0.2)
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.neonPink.withOpacity(0.3),
              ),
            ),
            child: Text(
              'Nivel ${user.nivel} • ${user.rango}',
              style: const TextStyle(
                color: AppColors.neonPink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).scale(),

          const SizedBox(height: 16),

          // PRO upgrade button
          if (!user.isPro)
            GestureDetector(
              onTap: () => ctx.go('/subscription'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.neonGold, AppColors.neonPink],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGold.withOpacity(0.3),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '⭐ Obtener NEON PULSE PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildXPSection(UserModel user) {
    final maxXP = (100 * math.pow(user.nivel + 1, 1.5)).toInt();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: NeonCard(
        padding: const EdgeInsets.all(18),
        child: XPProgressBar(
          currentXP: user.xpTotal,
          maxXP: maxXP,
          level: 'Nivel ${user.nivel}',
          nextLevel: 'Nivel ${user.nivel + 1}',
        ),
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 500.ms);
  }

  Widget _buildStatsSection(UserModel user) {
    final stats = [
      {'label': 'Días/Semana', 'value': user.diasSemana?.split(' ')[0] ?? '-', 'icon': Icons.fitness_center_rounded},
      {'label': 'Racha', 'value': '${user.streak}d', 'icon': Icons.local_fire_department_rounded},
      {'label': 'Plan', 'value': user.subscriptionTier, 'icon': Icons.star_rounded},
      {'label': 'XP Total', 'value': '${user.xpTotal}', 'icon': Icons.bolt_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: stats.asMap().entries.map((e) {
          final s = e.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: e.key == 0 ? 0 : 5,
                right: e.key == 3 ? 0 : 5,
              ),
              child: NeonCard(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                child: Column(
                  children: [
                    Icon(s['icon'] as IconData,
                        color: AppColors.neonPink, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      s['value'] as String,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      s['label'] as String,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }

  Widget _buildAchievements() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logros',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _achievements.length,
            itemBuilder: (ctx, i) {
              final a = _achievements[i];
              final unlocked = a['unlocked'] as bool;
              return NeonCard(
                padding: const EdgeInsets.all(10),
                borderColor: unlocked
                    ? AppColors.neonGold.withOpacity(0.3)
                    : AppColors.neonPink.withOpacity(0.1),
                glowColor: unlocked ? AppColors.neonGold.withOpacity(0.1) : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      a['icon'] as String,
                      style: TextStyle(
                        fontSize: 28,
                        color: unlocked ? null : null,
                      ),
                    ),
                    if (!unlocked)
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Colors.grey, BlendMode.saturation),
                        child: const SizedBox.shrink(),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      a['name'] as String,
                      style: TextStyle(
                        color: unlocked
                            ? AppColors.textPrimary
                            : AppColors.textDisabled,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 450 + i * 60),
                    duration: 350.ms,
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutHistory(BuildContext context, List<WorkoutModel> workouts) {
    if (workouts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Text('No hay historial todavía.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historial Reciente',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/history'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.neonPink.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.neonPink.withValues(alpha: 0.3),
                        width: 1),
                  ),
                  child: const Text(
                    'VER TODO',
                    style: TextStyle(
                      color: AppColors.neonPink,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...workouts.asMap().entries.map((e) {
            final w = e.value;
            final dateStr = DateFormat('dd MMM').format(w.fecha);
            final durationStr = w.duracion != null ? '${w.duracion! ~/ 60} min' : '- min';

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: NeonCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.neonPink.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fitness_center_rounded,
                          color: AppColors.neonPink, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w.title ?? 'Workout',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '$dateStr • $durationStr',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${w.puntosGenerados} XP',
                      style: const TextStyle(
                        color: AppColors.neonGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 600 + e.key * 80),
                    duration: 400.ms,
                  ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            title: const Text('Configuración',
                style: TextStyle(color: AppColors.textPrimary)),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text('Cerrar sesión',
                style: TextStyle(color: AppColors.error)),
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ).animate().fadeIn(delay: 750.ms),
    );
  }
}
