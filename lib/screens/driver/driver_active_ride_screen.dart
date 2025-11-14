import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../widgets/section_header.dart';

class DriverActiveRideScreen extends StatelessWidget {
  const DriverActiveRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carona ativa'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withOpacity(.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.route_rounded, color: AppColors.accentGreen),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vila Olímpia → Escritório HQ',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Saída 07:30 • Chegada estimada 08:05',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.lightSlate),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.person, size: 16),
                              SizedBox(width: 4),
                              Text('3/4'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        height: 160,
                        color: AppColors.primaryBlue.withOpacity(.08),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.map_outlined,
                          size: 72,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _InfoPill(icon: Icons.departure_board, label: 'Saída agora'),
                        _InfoPill(icon: Icons.timer, label: '15 min de trajeto'),
                        _InfoPill(icon: Icons.shield, label: 'Seguro ativo'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Passageiros confirmados',
                subtitle: 'Acompanhe presença e comunicação rápida.',
              ),
              Expanded(
                child: ListView(
                  children: const [
                    _PassengerTile(
                      name: 'Mariana Souza',
                      origin: 'Ponto A • Vila Olímpia',
                      status: 'Aguardando embarque',
                      avatarUrl: 'https://i.pravatar.cc/100?img=1',
                    ),
                    _PassengerTile(
                      name: 'Felipe Rocha',
                      origin: 'Ponto B • Vila Olímpia',
                      status: 'Embarcou',
                      avatarUrl: 'https://i.pravatar.cc/100?img=5',
                    ),
                    _PassengerTile(
                      name: 'Larissa Melo',
                      origin: 'Ponto C • Itaim Bibi',
                      status: 'A caminho',
                      avatarUrl: 'https://i.pravatar.cc/100?img=12',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Encerrar rota com segurança'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassengerTile extends StatelessWidget {
  const _PassengerTile({
    required this.name,
    required this.origin,
    required this.status,
    required this.avatarUrl,
  });

  final String name;
  final String origin;
  final String status;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(radius: 26, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    origin,
                    style:
                    theme.textTheme.bodySmall?.copyWith(color: AppColors.lightSlate),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}