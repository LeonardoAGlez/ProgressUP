import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_card.dart';
import '../../../shared/widgets/neon_button.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int _selectedPlan = 1; // 0 = mensual, 1 = anual (default)
  bool _isLoading = false;

  final _plans = [
    {
      'id': 'monthly',
      'name': 'Mensual',
      'price': '\$9.99',
      'period': '/mes',
      'savings': null,
      'productId': 'neonpulse_pro_monthly',
    },
    {
      'id': 'annual',
      'name': 'Anual',
      'price': '\$59.99',
      'period': '/año',
      'savings': 'Ahorra 50%',
      'productId': 'neonpulse_pro_annual',
    },
  ];

  final _features = [
    {'icon': '⚡', 'title': 'Workout sin límites', 'desc': 'Acceso a +500 rutinas premium'},
    {'icon': '🤖', 'title': 'AI Coach Personal', 'desc': 'Planes adaptados a ti con IA'},
    {'icon': '📊', 'title': 'Analytics Avanzado', 'desc': 'Métricas detalladas de progreso'},
    {'icon': '🏆', 'title': 'Torneos PRO', 'desc': 'Competencias exclusivas con premios'},
    {'icon': '💪', 'title': 'Nutrición Integrada', 'desc': 'Plan nutricional personalizado'},
    {'icon': '🚫', 'title': 'Sin anuncios', 'desc': 'Experiencia completamente limpia'},
  ];

  Future<void> _subscribe() async {
    setState(() => _isLoading = true);
    // TODO: Integrate RevenueCat
    // final offering = await Purchases.getOfferings();
    // final package = offering.current?.monthly or annual
    // await Purchases.purchasePackage(package);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text(
            '⭐ ¡Bienvenido a PRO!',
            style: TextStyle(
                color: AppColors.neonGold, fontWeight: FontWeight.w800),
          ),
        ),
        content: const Text(
          'Tu suscripción está activa. ¡Disfruta todas las funciones premium!',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text('¡EMPEZAR!',
                style: TextStyle(color: AppColors.neonPink)),
          ),
        ],
      ),
    );
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
              // Custom back bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textSecondary),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.neonGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.neonGold.withOpacity(0.3)),
                      ),
                      child: const Text(
                        '⭐ NEON PULSE PRO',
                        style: TextStyle(
                          color: AppColors.neonGold,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildHero(),
                      const SizedBox(height: 28),
                      _buildPlans(),
                      const SizedBox(height: 28),
                      _buildFeatures(),
                      const SizedBox(height: 28),
                      _buildCTA(),
                      const SizedBox(height: 16),
                      _buildLegal(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        // Animated glow orb
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.neonGold.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 2000.ms),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.neonGold, AppColors.neonPink],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGold.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.workspace_premium_rounded,
                  color: Colors.white, size: 40),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms).scale(),

        const SizedBox(height: 20),

        const Text(
          'Desbloquea tu Máximo\nPotencial',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 150.ms, duration: 500.ms),

        const SizedBox(height: 8),

        const Text(
          'Accede a todo el ecosistema NEON PULSE PRO y entrena sin límites.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildPlans() {
    return Row(
      children: _plans.asMap().entries.map((e) {
        final plan = e.value;
        final selected = _selectedPlan == e.key;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: e.key == 0 ? 0 : 8,
              right: e.key == 1 ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPlan = e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          colors: [
                            AppColors.neonGold,
                            AppColors.neonPink
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: selected ? null : AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? Colors.transparent
                        : AppColors.neonPink.withOpacity(0.15),
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.neonGold.withOpacity(0.3),
                            blurRadius: 20,
                          )
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    if (plan['savings'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          plan['savings'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    Text(
                      plan['name'] as String,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      plan['price'] as String,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : AppColors.neonPink,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      plan['period'] as String,
                      style: TextStyle(
                        color: selected
                            ? Colors.white70
                            : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 300 + e.key * 100),
                duration: 400.ms,
              )
              .slideY(begin: 0.1, end: 0),
        );
      }).toList(),
    );
  }

  Widget _buildFeatures() {
    return NeonCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Incluye todo esto:',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ..._features.asMap().entries.map((e) {
            final f = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(f['icon'] as String,
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['title'] as String,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          f['desc'] as String,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 18),
                ],
              )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 400 + e.key * 60),
                    duration: 350.ms,
                  )
                  .slideX(begin: 0.05, end: 0),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCTA() {
    final plan = _plans[_selectedPlan];
    return Column(
      children: [
        NeonButton(
          label: 'SUSCRIBIRSE: ${plan['price']}${plan['period']}',
          onPressed: _isLoading ? null : _subscribe,
          isLoading: _isLoading,
          color: AppColors.neonGold,
        ).animate().fadeIn(delay: 700.ms).scale(),
        const SizedBox(height: 12),
        NeonButton(
          label: 'Probar 7 días gratis',
          onPressed: () {},
          isOutlined: true,
          color: AppColors.neonGold,
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }

  Widget _buildLegal() {
    return Column(
      children: const [
        Text(
          'Cancela en cualquier momento. Sin contratos.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          'Términos de servicio • Política de privacidad',
          style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: 11,
              decoration: TextDecoration.underline),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(delay: 900.ms);
  }
}
