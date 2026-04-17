import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';

// Mock posts
final _mockPosts = [
  {
    'user': 'CyberAthleta_99',
    'avatar': '🦾',
    'rank': 'Cyber Warrior',
    'time': 'hace 2h',
    'content': '¡Nuevo record personal en sentadilla! 180kg 🔥 La consistencia paga.',
    'image': null,
    'likes': 47,
    'comments': 12,
    'tag': '#PersonalRecord',
    'liked': false,
  },
  {
    'user': 'NeonQueen_Fit',
    'avatar': '⚡',
    'rank': 'Neon Striker',
    'time': 'hace 5h',
    'content':
        'Completé mi semana perfecta por 4ta vez consecutiva 💪 #ConsistenciaGana',
    'image': null,
    'likes': 83,
    'comments': 24,
    'tag': '#Streak',
    'liked': true,
  },
  {
    'user': 'XenonLifter',
    'avatar': '🏋️',
    'rank': 'Elite Athlete',
    'time': 'hace 1d',
    'content':
        'Mañanero de 5am hits different cuando ya estás en el TOP 10 del ranking. ¿Quién se me une?',
    'image': null,
    'likes': 112,
    'comments': 38,
    'tag': '#Leaderboard',
    'liked': false,
  },
];

class SocialFeedScreen extends ConsumerStatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen> {
  final List<Map<String, dynamic>> _posts = List.from(_mockPosts);

  void _toggleLike(int index) {
    setState(() {
      final post = Map<String, dynamic>.from(_posts[index]);
      post['liked'] = !(post['liked'] as bool);
      post['likes'] = (post['likes'] as int) + (post['liked'] ? 1 : -1);
      _posts[index] = post;
    });
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
              _buildStories(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _posts.length,
                  itemBuilder: (context, index) => _buildPost(index),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.neonPink,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppColors.neonPinkShadow,
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'SOCIAL FEED',
                style: TextStyle(
                  color: AppColors.neonPink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Comunidad',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search_rounded,
                    color: AppColors.textSecondary),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded,
                    color: AppColors.textSecondary),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStories() {
    final stories = ['Tú', 'CyberA.', 'NeonQ.', 'Xenon', 'Pulse99'];
    final colors = [
      AppColors.neonPink,
      AppColors.neonCyan,
      AppColors.neonGold,
      AppColors.neonPurple,
      AppColors.neonGreen,
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [colors[i], colors[i].withOpacity(0.4)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors[i].withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      i == 0 ? '+' : stories[i][0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stories[i],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: Duration(milliseconds: i * 80), duration: 400.ms)
                .scale(begin: const Offset(0.8, 0.8)),
          );
        },
      ),
    );
  }

  Widget _buildPost(int index) {
    final post = _posts[index];
    final liked = post['liked'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeonCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonPink,
                        AppColors.neonCyan.withOpacity(0.5)
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      post['avatar'] as String,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['user'] as String,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${post['rank']} • ${post['time']}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.neonPink.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    post['tag'] as String,
                    style: const TextStyle(
                      color: AppColors.neonPink,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              post['content'] as String,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 14),

            // Actions
            Row(
              children: [
                _ActionButton(
                  icon: liked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: '${post['likes']}',
                  color: liked ? AppColors.neonPink : AppColors.textSecondary,
                  onTap: () => _toggleLike(index),
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${post['comments']}',
                  color: AppColors.textSecondary,
                  onTap: () {},
                ),
                const Spacer(),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Compartir',
                  color: AppColors.textSecondary,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
            delay: Duration(milliseconds: 100 + index * 120),
            duration: 500.ms,
          )
          .slideY(begin: 0.08, end: 0),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
