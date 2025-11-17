import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/user_profile.dart';
import '../../routes.dart';
import '../../services/profile_service.dart';
import '../../widgets/section_header.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  late final ProfileService _profileService;
  bool _isLoading = true;
  String? _error;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await _profileService.fetchUserProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } on ProfileException catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Não foi possível carregar os dados. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo à ShareRoute'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? _ErrorState(message: _error!, onRetry: _fetchProfile)
                  : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final profile = _profile;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    final roleCards = _buildRoleCards(profile);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Escolha como quer participar hoje',
            subtitle: 'Suas opções refletem as preferências salvas no perfil.',
          ),
          const SizedBox(height: 16),
          if (roleCards.isEmpty)
            _EmptyRolesState(onNavigateToProfile: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            })
          else
            ...List.generate(
              roleCards.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == roleCards.length - 1 ? 0 : 16,
                ),
                child: roleCards[index],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRoleCards(UserProfile profile) {
    final modes = profile.formasUso.toSet();
    final cards = <Widget>[];

    if (modes.contains(ParticipationMode.driver)) {
      cards.add(
        _RoleCard(
          title: 'Sou motorista',
          description:
              'Crie rotas, aprove vagas disponíveis e acompanhe solicitações em tempo real.',
          icon: Icons.directions_car_filled,
          color: AppColors.primaryBlue,
          onTap: () => Navigator.pushNamed(context, AppRoutes.driverRoutes),
          quickActions: [
            _QuickAction(
              icon: Icons.add_circle_outline,
              label: 'Criar rota',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.driverRoutes),
            ),
            _QuickAction(
              icon: Icons.mark_chat_unread_outlined,
              label: 'Ver solicitações',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.driverRequests),
            ),
            _QuickAction(
              icon: Icons.directions_car_filled_outlined,
              label: 'Carona ativa',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.driverActiveRide),
            ),
          ],
        ),
      );
    }

    if (modes.contains(ParticipationMode.passenger)) {
      cards.add(
        _RoleCard(
          title: 'Sou passageiro',
          description:
              'Encontre motoristas, acompanhe aprovação e mantenha contato com o time.',
          icon: Icons.emoji_people_outlined,
          color: AppColors.accentGreen,
          onTap: () => Navigator.pushNamed(context, AppRoutes.passengerSearch),
          quickActions: [
            _QuickAction(
              icon: Icons.search,
              label: 'Buscar carona',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.passengerSearch),
            ),
            _QuickAction(
              icon: Icons.check_circle_outline,
              label: 'Ver carona aprovada',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.passengerApproved),
            ),
            _QuickAction(
              icon: Icons.star_border,
              label: 'Avaliar motorista',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.passengerReview),
            ),
          ],
        ),
      );
    }

    return cards
        .map(
          (card) => SizedBox(
            width: double.infinity,
            child: card,
          ),
        )
        .toList();
  }
}

class _EmptyRolesState extends StatelessWidget {
  const _EmptyRolesState({required this.onNavigateToProfile});

  final VoidCallback onNavigateToProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Atualize suas preferências',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escolha no perfil se deseja participar como motorista, passageiro ou ambos.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.lightSlate),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onNavigateToProfile,
            icon: const Icon(Icons.person_outline),
            label: const Text('Ir para o perfil'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.quickActions,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final List<_QuickAction> quickActions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.lightSlate),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: quickActions
                    .map(
                      (action) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: OutlinedButton.icon(
                      onPressed: action.onPressed,
                      icon: Icon(action.icon),
                      label: Text(action.label),
                    ),
                  ),
                )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  _QuickAction({required this.icon, required this.label, required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
}