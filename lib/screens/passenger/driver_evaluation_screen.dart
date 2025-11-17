import 'package:flutter/material.dart';

import '../../models/pending_driver_review.dart';
import '../../models/passenger_review_submission.dart';
import '../../services/passenger_review_service.dart';

class DriverEvaluationScreen extends StatefulWidget {
  const DriverEvaluationScreen({required this.candidate, super.key});

  final PendingDriverReview candidate;

  @override
  State<DriverEvaluationScreen> createState() => _DriverEvaluationScreenState();
}

class _DriverEvaluationScreenState extends State<DriverEvaluationScreen> {
  final PassengerReviewService _reviewService = PassengerReviewService();
  final TextEditingController _feedbackController = TextEditingController();
  final Set<String> _selectedStrengths = {};

  double _rating = 5;
  bool _shareWithRh = true;
  bool _isSubmitting = false;

  final List<String> _strengthOptions = const [
    'Direção segura',
    'Pontualidade',
    'Simpatia',
    'Climatização excelente',
    'Conversa agradável',
    'Rota eficiente',
    'Carro confortável',
    'Playlist colaborativa',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final submission = PassengerReviewSubmission(
      driverId: widget.candidate.driverId,
      rideId: widget.candidate.rideId,
      rating: _rating,
      strengths: _selectedStrengths.toList(),
      comment: _feedbackController.text.trim(),
      shareWithRh: _shareWithRh,
    );

    try {
      await _reviewService.submitReview(submission);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avaliação enviada com sucesso!')),
      );
      Navigator.pop(context, true);
    } on PassengerReviewException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível enviar sua avaliação. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage:
                                NetworkImage(widget.candidate.avatarUrl),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.candidate.driverName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.candidate.rideDate} · ${widget.candidate.rideType.label}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Como foi o trajeto?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        value: _rating,
                        min: 1,
                        max: 5,
                        divisions: 8,
                        label: _rating.toStringAsFixed(1),
                        onChanged: (value) => setState(() => _rating = value),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Marque os pontos fortes desta carona:',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _strengthOptions
                            .map(
                              (option) => ChoiceChip(
                                label: Text(option),
                                selected: _selectedStrengths.contains(option),
                                onSelected: (selected) => setState(() {
                                  if (selected) {
                                    _selectedStrengths.add(option);
                                  } else {
                                    _selectedStrengths.remove(option);
                                  }
                                }),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _feedbackController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Deixe um feedback para a motorista',
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _shareWithRh,
                        onChanged: (value) =>
                            setState(() => _shareWithRh = value ?? true),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text(
                          'Compartilhar elogio com o RH e time ESG',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Enviar avaliação'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Não avaliar agora'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
