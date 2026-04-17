import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';
import '../../../shared/widgets/xp_progress_bar.dart';

const _achievements = [
  {'icon': '🔥', 'name': 'Semana Perfecta', 'desc': '7 días seguidos', 'unlocked': true},
  {'icon': '💪', 'name': 'Power Lifter', 'desc': '100kg en press', 'unlocked': true},
  {'icon': '⚡', 'name': 'Speed Demon', 'desc': 'Completar en <30min', 'unlocked': true},
  {'icon': '🏆', 'name': 'Top 10 Global', 'desc': 'Alcanzar top 10', 'unlocked': false},
  {'icon': '💎', 'name': 'Elite Status', 'desc': '10.000 XP total', 'unlocked': false},
  {'icon': '🌟', 'name': 'Legendary', 'desc': '365 días streak', 'unlocked': false},
];

const _workoutHistory = [
  {'title': 'Push Day', 'date': '22 Oct', 'xp': 150, 'duration': '52 min'},
  {'title': 'Pull Day', 'date': '20 Oct', 'xp': 120, 'duration': '45 min'},
  {'title': 'Leg Day', 'date': '18 Oct', 'xp': 200, 'duration': '65 min'},
  {'title': 'Full Body', 'date': '16 Oct', 'xp': 180, 'duration': '60 min'},
];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['full_name'] as String? ?? 'León';
    final email = user?.email ?? 'user@neonpulse.app';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildProfileHeader(context, name, email)),
              SliverToBoxAdapter(child: _buildXPSection()),
              SliverToBoxAdapter(child: _buildStatsSection()),
              SliverToBoxAdapter(child: _buildAchievements()),
              SliverToBoxAdapter(child: _buildWorkoutHistory()),
              SliverToBoxAdapter(child: _buildActions(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext ctx, String name, String email) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          // Avatar with neon ring
          XPProgressRing(
            currentXP: 2450,
            maxXP: 3000,
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
            name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ).animate().fadeIn(delay: 100.ms),

          Text(
            email,
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
            child: const Text(
              '⚡ Neon Striker',
              style: TextStyle(
                color: AppColors.neonPink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).scale(),

          const SizedBox(height: 16),

          // PRO upgrade button
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

  Widget _buildXPSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: NeonCard(
        padding: const EdgeInsets.all(18),
        child: XPProgressBar(
          currentXP: 2450,
          maxXP: 3000,
          level: 'Neon Striker',
          nextLevel: 'Cyber Warrior',
        ),
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 500.ms);
  }

  Widget _buildStatsSection() {
    final stats = [
      {'label': 'Workouts', 'value': '48', 'icon': Icons.fitness_center_rounded},
      {'label': 'Racha', 'value': '12d', 'icon': Icons.local_fire_department_rounded},
      {'label': 'Posición', 'value': '#5', 'icon': Icons.leaderboard_rounded},
      {'label': 'Logros', 'value': '3/6', 'icon': Icons.emoji_events_rounded},
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
                    ),
                    Text(
                      s['label'] as String,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
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

  Widget _buildWorkoutHistory() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historial Reciente',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._workoutHistory.asMap().entries.map((e) {
            final w = e.value;
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
                            w['title'] as String,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${w['date']} • ${w['duration']}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${w['xp']} XP',
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
