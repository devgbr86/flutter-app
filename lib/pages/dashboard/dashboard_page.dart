import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Status do motoboy (Online/Offline)
  bool _isOnline = false;

  // Dados simulados para os indicadores
  final int _corridasHoje = 12;
  final int _corridasTotal = 248;
  final double _ganhoHoje = 385.50;
  final double _ganhoMes = 4250.00;
  final double _avaliacao = 4.8;

  void _navegarPara(String rota) {
    Navigator.pushNamed(context, rota);
  }

  void _toggleStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isOnline
              ? '🟢 Você está ONLINE - Pronto para receber corridas!'
              : '🔴 Você está OFFLINE - Não receberá novas corridas',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: _isOnline ? Colors.green : Colors.red,
      ),
    );
  }

  void _sair() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sair do App'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          'Motoboy 8K',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _sair,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com gradiente
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Avatar e nome
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.delivery_dining,
                      size: 50,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Olá, Motoboy!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gerencie suas entregas e corridas',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botão Online/Offline
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _toggleStatus,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _isOnline ? Colors.green : Colors.red.shade400,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: (_isOnline ? Colors.green : Colors.red)
                                  .withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _isOnline ? 'ONLINE' : 'OFFLINE',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _isOnline
                                  ? Icons.touch_app
                                  : Icons.power_settings_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cards de Indicadores
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumo de Hoje',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Grid de indicadores
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildIndicadorCard(
                        'Entregas Hoje',
                        '$_corridasHoje',
                        Icons.delivery_dining,
                        Colors.blue,
                      ),
                      _buildIndicadorCard(
                        'Ganho Hoje',
                        'R\$ ${_ganhoHoje.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.green,
                      ),
                      _buildIndicadorCard(
                        'Total Entregas',
                        '$_corridasTotal',
                        Icons.check_circle,
                        Colors.purple,
                      ),
                      _buildIndicadorCard(
                        'Avaliação',
                        '$_avaliacao ⭐',
                        Icons.star,
                        Colors.amber,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Card Ganho do Mês
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Faturamento do Mês',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'R\$ ${_ganhoMes.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Ações Rápidas
                  const Text(
                    'Ações Rápidas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Grid de Botões
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _buildMenuCard(
                        'Cadastro',
                        'Gerenciar meu perfil',
                        Icons.person_add,
                        Colors.orange,
                        () => _navegarPara('/cadastro'),
                      ),
                      _buildMenuCard(
                        'Buscar',
                        'Procurar entregas',
                        Icons.search,
                        Colors.blue,
                        () => _navegarPara('/buscar'),
                      ),
                      _buildMenuCard(
                        'Histórico',
                        'Entregas realizadas',
                        Icons.history,
                        Colors.purple,
                        () => _navegarPara('/historico'),
                      ),
                      _buildMenuCard(
                        'Listagem',
                        'Contatos favoritos',
                        Icons.list_alt,
                        Colors.green,
                        () => _navegarPara('/listagem'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Botão Configurações (full width)
                  _buildFullWidthMenuCard(
                    'Configurações',
                    'Ajustes e preferências do aplicativo',
                    Icons.settings,
                    Colors.grey.shade700,
                    () => _navegarPara('/config'),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicadorCard(
    String titulo,
    String valor,
    IconData icone,
    Color cor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, color: cor, size: 32),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    String titulo,
    String subtitulo,
    IconData icone,
    Color cor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icone, color: cor, size: 32),
            ),
            const SizedBox(height: 8),
            Text(
              titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthMenuCard(
    String titulo,
    String subtitulo,
    IconData icone,
    Color cor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icone, color: cor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
