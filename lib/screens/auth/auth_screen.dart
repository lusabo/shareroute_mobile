import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app_theme.dart';
import '../../routes.dart';
import '../../services/app_preferences.dart';
import '../../services/auth_service.dart';

enum _AuthStage { requestCode, verifyCode }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _requestFormKey = GlobalKey<FormState>();
  final _verifyFormKey = GlobalKey<FormState>();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  _AuthStage _stage = _AuthStage.requestCode;
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentRegistration;

  static const _tokenStorageKey = 'auth_token';

  @override
  void dispose() {
    _registrationController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Entre sem senha',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Use sua matrícula corporativa para receber um código de acesso seguro.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.lightSlate),
              ),
              const SizedBox(height: 24),
              _buildErrorMessage(),
              const SizedBox(height: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _stage == _AuthStage.requestCode
                      ? _RequestCodeForm(
                          key: const ValueKey('request-stage'),
                          isLoading: _isLoading,
                          controller: _registrationController,
                          formKey: _requestFormKey,
                          onSubmit: _handleRequestCode,
                        )
                      : _VerifyCodeForm(
                          key: const ValueKey('verify-stage'),
                          isLoading: _isLoading,
                          controller: _codeController,
                          formKey: _verifyFormKey,
                          registration: _currentRegistration ?? '',
                          onSubmit: _handleVerifyCode,
                          onBack: _backToRegistration,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _errorMessage == null
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withOpacity(.24)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _handleRequestCode() async {
    if (_isLoading) return;
    final formState = _requestFormKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final registration = _registrationController.text.trim();

    try {
      await _authService.requestCode(registration);
      if (!mounted) return;
      _codeController.clear();
      setState(() {
        _stage = _AuthStage.verifyCode;
        _currentRegistration = registration;
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enviamos um código para o seu e-mail corporativo.'),
        ),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Não foi possível solicitar o código agora. Tente novamente.';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleVerifyCode() async {
    if (_isLoading) return;
    final formState = _verifyFormKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final registration =
        _currentRegistration ?? _registrationController.text.trim();
    final code = _codeController.text.trim();

    try {
      final token = await _authService.verifyCode(
        registration: registration,
        code: code,
      );
      await _secureStorage.write(key: _tokenStorageKey, value: token);
      final hasCompletedProfile =
          await AppPreferences.hasCompletedProfileSetup();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Autenticação realizada com sucesso!')),
      );
      final nextRoute =
          hasCompletedProfile ? AppRoutes.home : AppRoutes.profile;
      Navigator.pushReplacementNamed(context, nextRoute);
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Não foi possível validar o código. Tente novamente.';
        _isLoading = false;
      });
    }
  }

  void _backToRegistration() {
    if (_isLoading) {
      return;
    }
    setState(() {
      _stage = _AuthStage.requestCode;
      _errorMessage = null;
    });
  }
}

class _RequestCodeForm extends StatelessWidget {
  const _RequestCodeForm({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.formKey,
    required this.onSubmit,
  });

  final bool isLoading;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Matrícula',
                hintText: 'Ex.: 123456',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Informe sua matrícula corporativa';
                }
                if (!RegExp(r'^[0-9]{4,}$').hasMatch(trimmed)) {
                  return 'Use apenas números válidos';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enviar código'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifyCodeForm extends StatelessWidget {
  const _VerifyCodeForm({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.formKey,
    required this.registration,
    required this.onSubmit,
    required this.onBack,
  });

  final bool isLoading;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final String registration;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verifique o código',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enviamos um código de 6 dígitos para o e-mail vinculado à matrícula $registration.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.lightSlate),
                  ),
                  TextButton(
                    onPressed: isLoading ? null : onBack,
                    child: const Text('Alterar matrícula'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Código de verificação',
                hintText: '000000',
                prefixIcon: Icon(Icons.shield_outlined),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Informe o código recebido por e-mail';
                }
                if (!RegExp(r'^[0-9]{6}$').hasMatch(trimmed)) {
                  return 'O código deve ter 6 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
