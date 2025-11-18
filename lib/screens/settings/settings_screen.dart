import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../routes.dart';
import '../../widgets/section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações e suporte'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SectionHeader(
              title: 'Perfil',
            ),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=22'),
                ),
                title: const Text('Thiago Almeida'),
                subtitle: const Text('Inovação • ShareRoute HQ'),
                trailing: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.profile),
                  child: const Text('Editar'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Preferências de bônus'),
            Card(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: true,
                    onChanged: (_) {},
                    title: const Text('Vouchers de combustível'),
                    subtitle: const Text('Priorizar recompensas mensais.'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile.adaptive(
                    value: false,
                    onChanged: (_) {},
                    title: const Text('Cashback sustentável'),
                    subtitle: const Text('Receba pontos extras por rotas completas.'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile.adaptive(
                    value: true,
                    onChanged: (_) {},
                    title: const Text('Vaga preferencial no estacionamento'),
                    subtitle: const Text('Disponível após 12 caronas mensais.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Histórico'),
            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Histórico de caronas'),
                    subtitle: Text('Veja estatísticas e emissões evitadas.'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(Icons.bar_chart_outlined),
                    title: Text('Impacto ESG'),
                    subtitle: Text('Resultados individuais e do time.'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Ajuda e segurança'),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.shield_outlined),
                    title: Text('Central de segurança'),
                    subtitle: Text('Protocolos e contatos de emergência.'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Ajuda e FAQ'),
                    subtitle:
                        const Text('Tire dúvidas sobre rotas e benefícios.'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.onboarding,
                      arguments: true,
                    ),
                  ),
                  const Divider(height: 0),
                  const ListTile(
                    leading: Icon(Icons.privacy_tip_outlined),
                    title: Text('Política de privacidade'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.primaryBlue,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Sair',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Encerrar sessão com segurança',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}