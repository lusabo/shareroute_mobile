import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../widgets/section_header.dart';

class PassengerApprovedRideScreen extends StatelessWidget {
  const PassengerApprovedRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carona aprovada'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=15'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ana Martins',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Toyota Corolla Híbrido • Azul',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.verified, color: AppColors.accentGreen, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Confirmada',
                                  style: TextStyle(
                                    color: AppColors.accentGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          height: 160,
                          color: AppColors.primaryBlue.withOpacity(.08),
                          alignment: Alignment.center,
                          child: const Icon(Icons.map_outlined, size: 64, color: AppColors.primaryBlue),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoColumn(
                              icon: Icons.schedule,
                              label: 'Horário',
                              value: 'Saída 07:20 • Retorno 18:00',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoColumn(
                              icon: Icons.place_outlined,
                              label: 'Pontos de encontro',
                              value: 'Vila Olímpia • Escritório HQ',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Prepare-se para o embarque',
              ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _ChecklistItem(
                      icon: Icons.chat_bubble_outline,
                      text: 'Confirme detalhes com a motorista pelo chat corporativo.',
                    ),
                    const Divider(height: 24),
                    _ChecklistItem(
                      icon: Icons.event_available_outlined,
                      text: 'Adicione o horário ao calendário com um toque.',
                    ),
                    const Divider(height: 24),
                    _ChecklistItem(
                      icon: Icons.shield_outlined,
                      text: 'Compartilhe o embarque com contatos de confiança.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Notificações recentes'),
              Expanded(
                child: ListView(
                  children: const [
                    _NotificationTile(
                      title: 'Embarque confirmado',
                      description: 'Ana confirmou sua presença. Chegue 5 minutos antes.',
                      time: 'Há 10 minutos',
                    ),
                    _NotificationTile(
                      title: 'Benefício desbloqueado',
                      description: 'Você ganhou 10 pts no clube de benefícios ESG.',
                      time: 'Ontem',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirmar embarque agora'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryBlue),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.midnightBlue),
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.description,
    required this.time,
  });

  final String title;
  final String description;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(color: AppColors.lightSlate, fontSize: 12),
            ),
          ],
        ),
        leading: const Icon(Icons.notifications_active_outlined, color: AppColors.primaryBlue),
      ),
    );
  }
}