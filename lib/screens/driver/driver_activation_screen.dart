import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/driver_bonus.dart';
import '../../routes.dart';
import '../../services/driver_activation_service.dart';
import '../../widgets/info_card.dart';
import '../../widgets/section_header.dart';

class DriverActivationScreen extends StatefulWidget {
  const DriverActivationScreen({super.key});

  @override
  State<DriverActivationScreen> createState() =>
      _DriverActivationScreenState();
}

class _DriverActivationScreenState extends State<DriverActivationScreen> {
  static const _preferenceOptions = <String>[
    'Gosto de conversar',
    'Playlist colaborativa',
    'Aceito pets',
    'Climatização ajustável',
    'Silêncio nas manhãs',
  ];

  final _vehicleController = TextEditingController();
  final _plateController = TextEditingController();
  final _colorController = TextEditingController();
  final _selectedPreferences = <String>{};
  final _selectedBonuses = <String>{};
  final DriverActivationService _service = DriverActivationService();

  bool _loadingBonuses = true;
  bool _submitting = false;
  String? _bonusesError;
  List<DriverBonus> _bonuses = const <DriverBonus>[];

  @override
  void initState() {
    super.initState();
    _loadBonuses();
  }

  Future<void> _loadBonuses() async {
    setState(() {
      _loadingBonuses = true;
      _bonusesError = null;
    });
    try {
      final bonuses = await _service.fetchAvailableBonuses();
      setState(() {
        _bonuses = bonuses;
      });
    } on DriverActivationException catch (error) {
      setState(() {
        _bonusesError = error.message;
      });
    } catch (_) {
      setState(() {
        _bonusesError = 'Não foi possível carregar os bônus disponíveis.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingBonuses = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _vehicleController.dispose();
    _plateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _togglePreference(String preference, bool selected) {
    setState(() {
      if (selected) {
        _selectedPreferences.add(preference);
      } else {
        _selectedPreferences.remove(preference);
      }
    });
  }

  void _toggleBonus(String bonusId, bool shouldSelect) {
    setState(() {
      if (!shouldSelect) {
        _selectedBonuses.remove(bonusId);
        return;
      }
      if (_selectedBonuses.length >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione no máximo dois bônus.'),
          ),
        );
        return;
      }
      _selectedBonuses.add(bonusId);
    });
  }

  Future<void> _submitActivation() async {
    if (_vehicleController.text.trim().isEmpty ||
        _plateController.text.trim().isEmpty ||
        _colorController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha as informações do veículo.'),
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      await _service.submitActivation(
        vehicleModel: _vehicleController.text.trim(),
        plate: _plateController.text.trim(),
        color: _colorController.text.trim(),
        preferences: _selectedPreferences.toList(),
        selectedBonuses: _selectedBonuses.toList(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ativação enviada com sucesso!')),
      );
      Navigator.pushNamed(context, AppRoutes.home);
    } on DriverActivationException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível enviar seus dados. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

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
                subtitle:
                    'Suas informações ficam visíveis apenas para colegas autorizados.',
              ),
              GestureDetector(
                onTap: () {},
                child: const DottedBorderBox(
                  icon: Icons.file_upload_outlined,
                  title: 'Enviar CNH',
                  description: 'Upload rápido. Aceitamos PDF ou imagens.',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleController,
                decoration: const InputDecoration(
                  labelText: 'Modelo do veículo',
                  prefixIcon: Icon(Icons.directions_car_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(
                  labelText: 'Placa',
                  prefixIcon: Icon(Icons.confirmation_num_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
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
                children: _preferenceOptions
                    .map(
                      (preference) => _PreferenceChip(
                        label: preference,
                        selected: _selectedPreferences.contains(preference),
                        onSelected: (selected) =>
                            _togglePreference(preference, selected),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Escolha seus bônus favoritos',
                subtitle: 'Selecione até dois para acumular durante o mês.',
              ),
              if (_loadingBonuses)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_bonusesError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        _bonusesError!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _loadBonuses,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              else
                ..._bonuses.map(
                  (bonus) => SwitchListTile.adaptive(
                    value: _selectedBonuses.contains(bonus.id),
                    onChanged: (value) => _toggleBonus(bonus.id, value),
                    activeColor: AppColors.primaryBlue,
                    title: Text(bonus.title),
                    subtitle: Text(
                      bonus.description,
                      style: const TextStyle(color: AppColors.lightSlate),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const InfoCard(
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
                  onPressed: _submitting ? null : _submitActivation,
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Concluir ativação'),
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
  const _PreferenceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
    );
  }
}