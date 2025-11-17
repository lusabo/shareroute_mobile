import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/driver_match.dart';
import '../../models/ride_direction.dart';
import '../../services/ride_search_service.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/section_header.dart';

class PassengerSearchScreen extends StatefulWidget {
  const PassengerSearchScreen({super.key});

  @override
  State<PassengerSearchScreen> createState() => _PassengerSearchScreenState();
}

class _PassengerSearchScreenState extends State<PassengerSearchScreen> {
  final RideSearchService _rideSearchService = RideSearchService();
  RideDirection _direction = RideDirection.homeToWork;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  String? _errorMessage;
  List<DriverMatch> _matches = const <DriverMatch>[];

  bool get _isFormValid => _selectedDate != null && _selectedTime != null;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year, now.month + 1, now.day),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _findDrivers() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data e o horário da carona.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _rideSearchService.searchDrivers(
        direction: _direction,
        date: _selectedDate!,
        time: _selectedTime!,
      );
      setState(() {
        _matches = results;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _directionLabel(String direction) {
    return direction == RideDirection.workToHome.apiValue
        ? RideDirection.workToHome.label
        : RideDirection.homeToWork.label;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar carona'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchFilters(
                direction: _direction,
                onDirectionChanged: (value) => setState(() => _direction = value),
                dateController: _dateController,
                timeController: _timeController,
                onPickDate: _pickDate,
                onPickTime: _pickTime,
                onSubmit: _isLoading ? null : _findDrivers,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Sugestões alinhadas ao pedido',
                subtitle: _isLoading
                    ? 'Consultando motoristas disponíveis...'
                    : 'Mostrando motoristas com rotas compatíveis e avaliações recentes.',
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildResults(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(ThemeData theme) {
    if (_isLoading && _matches.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_matches.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.primaryBlue),
          const SizedBox(height: 12),
          Text(
            'Nenhuma carona encontrada ainda',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Informe o tipo de carona, data e horário para consultar motoristas.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return ListView.separated(
      itemCount: _matches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final match = _matches[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(match.driverPhoto),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            match.driverName,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          RatingStars(rating: match.rating),
                          const SizedBox(height: 4),
                          Text(
                            match.car,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      avatar: const Icon(Icons.route, size: 16),
                      label: Text(_directionLabel(match.direction)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RouteInfoRow(
                        icon: Icons.my_location_outlined,
                        label: match.origin,
                        value: 'Saída ${match.departureTime}',
                      ),
                      const SizedBox(height: 8),
                      _RouteInfoRow(
                        icon: Icons.location_on_outlined,
                        label: match.destination,
                        value: 'Chegada ${match.arrivalTime}',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.social_distance, size: 18, color: AppColors.primaryBlue),
                          const SizedBox(width: 6),
                          Text('Desvio ${match.detourKm.toStringAsFixed(1)} km'),
                          const Spacer(),
                          const Icon(Icons.event_seat, size: 18, color: AppColors.primaryBlue),
                          const SizedBox(width: 6),
                          Text('${match.availableSeats} vagas'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (match.tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: match.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: AppColors.accentGreen.withOpacity(.12),
                            labelStyle: const TextStyle(color: AppColors.accentGreen),
                          ),
                        )
                        .toList(),
                  ),
                if (match.notes != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    match.notes!,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Solicitação enviada para ${match.driverName}')),
                      );
                    },
                    child: const Text('Solicitar carona'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchFilters extends StatelessWidget {
  const _SearchFilters({
    required this.direction,
    required this.onDirectionChanged,
    required this.dateController,
    required this.timeController,
    required this.onPickDate,
    required this.onPickTime,
    required this.onSubmit,
    required this.isLoading,
  });

  final RideDirection direction;
  final ValueChanged<RideDirection> onDirectionChanged;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback? onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tipo de carona', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: RideDirection.values
                .map(
                  (rideDirection) => ChoiceChip(
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rideDirection.label),
                        Text(
                          rideDirection.helperText,
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                    selected: direction == rideDirection,
                    onSelected: (_) => onDirectionChanged(rideDirection),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  onTap: onPickDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: timeController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Horário',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  onTap: onPickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(isLoading ? 'Buscando motoristas...' : 'Encontrar motoristas'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteInfoRow extends StatelessWidget {
  const _RouteInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              Text(value, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
