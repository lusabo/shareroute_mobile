import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/mock_data.dart';
import '../../routes.dart';
import '../../widgets/section_header.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  bool isDriver = false;
  bool isPassenger = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar perfil'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            child: const Text('Pular'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Sobre você',
                subtitle: 'Detalhes ajudam colegas a encontrarem a melhor carona.',
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  prefixIcon: Icon(Icons.apartment_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Empresa/Unidade',
                  prefixIcon: Icon(Icons.business_center_outlined),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E7FF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferências de carona',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilterChip(
                          label: const Text('Horários flexíveis'),
                          selected: true,
                          onSelected: (_) {},
                        ),
                        FilterChip(
                          label: const Text('Rotas diretas'),
                          selected: true,
                          onSelected: (_) {},
                        ),
                        FilterChip(
                          label: const Text('Aceita desvio leve'),
                          selected: false,
                          onSelected: (_) {},
                        ),
                        FilterChip(
                          label: const Text('Preferência por silêncio'),
                          selected: false,
                          onSelected: (_) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Horário preferido de saída',
                        prefixIcon: Icon(Icons.schedule_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Horário preferido de retorno',
                        prefixIcon: Icon(Icons.schedule),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Como deseja utilizar o ShareRoute?',
              ),
              ToggleButtons(
                isSelected: [isDriver, isPassenger],
                onPressed: (index) {
                  setState(() {
                    if (index == 0) {
                      isDriver = !isDriver;
                    } else {
                      isPassenger = !isPassenger;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                selectedColor: Colors.white,
                color: AppColors.lightSlate,
                fillColor: AppColors.primaryBlue,
                textStyle: theme.textTheme.titleMedium,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('Motorista'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('Passageiro'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E7FF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Benefícios corporativos disponíveis',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...mockPerks.map(
                          (perk) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.accentGreen),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                perk,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isDriver) {
                      Navigator.pushNamed(context, AppRoutes.driverActivation);
                    } else {
                      Navigator.pushNamed(context, AppRoutes.home);
                    }
                  },
                  child: Text(isDriver
                      ? 'Avançar para habilitar motorista'
                      : 'Ir para a Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
