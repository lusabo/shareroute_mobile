import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../widgets/rating_stars.dart';

class PassengerRequestScreen extends StatelessWidget {
  const PassengerRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar solicitação'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
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
                        const SizedBox(height: 4),
                        RatingStars(rating: 4.9),
                        Text(
                          '132 caronas concluídas • Híbrido',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: AppColors.lightSlate),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Regras da carona',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...[
                      'Chegar 5 minutos antes do horário combinado.',
                      'Uso de máscara opcional, respeitando preferências.',
                      'Playlist colaborativa aceita sugestões.',
                      'Bagagens pequenas são bem-vindas.',
                    ].map(
                          (rule) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.accentGreen),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                rule,
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
              const SizedBox(height: 24),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Mensagem para a motorista',
                  hintText: 'Ex.: Meu horário é pontual, posso dividir pedágio.',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.confirmation_number_outlined, color: AppColors.primaryBlue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ao enviar a solicitação, seus dados ficam visíveis apenas após a aprovação.',
                      style: TextStyle(color: AppColors.lightSlate),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Enviar solicitação'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}