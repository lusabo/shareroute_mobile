import 'package:flutter/material.dart';

import '../../app_theme.dart';

class PassengerReviewScreen extends StatefulWidget {
  const PassengerReviewScreen({super.key});

  @override
  State<PassengerReviewScreen> createState() => _PassengerReviewScreenState();
}

class _PassengerReviewScreenState extends State<PassengerReviewScreen> {
  double rating = 5;
  final selectedTags = <String>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar motorista'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=15'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Ana Martins',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Chip(
                    label: Text('Elétrico / Híbrido'),
                    avatar: Icon(Icons.energy_savings_leaf, size: 18),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Como foi o trajeto?',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: rating,
                min: 1,
                max: 5,
                divisions: 8,
                label: rating.toStringAsFixed(1),
                onChanged: (value) => setState(() => rating = value),
              ),
              Wrap(
                spacing: 8,
                children: const [
                  _CriteriaChip(label: 'Direção segura'),
                  _CriteriaChip(label: 'Pontualidade'),
                  _CriteriaChip(label: 'Simpatia'),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Marque os pontos fortes desta carona:',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Climatização excelente',
                  'Conversa agradável',
                  'Rota eficiente',
                  'Carro confortável',
                  'Playlist colaborativa',
                ].map(
                      (item) => ChoiceChip(
                    label: Text(item),
                    selected: selectedTags.contains(item),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        selectedTags.add(item);
                      } else {
                        selectedTags.remove(item);
                      }
                    }),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 24),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Deixe um feedback para a motorista',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: true,
                onChanged: (_) {},
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Compartilhar elogio com o RH e time ESG'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Enviar avaliação'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CriteriaChip extends StatelessWidget {
  const _CriteriaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}