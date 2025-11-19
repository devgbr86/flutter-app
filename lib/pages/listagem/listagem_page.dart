import 'package:flutter/material.dart';

class ListagemPage extends StatefulWidget {
  const ListagemPage({super.key});

  @override
  State<ListagemPage> createState() => _ListagemPageState();
}

class _ListagemPageState extends State<ListagemPage> {
  // Lista de motoboys favoritos (mock data)
  final List<Map<String, dynamic>> motoboys = [
    {
      'nome': 'João Silva',
      'veiculo': 'Moto',
      'modelo': 'Honda CG 160',
      'avaliacao': 4.9,
      'corridas': 156,
      'foto': '👤',
    },
    {
      'nome': 'Maria Santos',
      'veiculo': 'Carro',
      'modelo': 'Fiat Uno',
      'avaliacao': 4.7,
      'corridas': 89,
      'foto': '👤',
    },
    {
      'nome': 'Pedro Costa',
      'veiculo': 'Moto',
      'modelo': 'Yamaha Factor',
      'avaliacao': 4.8,
      'corridas': 203,
      'foto': '👤',
    },
    {
      'nome': 'Ana Oliveira',
      'veiculo': 'Bicicleta',
      'modelo': 'Caloi Elite',
      'avaliacao': 5.0,
      'corridas': 45,
      'foto': '👤',
    },
  ];

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
          'Meus Motoboys',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implementar busca
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header com informações
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
                Text(
                  '${motoboys.length} Motoboys Favoritos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Seus contatos frequentes',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Lista de motoboys
          Expanded(
            child: motoboys.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum motoboy adicionado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicione seus motoboys favoritos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: motoboys.length,
                    itemBuilder: (context, index) {
                      final motoboy = motoboys[index];
                      return _buildMotoboyCard(motoboy);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Adicionar novo motoboy
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Função de adicionar motoboy em desenvolvimento'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildMotoboyCard(Map<String, dynamic> motoboy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showMotoboyDetails(motoboy);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      motoboy['foto'],
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Informações
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        motoboy['nome'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _getVehicleIcon(motoboy['veiculo']),
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            motoboy['modelo'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${motoboy['avaliacao']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.delivery_dining,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${motoboy['corridas']} corridas',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Botões de ação
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.orange),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ligando para ${motoboy['nome']}...'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red[400]),
                      onPressed: () {
                        _removeMotoboy(motoboy['nome']);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getVehicleIcon(String veiculo) {
    switch (veiculo.toLowerCase()) {
      case 'moto':
        return Icons.two_wheeler;
      case 'carro':
        return Icons.directions_car;
      case 'bicicleta':
        return Icons.pedal_bike;
      default:
        return Icons.local_shipping;
    }
  }

  void _showMotoboyDetails(Map<String, dynamic> motoboy) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    motoboy['foto'],
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                motoboy['nome'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${motoboy['veiculo']} - ${motoboy['modelo']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    Icons.star,
                    '${motoboy['avaliacao']}',
                    'Avaliação',
                    Colors.amber,
                  ),
                  _buildStatCard(
                    Icons.delivery_dining,
                    '${motoboy['corridas']}',
                    'Corridas',
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ligando para ${motoboy['nome']}...'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Ligar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Navegar para buscar_page com motoboy pré-selecionado
                      },
                      icon: const Icon(Icons.delivery_dining),
                      label: const Text('Solicitar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _removeMotoboy(String nome) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Motoboy'),
        content: Text('Deseja remover $nome da sua lista de favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                motoboys.removeWhere((m) => m['nome'] == nome);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$nome removido da lista'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
