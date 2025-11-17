import 'package:flutter/material.dart';

import '../../models/pending_driver_review.dart';
import 'driver_evaluation_screen.dart';

class PassengerReviewScreen extends StatefulWidget {
  const PassengerReviewScreen({super.key});

  @override
  State<PassengerReviewScreen> createState() => _PassengerReviewScreenState();
}

class _PassengerReviewScreenState extends State<PassengerReviewScreen> {
  late final List<PendingDriverReview> _pendingReviews = [
    const PendingDriverReview(
      rideId: 'ride_8721',
      driverId: 'driver_ana',
      driverName: 'Ana Martins',
      avatarUrl: 'https://i.pravatar.cc/100?img=15',
      rideSummary: 'Saída do escritório · Ontem às 18h10',
    ),
    const PendingDriverReview(
      rideId: 'ride_8722',
      driverId: 'driver_juliana',
      driverName: 'Juliana Costa',
      avatarUrl: 'https://i.pravatar.cc/100?img=32',
      rideSummary: 'Trajeto Vila Olímpia → Itaim · Segunda-feira',
    ),
    const PendingDriverReview(
      rideId: 'ride_8723',
      driverId: 'driver_camila',
      driverName: 'Camila Duarte',
      avatarUrl: 'https://i.pravatar.cc/100?img=47',
      rideSummary: 'Retorno para casa · Semana passada',
    ),
  ];

  void _openReview(PendingDriverReview review) async {
    final submitted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DriverEvaluationScreen(candidate: review),
      ),
    );

    if (submitted == true && mounted) {
      setState(() {
        _pendingReviews.removeWhere((item) => item.rideId == review.rideId);
      });
    }
  }

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
              Text(
                'Motoristas aguardando avaliação',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Escolha um motorista para registrar o feedback da última carona.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _pendingReviews.isEmpty
                    ? _ReviewEmptyState(onSkip: () => Navigator.pop(context))
                    : ListView.separated(
                        itemCount: _pendingReviews.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final review = _pendingReviews[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(review.avatarUrl),
                              ),
                              title: Text(
                                review.driverName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  review.rideSummary,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _openReview(review),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Não avaliar agora'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewEmptyState extends StatelessWidget {
  const _ReviewEmptyState({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_people_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Você está em dia com as avaliações!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Assim que finalizar novas caronas, os motoristas aparecerão aqui.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onSkip,
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
