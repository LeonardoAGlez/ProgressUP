import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';

final _rankings = [
  {'rank': 1, 'user': 'XenonLifter', 'avatar': '🔥', 'xp': 8420, 'level': 'Elite Athlete', 'change': 0},
  {'rank': 2, 'user': 'CyberAthleta_99', 'avatar': '🦾', 'xp': 7850, 'level': 'Cyber Warrior', 'change': 1},
  {'rank': 3, 'user': 'PulseMaster', 'avatar': '⚡', 'xp': 7320, 'level': 'Cyber Warrior', 'change': -1},
  {'rank': 4, 'user': 'NeonQueen_Fit', 'avatar': '💎', 'xp': 6980, 'level': 'Neon Striker', 'change': 2},
  {'rank': 5, 'user': 'León (Tú)', 'avatar': '🧬', 'xp': 2450, 'level': 'Neon Striker', 'change': 3, 'isMe': true},
  {'rank': 6, 'user': 'GridironGod', 'avatar': '🏋️', 'xp': 2180, 'level': 'Neon Striker', 'change': -2},
  {'rank': 7, 'user': 'Vortex_Train', 'avatar': '🌀', 'xp': 1950, 'level': 'Basic', 'change': 0},
  {'rank': 8, 'user': 'QuantumFit', 'avatar': '🔭', 'xp': 1720, 'level': 'Basic', 'change': 1},
];

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  int _selectedPeriod = 0;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

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
              _buildPeriodSelector(),
              _buildPodium(),
              Expanded(child: _buildRankingList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'RANKINGS',
            style: TextStyle(
              color: AppColors.neonGold,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          Text(
            'Leaderboard',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Esta semana', 'Este mes', 'Global'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: periods.asMap().entries.map((e) {
          final selected = _selectedPeriod == e.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.neonGold.withOpacity(0.15)
                      : AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? AppColors.neonGold.withOpacity(0.5)
                        : AppColors.neonPink.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  e.value,
                  style: TextStyle(
                    color: selected ? AppColors.neonGold : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ).animate().fadeIn(delay: 150.ms),
    );
  }

  Widget _buildPodium() {
    final top3 = _rankings.take(3).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 2nd place
            Expanded(child: _PodiumItem(entry: top3[1], delay: 200)),
            // 1st place (taller)
            Expanded(child: _PodiumItem(entry: top3[0], delay: 100, isFirst: true)),
            // 3rd place
            Expanded(child: _PodiumItem(entry: top3[2], delay: 300)),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: _rankings.length - 3,
      itemBuilder: (context, i) {
        final entry = _rankings[i + 3];
        final isMe = entry['isMe'] == true;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: NeonCard(
            padding: const EdgeInsets.all(14),
            borderColor: isMe
                ? AppColors.neonPink.withOpacity(0.4)
                : AppColors.neonPink.withOpacity(0.12),
            glowColor: isMe ? AppColors.neonPink.withOpacity(0.1) : Colors.transparent,
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    '#${entry['rank']}',
                    style: TextStyle(
                      color: isMe ? AppColors.neonPink : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  entry['avatar'] as String,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry['user'] as String,
                        style: TextStyle(
                          color: isMe ? AppColors.neonPink : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        entry['level'] as String,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${entry['xp']} XP',
                      style: const TextStyle(
                        color: AppColors.neonGold,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _buildChange(entry['change'] as int),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: Duration(milliseconds: 200 + i * 80), duration: 400.ms)
              .slideX(begin: 0.05, end: 0),
        );
      },
    );
  }

  Widget _buildChange(int change) {
    if (change == 0) {
      return const Text('—', style: TextStyle(color: AppColors.textSecondary, fontSize: 11));
    }
    final up = change > 0;
    return Row(
      children: [
        Icon(
          up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          color: up ? AppColors.success : AppColors.error,
          size: 12,
        ),
        Text(
          '${change.abs()}',
          style: TextStyle(
            color: up ? AppColors.success : AppColors.error,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  const _PodiumItem({
    required this.entry,
    required this.delay,
    this.isFirst = false,
  });

  final Map<String, dynamic> entry;
  final int delay;
  final bool isFirst;

  Color get _medalColor {
    final rank = entry['rank'] as int;
    if (rank == 1) return AppColors.neonGold;
    if (rank == 2) return const Color(0xFFC0C0C0);
    return const Color(0xFFCD7F32);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(entry['avatar'] as String, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          entry['user'] as String,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: isFirst ? 70 : (entry['rank'] as int == 2 ? 50 : 40),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _medalColor.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: _medalColor.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: _medalColor.withOpacity(0.2),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#${entry['rank']}',
                style: TextStyle(
                  color: _medalColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '${entry['xp']}',
                style: TextStyle(
                  color: _medalColor.withOpacity(0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 500.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
