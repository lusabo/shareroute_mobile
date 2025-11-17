import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../widgets/section_header.dart';

class PassengerApprovedRideScreen extends StatelessWidget {
  const PassengerApprovedRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatMessages = _sampleMessages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carona aprovada'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DriverSummary(theme: theme),
              const SizedBox(height: 24),
              Text(
                'Chat com a motorista',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.midnightBlue,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 360,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(.03),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: chatMessages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final message = chatMessages[index];
                      return _ChatBubble(message: message);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _ChatInput(theme: theme),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriverSummary extends StatelessWidget {
  const _DriverSummary({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/200?img=15'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ana Martins',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Toyota Corolla Híbrido • Azul',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.directions_car, size: 18, color: AppColors.primaryBlue),
                      SizedBox(width: 6),
                      Text(
                        'Motorista',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Notificações recentes'),
            const SizedBox(height: 12),
            const _NotificationTile(
              title: 'Embarque confirmado',
              description: 'Ana confirmou sua presença. Chegue 5 minutos antes.',
              time: 'Há 10 minutos',
            ),
            const SizedBox(height: 12),
            const _NotificationTile(
              title: 'Benefício desbloqueado',
              description: 'Você ganhou 10 pts no clube de benefícios ESG.',
              time: 'Ontem',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirmar embarque agora'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.description,
    required this.time,
  });

  final String title;
  final String description;
  final String time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.midnightBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.midnightBlue.withOpacity(.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: AppColors.slateGray),
              const SizedBox(width: 6),
              Text(
                time,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.slateGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment = message.isDriver ? Alignment.centerLeft : Alignment.centerRight;
    final bubbleColor = message.isDriver
        ? AppColors.primaryBlue.withOpacity(.1)
        : AppColors.accentGreen.withOpacity(.15);
    final textColor = message.isDriver ? AppColors.midnightBlue : AppColors.midnightBlue;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(message.isDriver ? 4 : 18),
              bottomRight: Radius.circular(message.isDriver ? 18 : 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment:
                  message.isDriver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  message.isDriver ? 'Ana' : 'Bruno',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.slateGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message.content,
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 6),
                Text(
                  message.time,
                  style: const TextStyle(
                    color: AppColors.slateGray,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.slateGray.withOpacity(.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.emoji_emotions_outlined, color: AppColors.slateGray),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Escreva uma mensagem...',
                border: InputBorder.none,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.slateGray),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue,
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.content,
    required this.time,
    required this.isDriver,
  });

  final String content;
  final String time;
  final bool isDriver;
}

List<_ChatMessage> _sampleMessages() {
  return const [
    _ChatMessage(
      content: 'Oi Bruno! Tudo bem? Posso te encontrar na entrada B da Torre?',
      time: '07:02',
      isDriver: true,
    ),
    _ChatMessage(
      content: 'Oi Ana! Claro, fico ali próximo ao café a partir das 7h05.',
      time: '07:03',
      isDriver: false,
    ),
    _ChatMessage(
      content: 'Perfeito. Saio de casa agora às 7h e devo chegar aí por volta das 7h10.',
      time: '07:04',
      isDriver: true,
    ),
    _ChatMessage(
      content: 'Combinado, levo um guarda-chuva se estiver garoando. Até já!',
      time: '07:05',
      isDriver: false,
    ),
  ];
}
