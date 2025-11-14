import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../routes.dart';
import '../../widgets/highlight_chip.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentIndex = 0;

  final _slides = const [
    _OnboardingSlide(
      title: 'Mobilidade Sustentável',
      description:
      'Reduza emissões de CO₂ e contribua para um planeta mais verde através de caronas compartilhadas.',
      asset: Icons.public,
      highlights: [
        'Menos carros nas ruas',
        'Relatórios ESG automáticos',
        'Impacto positivo para a cidade',
      ],
    ),
    _OnboardingSlide(
      title: 'Benefícios Relevantes',
      description:
      'Compartilhe caronas, ganhe recompensas, vagas preferenciais e bônus exclusivos da sua empresa.',
      asset: Icons.card_giftcard,
      highlights: [
        'Economia com combustível',
        'Vouchers e cashback',
        'Estacionamento garantido',
      ],
    ),
    _OnboardingSlide(
      title: 'Segurança Garantida',
      description:
      'Perfis verificados, avaliações após as viagens e suporte corporativo 24/7 criam um ambiente confiável.',
      asset: Icons.verified_user,
      highlights: [
        'Avaliações transparentes',
        'Perfis completos',
        'Suporte dedicado',
      ],
    ),
  ];

  void _onNext() {
    if (_currentIndex == _slides.length - 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.auth);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.auth,
                  ),
                  child: const Text('Pular'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) => setState(() => _currentIndex = index),
                  itemCount: _slides.length,
                  itemBuilder: (_, index) => _slides[index],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == index ? 28 : 12,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      child: Text(
                        _currentIndex == _slides.length - 1
                            ? 'Começar'
                            : 'Continuar',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.title,
    required this.description,
    required this.asset,
    required this.highlights,
  });

  final String title;
  final String description;
  final IconData asset;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      height: 240,
                      width: 240,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(.08),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(asset, size: 128, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightSlate,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: highlights
                        .map((item) => HighlightChip(icon: Icons.check_circle, label: item))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}