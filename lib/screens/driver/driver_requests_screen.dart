import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';
import '../../models/driver_ride_request.dart';
import '../../services/driver_requests_service.dart';
import '../../widgets/section_header.dart';

class DriverRequestsScreen extends StatefulWidget {
  const DriverRequestsScreen({super.key});

  @override
  State<DriverRequestsScreen> createState() => _DriverRequestsScreenState();
}

class _DriverRequestsScreenState extends State<DriverRequestsScreen> {
  final DriverRequestsService _service = DriverRequestsService();

  List<DriverRideRequest> _requests = const <DriverRideRequest>[];
  bool _isLoading = true;
  String? _errorMessage;
  String? _processingRequestId;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final requests = await _service.fetchRideRequests();
      setState(() {
        _requests = requests;
      });
    } on DriverRequestsException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Não foi possível carregar as solicitações.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openMapsLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link inválido para o Google Maps.'),
        ),
      );
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o Google Maps.'),
        ),
      );
    }
  }

  Future<void> _respondToRequest(
    BuildContext context,
    DriverRideRequest request,
    bool accept,
  ) async {
    setState(() {
      _processingRequestId = request.id;
    });

    try {
      await _service.respondToRequest(
        requestId: request.id,
        accept: accept,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _requests =
            _requests.where((element) => element.id != request.id).toList();
        _processingRequestId = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accept
                ? 'Solicitação aceita com sucesso!'
                : 'Solicitação rejeitada com sucesso.',
          ),
        ),
      );
    } on DriverRequestsException catch (error) {
      setState(() {
        _processingRequestId = null;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      setState(() {
        _processingRequestId = null;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar a solicitação.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitações de carona'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadRequests,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Novas solicitações',
                subtitle: 'Analise perfil e histórico antes de aceitar.',
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (_isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (_errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadRequests,
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (_requests.isEmpty) {
                      return const Center(
                        child: Text('Não há solicitações pendentes.'),
                      );
                    }

                    return ListView.separated(
                      itemCount: _requests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final request = _requests[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage(request.photoUrl),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request.passengerName,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Saída ${request.time} • ${request.origin}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: AppColors.lightSlate,
                                        ),
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
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(.04),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.compare_arrows,
                                          color: AppColors.primaryBlue),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tipo de carona',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: AppColors.lightSlate,
                                              ),
                                            ),
                                            Text(
                                              request.rideType,
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () =>
                                        _openMapsLink(context, request.mapsUrl),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          color: AppColors.primaryBlue),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Endereço do passageiro',
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: AppColors.lightSlate,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  request.address,
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    height: 1.4,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Abrir no Google Maps',
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color:
                                                        AppColors.primaryBlue,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.open_in_new,
                                              size: 18,
                                              color: AppColors.primaryBlue),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _processingRequestId == request.id
                                        ? null
                                        : () => _respondToRequest(
                                              context,
                                              request,
                                              false,
                                            ),
                                    child: _processingRequestId == request.id
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Text('Rejeitar'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _processingRequestId == request.id
                                        ? null
                                        : () => _respondToRequest(
                                              context,
                                              request,
                                              true,
                                            ),
                                    child: _processingRequestId == request.id
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Text('Aceitar'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}