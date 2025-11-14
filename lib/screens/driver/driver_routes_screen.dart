import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/mock_data.dart';
import '../../widgets/section_header.dart';

class DriverRoutesScreen extends StatelessWidget {
  const DriverRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas rotas'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Nova rota'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Rotas ativas',
                subtitle: 'Gerencie horários, vagas e dias da semana.',
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: mockRoutes.length,
                  itemBuilder: (context, index) {
                    final route = mockRoutes[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withOpacity(.08),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.route, color: AppColors.primaryBlue),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${route.origin} → ${route.destination}',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Saída ${route.departureTime} • Retorno ${route.returnTime}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: AppColors.lightSlate),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Chip(
                                  label: Text('${route.spots} vagas'),
                                  avatar: const Icon(Icons.event_seat, size: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children: route.days
                                  .map(
                                    (day) => Chip(
                                  label: Text(day),
                                  backgroundColor: AppColors.primaryBlue.withOpacity(.08),
                                  labelStyle: const TextStyle(color: AppColors.primaryBlue),
                                ),
                              )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Editar'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.share_location_outlined),
                                    label: const Text('Ver mapa'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}