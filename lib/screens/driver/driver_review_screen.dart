import 'package:flutter/material.dart';

import '../../app_theme.dart';

class DriverReviewScreen extends StatefulWidget {
  const DriverReviewScreen({super.key});

  @override
  State<DriverReviewScreen> createState() => _DriverReviewScreenState();
}

class _DriverReviewScreenState extends State<DriverReviewScreen> {
  double rating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar passageiro'),
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
                    backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=1'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Mariana Souza',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text('25 caronas juntas'),
                    avatar: Icon(Icons.history, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Como foi a experiência?',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Slider(
                value: rating,
                min: 1,
                max: 5,
                divisions: 8,
                activeColor: AppColors.primaryBlue,
                onChanged: (value) => setState(() => rating = value),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _CriteriaChip(label: 'Pontualidade'),
                  _CriteriaChip(label: 'Cordialidade'),
                  _CriteriaChip(label: 'Segurança'),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Deixe um comentário construtivo',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: true,
                onChanged: (_) {},
                title: const Text('Recomendar para futuras caronas'),
                controlAffinity: ListTileControlAffinity.leading,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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