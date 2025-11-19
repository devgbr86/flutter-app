import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool notificacoesAtivas = true;
  bool notificacoesSom = true;
  bool notificacoesVibracao = true;
  bool modoEscuro = false;
  String idiomaAtual = 'Português';
  bool compartilharLocalizacao = true;
  bool mostrarHistorico = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.settings,
                    size: 50,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Personalize seu aplicativo',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Seção: Notificações
            _buildSectionTitle('Notificações'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.notifications_active,
                title: 'Notificações',
                subtitle: 'Receber notificações do app',
                value: notificacoesAtivas,
                onChanged: (value) {
                  setState(() => notificacoesAtivas = value);
                },
              ),
              if (notificacoesAtivas) ...[
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.volume_up,
                  title: 'Som',
                  subtitle: 'Notificações com som',
                  value: notificacoesSom,
                  onChanged: (value) {
                    setState(() => notificacoesSom = value);
                  },
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.vibration,
                  title: 'Vibração',
                  subtitle: 'Notificações com vibração',
                  value: notificacoesVibracao,
                  onChanged: (value) {
                    setState(() => notificacoesVibracao = value);
                  },
                ),
              ],
            ]),

            const SizedBox(height: 16),

            // Seção: Aparência
            _buildSectionTitle('Aparência'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.dark_mode,
                title: 'Modo Escuro',
                subtitle: 'Tema escuro do aplicativo',
                value: modoEscuro,
                onChanged: (value) {
                  setState(() => modoEscuro = value);
                  _showSnackBar(
                    'Modo escuro ${value ? "ativado" : "desativado"}',
                  );
                },
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.language,
                title: 'Idioma',
                subtitle: idiomaAtual,
                onTap: () => _showIdiomaDialog(),
              ),
            ]),

            const SizedBox(height: 16),

            // Seção: Privacidade
            _buildSectionTitle('Privacidade e Segurança'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.location_on,
                title: 'Compartilhar Localização',
                subtitle: 'Permitir acesso à localização',
                value: compartilharLocalizacao,
                onChanged: (value) {
                  setState(() => compartilharLocalizacao = value);
                },
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.history,
                title: 'Mostrar Histórico',
                subtitle: 'Exibir histórico de corridas',
                value: mostrarHistorico,
                onChanged: (value) {
                  setState(() => mostrarHistorico = value);
                },
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.lock,
                title: 'Alterar Senha',
                subtitle: 'Gerenciar senha da conta',
                onTap: () => _showSnackBar('Função em desenvolvimento'),
              ),
            ]),

            const SizedBox(height: 16),

            // Seção: Conta
            _buildSectionTitle('Conta'),
            _buildSettingsCard([
              _buildNavigationTile(
                icon: Icons.person,
                title: 'Editar Perfil',
                subtitle: 'Atualizar informações pessoais',
                onTap: () => _showSnackBar('Função em desenvolvimento'),
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.credit_card,
                title: 'Formas de Pagamento',
                subtitle: 'Gerenciar métodos de pagamento',
                onTap: () => _showSnackBar('Função em desenvolvimento'),
              ),
            ]),

            const SizedBox(height: 16),

            // Seção: Suporte
            _buildSectionTitle('Suporte'),
            _buildSettingsCard([
              _buildNavigationTile(
                icon: Icons.help_outline,
                title: 'Central de Ajuda',
                subtitle: 'FAQ e tutoriais',
                onTap: () => _showSnackBar('Abrindo Central de Ajuda...'),
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.chat_bubble_outline,
                title: 'Fale Conosco',
                subtitle: 'Entre em contato com o suporte',
                onTap: () => _showSnackBar('Abrindo chat de suporte...'),
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.star_outline,
                title: 'Avaliar App',
                subtitle: 'Deixe sua avaliação',
                onTap: () => _showRatingDialog(),
              ),
            ]),

            const SizedBox(height: 16),

            // Seção: Sobre
            _buildSectionTitle('Sobre'),
            _buildSettingsCard([
              _buildNavigationTile(
                icon: Icons.info_outline,
                title: 'Sobre o App',
                subtitle: 'Versão 1.0.0',
                onTap: () => _showAboutDialog(),
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.description,
                title: 'Termos de Uso',
                subtitle: 'Política de uso do aplicativo',
                onTap: () => _showSnackBar('Abrindo Termos de Uso...'),
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Política de Privacidade',
                subtitle: 'Como tratamos seus dados',
                onTap: () =>
                    _showSnackBar('Abrindo Política de Privacidade...'),
              ),
            ]),

            const SizedBox(height: 16),

            // Botão de Sair
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      'Sair da Conta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.orange, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.orange,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.orange, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 60,
      endIndent: 16,
      color: Colors.grey[200],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showIdiomaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIdiomaOption('Português'),
            _buildIdiomaOption('English'),
            _buildIdiomaOption('Español'),
          ],
        ),
      ),
    );
  }

  Widget _buildIdiomaOption(String idioma) {
    return RadioListTile<String>(
      title: Text(idioma),
      value: idioma,
      groupValue: idiomaAtual,
      activeColor: Colors.orange,
      onChanged: (value) {
        setState(() => idiomaAtual = value!);
        Navigator.pop(context);
        _showSnackBar('Idioma alterado para $value');
      },
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Avaliar App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('O que você achou do Motoboy App?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(Icons.star, color: Colors.amber, size: 36),
                  onPressed: () {
                    Navigator.pop(context);
                    _showSnackBar(
                      'Obrigado pela avaliação de ${index + 1} estrelas!',
                    );
                  },
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o Motoboy App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.delivery_dining,
                size: 60,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Motoboy App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Versão 1.0.0', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            Text(
              'O aplicativo que conecta você aos melhores motoboys da sua região de forma rápida e segura.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2025 Motoboy App',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o dialog
              Navigator.pop(context); // Volta para Dashboard
              _showSnackBar('Você saiu da conta');
              // TODO: Implementar logout real e voltar para home_page
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
