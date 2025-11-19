import 'package:flutter/material.dart';
import 'dart:async';

class BuscarPage extends StatefulWidget {
  const BuscarPage({Key? key}) : super(key: key);

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  // Estados do sistema
  bool _modoAutomatico = true;
  bool _buscandoMotoboy = false;
  bool _motoboyEncontrado = false;
  bool _corridaAceita = false;
  bool _aguardandoPagamento = false;
  bool _pagamentoConfirmado = false;
  bool _motoboyColetou = false;
  bool _entregaFinalizada = false;

  // Controles de tempo
  Timer? _timerBusca;
  int _tempoRestante = 300; // 5 minutos em segundos

  // Dados do pedido
  String _origem = '';
  String _destino = '';
  String _metodoPagamento = 'Dinheiro';
  double _valorCorrida = 0.0;

  // Dados do motoboy
  String? _motoboyNome;
  String? _motoboyPlaca;
  double? _motoboyAvaliacao;

  @override
  void dispose() {
    _timerBusca?.cancel();
    super.dispose();
  }

  void _iniciarBusca() {
    if (_origem.isEmpty || _destino.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha origem e destino'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _buscandoMotoboy = true;
      _tempoRestante = 300;
    });

    // Iniciar timer de 5 minutos
    _timerBusca = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _tempoRestante--;

        if (_tempoRestante <= 0) {
          _timerBusca?.cancel();
          _mostrarDialogTempoEsgotado();
        }
      });
    });

    // Simular busca de motoboy (substituir por integração real)
    Future.delayed(const Duration(seconds: 3), () {
      if (_buscandoMotoboy) {
        _simularMotoboyEncontrado();
      }
    });
  }

  void _simularMotoboyEncontrado() {
    // Simular encontrar um motoboy (substituir por lógica real)
    setState(() {
      _motoboyEncontrado = true;
      _buscandoMotoboy = false;
      _motoboyNome = 'João Silva';
      _motoboyPlaca = 'ABC-1234';
      _motoboyAvaliacao = 4.8;
    });
    _timerBusca?.cancel();
  }

  void _mostrarDialogTempoEsgotado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Tempo Esgotado'),
        content: const Text(
          'Não foi possível encontrar um motoboy disponível em 5 minutos.\n\n'
          'Deseja cancelar o pedido ou continuar tentando?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelarPedido();
            },
            child: const Text('Cancelar Pedido'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _reiniciarBusca();
            },
            child: const Text('Continuar Tentando'),
          ),
        ],
      ),
    );
  }

  void _reiniciarBusca() {
    setState(() {
      _buscandoMotoboy = false;
      _motoboyEncontrado = false;
      _corridaAceita = false;
    });
    _iniciarBusca();
  }

  void _cancelarPedido() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Pedido'),
        content: const Text(
          'Estamos sem motoboy disponível no momento.\n\n'
          'Recomendações:\n'
          '• Encontre outro motoboy pessoalmente\n'
          '• Faça o estorno do dinheiro do cliente',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Voltar para dashboard
            },
            child: const Text('Confirmar Cancelamento'),
          ),
        ],
      ),
    );
  }

  void _aceitarManualmente() {
    setState(() {
      _corridaAceita = true;
    });
    _iniciarBusca();
  }

  void _motoboyAceitouCorrida() {
    setState(() {
      _corridaAceita = true;
    });

    if (_metodoPagamento == 'Pix') {
      setState(() {
        _aguardandoPagamento = true;
      });
    } else {
      _avancarParaColeta();
    }
  }

  void _confirmarPagamento() {
    setState(() {
      _pagamentoConfirmado = true;
      _aguardandoPagamento = false;
    });
    _avancarParaColeta();
  }

  void _avancarParaColeta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pedido Aceito'),
        content: Text(
          'Motoboy $_motoboyNome está a caminho da pizzaria para coletar o pedido.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _motoboyColetou = true;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _motoboyColetouPedido() {
    setState(() {
      _motoboyColetou = true;
    });
  }

  void _finalizarEntrega() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Entrega'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Digite o código de confirmação do cliente:'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Código',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _entregaFinalizada = true;
              });
              _mostrarEntregaConcluida();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _mostrarEntregaConcluida() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('✅ Entrega Concluída'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Entrega realizada com sucesso!'),
            const SizedBox(height: 16),
            Text(
              'Valor: R\$ ${_valorCorrida.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Voltar para dashboard
            },
            child: const Text('Voltar ao Dashboard'),
          ),
        ],
      ),
    );
  }

  void _motoboyCancelou() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Motoboy Cancelou'),
        content: const Text(
          'O motoboy cancelou a corrida antes de ir à pizzaria.\n\n'
          'Buscando outro motoboy disponível...',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _reiniciarBusca();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatarTempo(int segundos) {
    int minutos = segundos ~/ 60;
    int segs = segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  Widget _buildFormularioPedido() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Novo Pedido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Modo de busca
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Automático'),
                    value: true,
                    groupValue: _modoAutomatico,
                    onChanged: (value) {
                      setState(() {
                        _modoAutomatico = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Manual'),
                    value: false,
                    groupValue: _modoAutomatico,
                    onChanged: (value) {
                      setState(() {
                        _modoAutomatico = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Origem
            TextField(
              decoration: const InputDecoration(
                labelText: 'Origem (Pizzaria)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
              onChanged: (value) => _origem = value,
            ),

            const SizedBox(height: 16),

            // Destino
            TextField(
              decoration: const InputDecoration(
                labelText: 'Destino (Endereço do Cliente)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              onChanged: (value) => _destino = value,
            ),

            const SizedBox(height: 16),

            // Valor da corrida
            TextField(
              decoration: const InputDecoration(
                labelText: 'Valor da Corrida (R\$)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _valorCorrida = double.tryParse(value) ?? 0.0;
              },
            ),

            const SizedBox(height: 16),

            // Método de pagamento
            DropdownButtonFormField<String>(
              value: _metodoPagamento,
              decoration: const InputDecoration(
                labelText: 'Método de Pagamento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment),
              ),
              items: const [
                DropdownMenuItem(value: 'Dinheiro', child: Text('Dinheiro')),
                DropdownMenuItem(value: 'Pix', child: Text('Pix')),
                DropdownMenuItem(value: 'Cartão', child: Text('Cartão')),
              ],
              onChanged: (value) {
                setState(() {
                  _metodoPagamento = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // Botão de ação
            ElevatedButton(
              onPressed: _modoAutomatico ? _iniciarBusca : _aceitarManualmente,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.orange,
              ),
              child: Text(
                _modoAutomatico
                    ? 'Buscar Motoboy Automaticamente'
                    : 'Aceitar e Buscar',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuscandoMotoboy() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Buscando motoboy disponível...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Tempo restante: ${_formatarTempo(_tempoRestante)}',
              style: TextStyle(
                fontSize: 16,
                color: _tempoRestante < 60 ? Colors.red : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _timerBusca?.cancel();
                _cancelarPedido();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Cancelar Busca',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotoboyEncontrado() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '✅ Motoboy Encontrado!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(_motoboyNome ?? 'Motoboy'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Placa: $_motoboyPlaca'),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' $_motoboyAvaliacao'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (!_corridaAceita) ...[
              const Text(
                'Aguardando o motoboy aceitar a corrida...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _motoboyAceitouCorrida,
                child: const Text('Simular Aceitação (DEV)'),
              ),
            ] else if (_aguardandoPagamento) ...[
              const Text(
                '💳 Aguardando pagamento via Pix',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Cliente deve enviar comprovante no WhatsApp da Pizzaria',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmarPagamento,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'Confirmar Pagamento Recebido',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ] else if (!_motoboyColetou) ...[
              const Text(
                '🏍️ Motoboy a caminho da pizzaria',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _motoboyColetouPedido,
                child: const Text('Confirmar Coleta do Pedido'),
              ),
            ] else if (!_entregaFinalizada) ...[
              const Text(
                '📦 Pedido em rota de entrega',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _finalizarEntrega,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Finalizar Entrega',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],

            const SizedBox(height: 10),

            if (_corridaAceita && !_motoboyColetou)
              OutlinedButton(
                onPressed: _motoboyCancelou,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Simular Cancelamento do Motoboy'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Motoboy'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!_buscandoMotoboy && !_motoboyEncontrado)
              _buildFormularioPedido()
            else if (_buscandoMotoboy)
              _buildBuscandoMotoboy()
            else if (_motoboyEncontrado)
              _buildMotoboyEncontrado(),
          ],
        ),
      ),
    );
  }
}
