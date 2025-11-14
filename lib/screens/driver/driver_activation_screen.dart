import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/mock_data.dart';
import '../../routes.dart';
import '../../widgets/info_card.dart';
import '../../widgets/section_header.dart';

class DriverActivationScreen extends StatelessWidget {
  const DriverActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ativar perfil de motorista'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Documentação e veículo',
                subtitle: 'Suas informações ficam visíveis apenas para colegas autorizados.',
              ),
              GestureDetector(
                onTap: () {},
                child: DottedBorderBox(
                  icon: Icons.file_upload_outlined,
                  title: 'Enviar CNH',
                  description: 'Upload rápido. Aceitamos PDF ou imagens.',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Modelo do veículo',
                  prefixIcon: Icon(Icons.directions_car_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Placa',
                  prefixIcon: Icon(Icons.confirmation_num_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Cor',
                  prefixIcon: Icon(Icons.color_lens_outlined),
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Experiência da carona',
                subtitle: 'Defina regras que combinam com seu estilo.',
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _PreferenceChip(label: 'Gosto de conversar'),
                  _PreferenceChip(label: 'Playlist colaborativa'),
                  _PreferenceChip(label: 'Aceito pets'),
                  _PreferenceChip(label: 'Climatização ajustável'),
                  _PreferenceChip(label: 'Silêncio nas manhãs'),
                ],
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Escolha seus bônus favoritos',
                subtitle: 'Selecione até dois para acumular durante o mês.',
              ),
              ...mockBonuses.map(
                    (bonus) => SwitchListTile.adaptive(
                  value: bonus.hashCode.isEven,
                  onChanged: (_) {},
                  activeColor: AppColors.primaryBlue,
                  title: Text(bonus),
                  subtitle: const Text('Disponível mediante rotas concluídas.'),
                ),
              ),
              const SizedBox(height: 24),
              InfoCard(
                icon: Icons.verified_user,
                title: 'Verificação corporativa',
                description:
                'Após enviar sua CNH, nossa equipe confirma a autorização em até 24 horas.',
                badge: 'Proteção 24/7',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
                  child: const Text('Concluir ativação'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFB4C6FF),
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
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
                child: Icon(icon, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.lightSlate),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Selecionar arquivo'),
          ),
        ],
      ),
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  const _PreferenceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: label.hashCode.isEven,
      onSelected: (_) {},
    );
  }
}