import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../routes.dart';
import '../../widgets/highlight_chip.dart';
import '../../widgets/section_header.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo à ShareRoute'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transforme sua mobilidade corporativa',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Compartilhe rotas, desbloqueie benefícios ESG e crie conexões com o time.',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.lightSlate),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(.08),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(Icons.eco_outlined, color: AppColors.primaryBlue, size: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        HighlightChip(icon: Icons.leaderboard, label: 'Impacto ESG mensurável'),
                        HighlightChip(icon: Icons.card_giftcard, label: 'Recompensas corporativas'),
                        HighlightChip(icon: Icons.lock_outline, label: 'Segurança e verificação'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const SectionHeader(
                title: 'Escolha como quer participar hoje',
                subtitle: 'Você pode alternar entre motorista e passageiro quando quiser.',
              ),
              Row(
                children: [
                  Expanded(
                    child: _RoleCard(
                      title: 'Sou motorista',
                      description:
                      'Crie rotas, aprove vagas disponíveis e acompanhe solicitações em tempo real.',
                      icon: Icons.directions_car_filled,
                      color: AppColors.primaryBlue,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.driverRoutes),
                      quickActions: [
                        _QuickAction(
                          icon: Icons.add_circle_outline,
                          label: 'Criar rota',
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.driverRoutes),
                        ),
                        _QuickAction(
                          icon: Icons.mark_chat_unread_outlined,
                          label: 'Ver solicitações',
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.driverRequests),
                        ),
                        _QuickAction(
                          icon: Icons.directions_car_filled_outlined,
                          label: 'Carona ativa',
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.driverActiveRide),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _RoleCard(
                      title: 'Sou passageiro',
                      description:
                      'Encontre motoristas, acompanhe aprovação e mantenha contato com o time.',
                      icon: Icons.emoji_people_outlined,
                      color: AppColors.accentGreen,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.passengerSearch),
                      quickActions: [
                        _QuickAction(
                          icon: Icons.search,
                          label: 'Buscar carona',
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.passengerSearch),
                        ),
                        _QuickAction(
                          icon: Icons.check_circle_outline,
                          label: 'Ver carona aprovada',
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.passengerApproved),
                        ),
                        _QuickAction(
                          icon: Icons.star_border,
                          label: 'Avaliar motorista',
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.passengerReview),
                        ),
                      ],
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.quickActions,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final List<_QuickAction> quickActions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.lightSlate),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: quickActions
                    .map(
                      (action) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: OutlinedButton.icon(
                      onPressed: action.onPressed,
                      icon: Icon(action.icon),
                      label: Text(action.label),
                    ),
                  ),
                )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  _QuickAction({required this.icon, required this.label, required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
}