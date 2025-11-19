import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({Key? key}) : super(key: key);

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  String _filtroStatus = 'Todos';
  String _ordenacao = 'Mais Recentes';
  final TextEditingController _searchController = TextEditingController();
  String _termoBusca = '';

  // Dados simulados (substituir por dados reais do backend)
  final List<Corrida> _corridas = [
    Corrida(
      id: '001',
      dataHora: DateTime.now().subtract(const Duration(hours: 2)),
      origem: 'Pizzaria Central - Rua das Flores, 123',
      destino: 'Rua do Comércio, 456 - Apto 302',
      valorPago: 15.50,
      status: 'Concluída',
      motoboy: 'João Silva',
      metodoPagamento: 'Dinheiro',
      distancia: 3.2,
    ),
    Corrida(
      id: '002',
      dataHora: DateTime.now().subtract(const Duration(hours: 5)),
      origem: 'Pizzaria Central - Rua das Flores, 123',
      destino: 'Av. Principal, 789 - Casa 5',
      valorPago: 12.00,
      status: 'Concluída',
      motoboy: 'Maria Santos',
      metodoPagamento: 'Pix',
      distancia: 2.5,
    ),
    Corrida(
      id: '003',
      dataHora: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      origem: 'Pizzaria Central - Rua das Flores, 123',
      destino: 'Rua dos Trabalhadores, 321',
      valorPago: 18.00,
      status: 'Concluída',
      motoboy: 'Carlos Oliveira',
      metodoPagamento: 'Cartão',
      distancia: 4.8,
    ),
    Corrida(
      id: '004',
      dataHora: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      origem: 'Pizzaria Central - Rua das Flores, 123',
      destino: 'Rua Nova, 654',
      valorPago: 10.50,
      status: 'Cancelada',
      motoboy: 'João Silva',
      metodoPagamento: 'Dinheiro',
      distancia: 1.8,
      motivoCancelamento: 'Cliente não encontrado',
    ),
    Corrida(
      id: '005',
      dataHora: DateTime.now().subtract(const Duration(days: 2)),
      origem: 'Pizzaria Central - Rua das Flores, 123',
      destino: 'Av. Brasil, 987',
      valorPago: 20.00,
      status: 'Concluída',
      motoboy: 'Pedro Costa',
      metodoPagamento: 'Pix',
      distancia: 5.6,
    ),
    Corrida(
      id: '006',
      dataHora: DateTime.now().subtract(const Duration(days: 3)),
      origem: 'Pizzaria Central - Rua das Flores, 123',
      destino: 'Rua do Porto, 159',
      valorPago: 14.50,
      status: 'Concluída',
      motoboy: 'Ana Paula',
      metodoPagamento: 'Dinheiro',
      distancia: 3.7,
    ),
    Corrida(
      id: '007',
      dataHora: DateTime.now().subtract(const Duration(days: 4)),
      origem: 'Pizzaria Central - Rua das Flores, 123',
      destino: 'Rua das Acácias, 753',
      valorPago: 0.00,
      status: 'Cancelada',
      motoboy: null,
      metodoPagamento: 'Pix',
      distancia: 2.1,
      motivoCancelamento: 'Nenhum motoboy disponível',
    ),
    Corrida(
      id: '008',
      dataHora: DateTime.now().subtract(const Duration(days: 5)),
      origem: 'Pizzaria Central - Rua das Flores, 123',
      destino: 'Rua do Sol, 852',
      valorPago: 16.00,
      status: 'Concluída',
      motoboy: 'Roberto Lima',
      metodoPagamento: 'Cartão',
      distancia: 4.2,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Corrida> get _corridasFiltradas {
    List<Corrida> resultado = _corridas;

    // Filtro por status
    if (_filtroStatus != 'Todos') {
      resultado = resultado.where((c) => c.status == _filtroStatus).toList();
    }

    // Filtro por busca
    if (_termoBusca.isNotEmpty) {
      resultado = resultado.where((c) {
        final termo = _termoBusca.toLowerCase();
        return c.id.toLowerCase().contains(termo) ||
            c.origem.toLowerCase().contains(termo) ||
            c.destino.toLowerCase().contains(termo) ||
            (c.motoboy?.toLowerCase().contains(termo) ?? false);
      }).toList();
    }

    // Ordenação
    if (_ordenacao == 'Mais Recentes') {
      resultado.sort((a, b) => b.dataHora.compareTo(a.dataHora));
    } else if (_ordenacao == 'Mais Antigas') {
      resultado.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    } else if (_ordenacao == 'Maior Valor') {
      resultado.sort((a, b) => b.valorPago.compareTo(a.valorPago));
    } else if (_ordenacao == 'Menor Valor') {
      resultado.sort((a, b) => a.valorPago.compareTo(b.valorPago));
    }

    return resultado;
  }

  Map<String, dynamic> get _estatisticas {
    final concluidas = _corridas.where((c) => c.status == 'Concluída').toList();
    final canceladas = _corridas.where((c) => c.status == 'Cancelada').toList();

    final totalGanho = concluidas.fold<double>(
      0,
      (sum, c) => sum + c.valorPago,
    );
    final distanciaTotal = concluidas.fold<double>(
      0,
      (sum, c) => sum + c.distancia,
    );

    return {
      'total': _corridas.length,
      'concluidas': concluidas.length,
      'canceladas': canceladas.length,
      'totalGanho': totalGanho,
      'distanciaTotal': distanciaTotal,
      'mediaValor': concluidas.isNotEmpty
          ? totalGanho / concluidas.length
          : 0.0,
    };
  }

  void _mostrarDetalhes(Corrida corrida) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Corrida #${corrida.id}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusChip(corrida.status),
                  ],
                ),
                const SizedBox(height: 20),

                _buildDetalheCard(
                  'Data e Hora',
                  DateFormat('dd/MM/yyyy - HH:mm').format(corrida.dataHora),
                  Icons.calendar_today,
                ),

                _buildDetalheCard(
                  'Origem',
                  corrida.origem,
                  Icons.location_on,
                  color: Colors.blue,
                ),

                _buildDetalheCard(
                  'Destino',
                  corrida.destino,
                  Icons.flag,
                  color: Colors.red,
                ),

                _buildDetalheCard(
                  'Distância',
                  '${corrida.distancia.toStringAsFixed(1)} km',
                  Icons.route,
                ),

                if (corrida.motoboy != null)
                  _buildDetalheCard('Motoboy', corrida.motoboy!, Icons.person),

                _buildDetalheCard(
                  'Método de Pagamento',
                  corrida.metodoPagamento,
                  Icons.payment,
                ),

                _buildDetalheCard(
                  'Valor Pago',
                  'R\$ ${corrida.valorPago.toStringAsFixed(2)}',
                  Icons.attach_money,
                  color: Colors.green,
                  isValue: true,
                ),

                if (corrida.motivoCancelamento != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Motivo do Cancelamento',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Text(corrida.motivoCancelamento!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetalheCard(
    String label,
    String valor,
    IconData icon, {
    Color? color,
    bool isValue = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: isValue ? 20 : 14,
                    fontWeight: isValue ? FontWeight.bold : FontWeight.normal,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color cor;
    IconData icone;

    switch (status) {
      case 'Concluída':
        cor = Colors.green;
        icone = Icons.check_circle;
        break;
      case 'Cancelada':
        cor = Colors.red;
        icone = Icons.cancel;
        break;
      default:
        cor = Colors.orange;
        icone = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 16, color: cor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticas() {
    final stats = _estatisticas;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estatísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    stats['total'].toString(),
                    Icons.list_alt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Concluídas',
                    stats['concluidas'].toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Canceladas',
                    stats['canceladas'].toString(),
                    Icons.cancel,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Ganho',
                    'R\$ ${stats['totalGanho'].toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Distância',
                    '${stats['distanciaTotal'].toStringAsFixed(1)} km',
                    Icons.route,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String valor, IconData icon, Color cor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: cor, size: 24),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        children: [
          // Busca
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por ID, endereço ou motoboy...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _termoBusca.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _termoBusca = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _termoBusca = value;
              });
            },
          ),
          const SizedBox(height: 12),

          // Filtros e Ordenação
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filtroStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    prefixIcon: const Icon(Icons.filter_list),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                    DropdownMenuItem(
                      value: 'Concluída',
                      child: Text('Concluídas'),
                    ),
                    DropdownMenuItem(
                      value: 'Cancelada',
                      child: Text('Canceladas'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filtroStatus = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _ordenacao,
                  decoration: InputDecoration(
                    labelText: 'Ordenar',
                    prefixIcon: const Icon(Icons.sort),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Mais Recentes',
                      child: Text('Mais Recentes'),
                    ),
                    DropdownMenuItem(
                      value: 'Mais Antigas',
                      child: Text('Mais Antigas'),
                    ),
                    DropdownMenuItem(
                      value: 'Maior Valor',
                      child: Text('Maior Valor'),
                    ),
                    DropdownMenuItem(
                      value: 'Menor Valor',
                      child: Text('Menor Valor'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _ordenacao = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final corridasFiltradas = _corridasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Corridas'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          _buildEstatisticas(),
          _buildFiltros(),
          Expanded(
            child: corridasFiltradas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma corrida encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: corridasFiltradas.length,
                    itemBuilder: (context, index) {
                      final corrida = corridasFiltradas[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _mostrarDetalhes(corrida),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Corrida #${corrida.id}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    _buildStatusChip(corrida.status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy - HH:mm',
                                  ).format(corrida.dataHora),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const Divider(height: 16),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        corrida.origem,
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.flag,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        corrida.destino,
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (corrida.motoboy != null)
                                      Row(
                                        children: [
                                          const Icon(Icons.person, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            corrida.motoboy!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      const Text(
                                        'Sem motoboy',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    Text(
                                      'R\$ ${corrida.valorPago.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Corrida {
  final String id;
  final DateTime dataHora;
  final String origem;
  final String destino;
  final double valorPago;
  final String status;
  final String? motoboy;
  final String metodoPagamento;
  final double distancia;
  final String? motivoCancelamento;

  Corrida({
    required this.id,
    required this.dataHora,
    required this.origem,
    required this.destino,
    required this.valorPago,
    required this.status,
    this.motoboy,
    required this.metodoPagamento,
    required this.distancia,
    this.motivoCancelamento,
  });
}
