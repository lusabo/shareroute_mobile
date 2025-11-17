import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';
import '../../models/driver_active_ride.dart';
import '../../models/ride_direction.dart';
import '../../services/driver_active_ride_service.dart';
import '../../widgets/section_header.dart';

class DriverActiveRideScreen extends StatefulWidget {
  const DriverActiveRideScreen({super.key});

  @override
  State<DriverActiveRideScreen> createState() => _DriverActiveRideScreenState();
}

class _DriverActiveRideScreenState extends State<DriverActiveRideScreen> {
  late final DriverActiveRideService _service;
  late Future<DriverActiveRide> _activeRideFuture;

  @override
  void initState() {
    super.initState();
    _service = DriverActiveRideService();
    _activeRideFuture = _service.fetchActiveRide();
  }

  Future<void> _refreshRide() {
    setState(() {
      _activeRideFuture = _service.fetchActiveRide();
    });
    return _activeRideFuture;
  }

  Future<void> _openMapsLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnackBar('Não foi possível abrir o mapa.');
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      _showSnackBar('Falha ao abrir o Google Maps.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openChatModal(ActiveRidePassenger passenger) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PassengerChatModal(passenger: passenger),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carona ativa'),
        actions: [
          IconButton(
            onPressed: () => _refreshRide(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<DriverActiveRide>(
            future: _activeRideFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                final error = snapshot.error;
                final message = error is DriverActiveRideException
                    ? error.message
                    : 'Não foi possível carregar a carona ativa. Tente novamente.';
                return _ErrorState(
                  onRetry: () => _refreshRide(),
                  message: message,
                );
              }

              if (!snapshot.hasData) {
                return _ErrorState(
                  onRetry: () => _refreshRide(),
                  message: 'Não encontramos informações da carona ativa.',
                );
              }

              final ride = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshRide,
                      color: AppColors.primaryBlue,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          _RideDirectionCard(
                            direction: ride.direction,
                            passengerCount: ride.passengers.length,
                          ),
                          const SizedBox(height: 24),
                          const SectionHeader(
                            title: 'Passageiros confirmados',
                            subtitle: 'Confira o endereço e abra o chat rapidamente.',
                          ),
                          const SizedBox(height: 12),
                          if (ride.passengers.isEmpty)
                            const _EmptyPassengersState()
                          else
                            ...ride.passengers.map(
                              (passenger) => _PassengerTile(
                                passenger: passenger,
                                onOpenMap: () => _openMapsLink(passenger.googleMapsUrl),
                                onOpenChat: () => _openChatModal(passenger),
                              ),
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.flag_outlined),
                      label: const Text('Encerrar rota com segurança'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RideDirectionCard extends StatelessWidget {
  const _RideDirectionCard({
    required this.direction,
    required this.passengerCount,
  });

  final RideDirection direction;
  final int passengerCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.directions_car_filled, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    direction.label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Passageiros confirmados: $passengerCount',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightSlate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassengerTile extends StatelessWidget {
  const _PassengerTile({
    required this.passenger,
    required this.onOpenChat,
    required this.onOpenMap,
  });

  final ActiveRidePassenger passenger;
  final VoidCallback onOpenChat;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryBlue.withOpacity(.1),
                  backgroundImage:
                      passenger.avatarUrl.isNotEmpty ? NetworkImage(passenger.avatarUrl) : null,
                  child: passenger.avatarUrl.isEmpty
                      ? const Icon(Icons.person, color: AppColors.primaryBlue)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        passenger.address,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightSlate,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onOpenMap,
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Mapa'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onOpenChat,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
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

class _EmptyPassengersState extends StatelessWidget {
  const _EmptyPassengersState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Nenhum passageiro confirmado ainda',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Assim que um passageiro confirmar a presença ele aparecerá aqui.',
            style: TextStyle(color: AppColors.lightSlate),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry, required this.message});

  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 48, color: AppColors.lightSlate),
          const SizedBox(height: 12),
          Text(
            'Ops! Algo deu errado',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.lightSlate),
            ),
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

class PassengerChatModal extends StatefulWidget {
  const PassengerChatModal({super.key, required this.passenger});

  final ActiveRidePassenger passenger;

  @override
  State<PassengerChatModal> createState() => _PassengerChatModalState();
}

class _PassengerChatModalState extends State<PassengerChatModal> {
  late final List<PassengerChatMessage> _messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = List.of(widget.passenger.chatHistory);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(PassengerChatMessage(content: text, fromDriver: true));
    });
    _messageController.clear();
    FocusScope.of(context).unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: mediaQuery.viewInsets.bottom + 24,
      ),
      child: SizedBox(
        height: mediaQuery.size.height * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightSlate.withOpacity(.4),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryBlue.withOpacity(.1),
                  backgroundImage: widget.passenger.avatarUrl.isNotEmpty
                      ? NetworkImage(widget.passenger.avatarUrl)
                      : null,
                  child: widget.passenger.avatarUrl.isEmpty
                      ? const Icon(Icons.person, color: AppColors.primaryBlue)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.passenger.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Canal direto para avisos rápidos.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.lightSlate),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.softWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => _ChatBubble(
                    message: _messages[index],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escreva uma mensagem...',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _sendMessage,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    minimumSize: const Size(56, 56),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final PassengerChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isDriver = message.fromDriver;
    return Align(
      alignment: isDriver ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDriver ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isDriver ? Colors.white : AppColors.midnightBlue,
          ),
        ),
      ),
    );
  }
}
