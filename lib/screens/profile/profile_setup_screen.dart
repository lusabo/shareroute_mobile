import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/mock_data.dart';
import '../../models/user_profile.dart';
import '../../routes.dart';
import '../../services/profile_service.dart';
import '../../widgets/section_header.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _horarioIdaController = TextEditingController();
  final TextEditingController _horarioVoltaController = TextEditingController();

  late final ProfileService _profileService;

  bool isDriver = false;
  bool isPassenger = true;

  bool _isLoadingProfile = true;
  bool _isSaving = false;
  String? _loadError;
  UserProfile? _profile;

  bool _aceitaConversas = false;
  bool _aceitaMusica = false;
  bool _aceitaPets = false;
  bool _aceitaFumar = false;

  TimeOfDay? _horarioIda;
  TimeOfDay? _horarioVolta;

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService();
    _fetchProfile();
  }

  @override
  void dispose() {
    _horarioIdaController.dispose();
    _horarioVoltaController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoadingProfile = true;
      _loadError = null;
    });

    try {
      final profile = await _profileService.fetchUserProfile();
      _applyProfile(profile);
    } on ProfileException catch (error) {
      setState(() {
        _isLoadingProfile = false;
        _loadError = error.message;
      });
    } catch (_) {
      setState(() {
        _isLoadingProfile = false;
        _loadError = 'Não foi possível carregar os dados. Tente novamente.';
      });
    }
  }

  void _applyProfile(UserProfile profile) {
    final preferences = profile.preferenciasCarona;
    final ida = _parseTime(preferences.horarioPreferidoIda);
    final volta = _parseTime(preferences.horarioPreferidoVolta);

    setState(() {
      _profile = profile;
      _aceitaConversas = preferences.aceitaConversas;
      _aceitaMusica = preferences.aceitaMusica;
      _aceitaPets = preferences.aceitaPets;
      _aceitaFumar = preferences.aceitaFumar;
      _horarioIda = ida;
      _horarioVolta = volta;
      _horarioIdaController.text = ida != null ? _formatTime(ida) : '';
      _horarioVoltaController.text = volta != null ? _formatTime(volta) : '';
      _isLoadingProfile = false;
    });
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parts = value.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime({required bool isDeparture}) async {
    final initialTime = isDeparture
        ? (_horarioIda ?? const TimeOfDay(hour: 8, minute: 0))
        : (_horarioVolta ?? const TimeOfDay(hour: 17, minute: 0));
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _horarioIda = picked;
          _horarioIdaController.text = _formatTime(picked);
        } else {
          _horarioVolta = picked;
          _horarioVoltaController.text = _formatTime(picked);
        }
      });
    }
  }

  Future<void> _onSave() async {
    if (_isSaving) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final preferences = RidePreferences(
      aceitaConversas: _aceitaConversas,
      aceitaMusica: _aceitaMusica,
      aceitaPets: _aceitaPets,
      aceitaFumar: _aceitaFumar,
      horarioPreferidoIda: _horarioIda != null ? _formatTime(_horarioIda!) : null,
      horarioPreferidoVolta:
          _horarioVolta != null ? _formatTime(_horarioVolta!) : null,
    );

    setState(() {
      _isSaving = true;
    });

    try {
      await _profileService.updateRidePreferences(preferences);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferências salvas com sucesso!')),
      );
    } on ProfileException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Não foi possível salvar suas preferências. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildProfileInfo(ThemeData theme) {
    final profile = _profile;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    Widget buildRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                '$label:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightSlate,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
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
            'Dados corporativos',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          buildRow('Nome', profile.nome),
          buildRow('Departamento', profile.departamento),
          buildRow('Unidade', profile.unidade),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(ThemeData theme) {
    return Container(
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
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Aceito conversar durante a viagem'),
            value: _aceitaConversas,
            onChanged: (value) {
              setState(() {
                _aceitaConversas = value;
              });
            },
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Aceito ouvir música durante a viagem'),
            value: _aceitaMusica,
            onChanged: (value) {
              setState(() {
                _aceitaMusica = value;
              });
            },
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Aceito levar pets'),
            value: _aceitaPets,
            onChanged: (value) {
              setState(() {
                _aceitaPets = value;
              });
            },
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Aceito passageiros fumando'),
            value: _aceitaFumar,
            onChanged: (value) {
              setState(() {
                _aceitaFumar = value;
              });
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _horarioIdaController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Horário preferido de saída',
              prefixIcon: Icon(Icons.schedule_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o horário preferido de saída.';
              }
              return null;
            },
            onTap: () => _selectTime(isDeparture: true),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _horarioVoltaController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Horário preferido de retorno',
              prefixIcon: Icon(Icons.schedule),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o horário preferido de retorno.';
              }
              return null;
            },
            onTap: () => _selectTime(isDeparture: false),
          ),
        ],
      ),
    );
  }

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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isLoadingProfile
              ? const Center(child: CircularProgressIndicator())
              : _loadError != null
                  ? _ErrorState(message: _loadError!, onRetry: _fetchProfile)
                  : Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeader(
                              title: 'Sobre você',
                              subtitle:
                                  'Detalhes ajudam colegas a encontrarem a melhor carona.',
                            ),
                            const SizedBox(height: 16),
                            _buildProfileInfo(theme),
                            const SizedBox(height: 24),
                            _buildPreferencesSection(theme),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  child: Text('Motorista'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
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
                                border:
                                    Border.all(color: const Color(0xFFE0E7FF)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Benefícios corporativos disponíveis',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ...mockPerks.map(
                                    (perk) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: AppColors.accentGreen,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              perk,
                                              style:
                                                  theme.textTheme.bodyMedium,
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
                                onPressed: _isSaving ? null : _onSave,
                                child: _isSaving
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Salvar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
