import 'package:flutter/material.dart';

import '../../app_theme.dart';

import '../../widgets/section_header.dart';

class DriverRoutesScreen extends StatefulWidget {
  const DriverRoutesScreen({super.key});

  @override
  State<DriverRoutesScreen> createState() => _DriverRoutesScreenState();
}

class _DriverRoutesScreenState extends State<DriverRoutesScreen> {
  static const _weekDays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  final Map<String, Set<int>> _selectedDays = {
    'homeWork': {0, 1, 2, 3, 4},
    'workHome': {0, 1, 2, 3, 4},
  };

  final Map<String, TimeOfDay> _departureTimes = {
    'homeWork': const TimeOfDay(hour: 7, minute: 30),
    'workHome': const TimeOfDay(hour: 18, minute: 0),
  };

  final Map<String, int> _availableSeats = {
    'homeWork': 3,
    'workHome': 3,
  };

  Future<void> _pickTime(String routeKey) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _departureTimes[routeKey]!,
    );
    if (picked != null) {
      setState(() => _departureTimes[routeKey] = picked);
    }
  }

  void _toggleDay(String routeKey, int dayIndex) {
    setState(() {
      final selected = _selectedDays[routeKey]!;
      if (selected.contains(dayIndex)) {
        selected.remove(dayIndex);
      } else {
        selected.add(dayIndex);
      }
    });
  }

  void _changeSeats(String routeKey, int delta) {
    setState(() {
      final newValue = (_availableSeats[routeKey]! + delta).clamp(1, 6);
      _availableSeats[routeKey] = newValue;
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas rotas'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Disponibilidade semanal',
                subtitle: 'Configure os dias, horários e vagas para cada sentido.',
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    _RouteCard(
                      icon: Icons.home_work_outlined,
                      title: 'Casa → Trabalho',
                      description: 'Informe em quais dias você sai de casa para o trabalho.',
                      weekDays: _weekDays,
                      selectedDays: _selectedDays['homeWork']!,
                      timeLabel: _formatTime(_departureTimes['homeWork']!),
                      onDayToggle: (index) => _toggleDay('homeWork', index),
                      onPickTime: () => _pickTime('homeWork'),
                      seats: _availableSeats['homeWork']!,
                      onIncrementSeat: () => _changeSeats('homeWork', 1),
                      onDecrementSeat: () => _changeSeats('homeWork', -1),
                    ),
                    _RouteCard(
                      icon: Icons.work_outline,
                      title: 'Trabalho → Casa',
                      description: 'Defina quando você faz o trajeto de volta para casa.',
                      weekDays: _weekDays,
                      selectedDays: _selectedDays['workHome']!,
                      timeLabel: _formatTime(_departureTimes['workHome']!),
                      onDayToggle: (index) => _toggleDay('workHome', index),
                      onPickTime: () => _pickTime('workHome'),
                      seats: _availableSeats['workHome']!,
                      onIncrementSeat: () => _changeSeats('workHome', 1),
                      onDecrementSeat: () => _changeSeats('workHome', -1),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Disponibilidade atualizada com sucesso!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    'Salvar disponibilidade',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.weekDays,
    required this.selectedDays,
    required this.timeLabel,
    required this.onPickTime,
    required this.onDayToggle,
    required this.seats,
    required this.onIncrementSeat,
    required this.onDecrementSeat,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> weekDays;
  final Set<int> selectedDays;
  final String timeLabel;
  final VoidCallback onPickTime;
  final ValueChanged<int> onDayToggle;
  final int seats;
  final VoidCallback onIncrementSeat;
  final VoidCallback onDecrementSeat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  child: Icon(icon, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.lightSlate,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Dias disponíveis',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                weekDays.length,
                (index) => ChoiceChip(
                  label: Text(weekDays[index]),
                  selected: selectedDays.contains(index),
                  onSelected: (_) => onDayToggle(index),
                  selectedColor: AppColors.primaryBlue,
                  labelStyle: TextStyle(
                    color: selectedDays.contains(index)
                        ? Colors.white
                        : AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: AppColors.primaryBlue.withOpacity(.08),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Horário de saída',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: onPickTime,
                        icon: const Icon(Icons.schedule),
                        label: Text(timeLabel),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vagas disponíveis',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryBlue),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: onDecrementSeat,
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.primaryBlue,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '$seats',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: onIncrementSeat,
                              icon: const Icon(Icons.add_circle_outline),
                              color: AppColors.primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}