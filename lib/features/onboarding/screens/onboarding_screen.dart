import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/neon_button.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/user_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Step 1: Personal Data
  final _nameCtrl = TextEditingController();
  String _gender = 'Masculino';
  DateTime? _dob;
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  // Step 2: History
  String _trainingTime = 'Menos de 3 meses';
  String _daysPerWeek = '1–2 días';
  String _routine = 'No, entreno lo que quiero';
  String _objective = 'Ganar músculo';

  // Step 3: Performance & Gym
  String _squat = 'No puedo / no sé';
  String _pullups = '0';
  String _gymName = '';
  final _gymCodeCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _gymCodeCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (_nameCtrl.text.isEmpty || _weightCtrl.text.isEmpty || _heightCtrl.text.isEmpty || _dob == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor completa todos los campos')));
        return;
      }
    }
    
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      _finishOnboarding();
    }
  }

  String _calculateLevel() {
    int score = 0;

    // Time training
    if (_trainingTime == '3–12 meses') score += 1;
    else if (_trainingTime == '1–3 años') score += 2;
    else if (_trainingTime == 'Más de 3 años') score += 3;

    // Days
    if (_daysPerWeek == '3–4 días') score += 1;
    else if (_daysPerWeek == '5 o más días') score += 2;

    // Squats
    if (_squat == 'Menos de mi peso corporal') score += 1;
    else if (_squat == '1–1.5× peso') score += 2;
    else if (_squat == 'Más de 1.5× peso') score += 3;

    if (score < 3) return 'Novato';
    if (score < 6) return 'Constante';
    return 'Atleta';
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('No session found');

      final level = _calculateLevel();

      await Supabase.instance.client.from('users').upsert({
        'id': user.id,
        'full_name': _nameCtrl.text.trim(),
        'sexo': _gender,
        'fecha_nacimiento': _dob?.toIso8601String(),
        'peso_kg': double.tryParse(_weightCtrl.text) ?? 70.0,
        'estatura_cm': double.tryParse(_heightCtrl.text) ?? 170.0,
        'tiempo_entrenando': _trainingTime,
        'dias_semana': _daysPerWeek,
        'sigue_rutina': _routine,
        'objetivo': _objective,
        'sentadilla': _squat,
        'dominadas': _pullups,
        'nivel': 1,
        'rango': level,
        'xp_total': 0,
        'puntos_semana': 0,
        'streak': 0,
        'subscription_tier': 'Free',
      });

      ref.invalidate(userProvider);
      
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: NeonButton(
                label: _currentPage == 2 ? 'FINALIZAR' : 'SIGUIENTE',
                onPressed: _isLoading ? null : _nextPage,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              decoration: BoxDecoration(
                color: index <= _currentPage ? AppColors.neonPink : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(3),
                boxShadow: index <= _currentPage ? AppColors.neonPinkShadow : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paso 1: Tus Datos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.neonCyan),
          ).animate().fadeIn(),
          const SizedBox(height: 24),
          _buildTextField(_nameCtrl, 'Nombre y apellido', Icons.person),
          const SizedBox(height: 16),
          _buildDropdown('Sexo', _gender, ['Masculino', 'Femenino', 'Prefiero no decir'], (val) => setState(() => _gender = val!)),
          const SizedBox(height: 16),
          ListTile(
            title: Text(_dob == null ? 'Fecha de nacimiento' : '${_dob!.day}/${_dob!.month}/${_dob!.year}'),
            trailing: const Icon(Icons.calendar_today, color: AppColors.neonPink),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.neonPink.withOpacity(0.3))),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                firstDate: DateTime(1940),
                lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
              );
              if (date != null) setState(() => _dob = date);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(_weightCtrl, 'Peso (kg)', Icons.monitor_weight, isNumber: true)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField(_heightCtrl, 'Estatura (cm)', Icons.height, isNumber: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paso 2: Tu Experiencia',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.neonCyan),
          ).animate().fadeIn(),
          const SizedBox(height: 24),
          _buildDropdown('¿Tiempo entrenando?', _trainingTime, ['Menos de 3 meses', '3–12 meses', '1–3 años', 'Más de 3 años'], (val) => setState(() => _trainingTime = val!)),
          const SizedBox(height: 16),
          _buildDropdown('¿Días a la semana?', _daysPerWeek, ['1–2 días', '3–4 días', '5 o más días'], (val) => setState(() => _daysPerWeek = val!)),
          const SizedBox(height: 16),
          _buildDropdown('¿Sigues rutina?', _routine, ['No, entreno lo que quiero', 'Sigo una rutina de internet', 'Tengo rutina de entrenador'], (val) => setState(() => _routine = val!)),
          const SizedBox(height: 16),
          _buildDropdown('¿Objetivo principal?', _objective, ['Bajar peso', 'Ganar músculo', 'Mejorar resistencia', 'Mantenerme', 'Competir'], (val) => setState(() => _objective = val!)),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paso 3: Tu Nivel',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.neonCyan),
          ).animate().fadeIn(),
          const SizedBox(height: 24),
          _buildDropdown('¿Sentadilla con barra?', _squat, ['No puedo / no sé', 'Menos de mi peso corporal', '1–1.5× peso', 'Más de 1.5× peso'], (val) => setState(() => _squat = val!)),
          const SizedBox(height: 16),
          _buildDropdown('¿Dominadas?', _pullups, ['0', '1–5', '6–12', 'Más de 12'], (val) => setState(() => _pullups = val!)),
          const SizedBox(height: 24),
          _buildTextField(_gymCodeCtrl, 'Código de tu gimnasio (Opcional)', Icons.business),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surfaceCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.neonPink.withOpacity(0.3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.neonPink.withOpacity(0.1))),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surfaceCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.neonPink.withOpacity(0.3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.neonPink.withOpacity(0.1))),
      ),
      dropdownColor: AppColors.surface,
    );
  }
}
