import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _modeloVeiculoController = TextEditingController();
  final _placaVeiculoController = TextEditingController();

  String _tipoVeiculo = 'Moto';
  File? _imagemPerfil;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _modeloVeiculoController.dispose();
    _placaVeiculoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagemPerfil = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar imagem: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _mostrarOpcoesImagem() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tirar Foto'),
              onTap: () {
                Navigator.pop(context);
                _selecionarImagem(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da Galeria'),
              onTap: () {
                Navigator.pop(context);
                _selecionarImagem(ImageSource.gallery);
              },
            ),
            if (_imagemPerfil != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remover Foto',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _imagemPerfil = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  String _formatarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), '');
    if (cpf.length <= 3) return cpf;
    if (cpf.length <= 6) return '${cpf.substring(0, 3)}.${cpf.substring(3)}';
    if (cpf.length <= 9)
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6)}';
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
  }

  String _formatarTelefone(String telefone) {
    telefone = telefone.replaceAll(RegExp(r'\D'), '');
    if (telefone.length <= 2) return telefone;
    if (telefone.length <= 7)
      return '(${telefone.substring(0, 2)}) ${telefone.substring(2)}';
    if (telefone.length <= 11) {
      return '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7)}';
    }
    return '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7, 11)}';
  }

  String _formatarPlaca(String placa) {
    placa = placa.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (placa.length <= 3) return placa;
    if (placa.length <= 7)
      return '${placa.substring(0, 3)}-${placa.substring(3)}';
    return '${placa.substring(0, 3)}-${placa.substring(3, 7)}';
  }

  bool _validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    return true; // Simplificado - adicionar validação completa de CPF em produção
  }

  void _salvarCadastro() {
    if (_formKey.currentState!.validate()) {
      if (_imagemPerfil == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, adicione uma foto de perfil'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simular salvamento (substituir por integração com backend)
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('✅ Cadastro Realizado'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Motoboy cadastrado com sucesso!'),
                const SizedBox(height: 16),
                Text(
                  'Nome: ${_nomeController.text}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('CPF: ${_cpfController.text}'),
                Text('Veículo: $_tipoVeiculo'),
                if (_tipoVeiculo != 'Bicicleta') ...[
                  Text('Modelo: ${_modeloVeiculoController.text}'),
                  Text('Placa: ${_placaVeiculoController.text}'),
                ],
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o dialog
                  Navigator.pop(context); // Volta para o dashboard
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Voltar ao Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  Widget _buildFotoPerfil() {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _mostrarOpcoesImagem,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(color: Colors.orange, width: 3),
              ),
              child: _imagemPerfil != null
                  ? ClipOval(
                      child: Image.file(_imagemPerfil!, fit: BoxFit.cover),
                    )
                  : Icon(Icons.person, size: 70, color: Colors.grey[400]),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _mostrarOpcoesImagem,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Motoboy'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Salvando cadastro...'),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Foto de Perfil
                  const SizedBox(height: 20),
                  _buildFotoPerfil(),
                  const SizedBox(height: 10),
                  const Text(
                    'Toque na foto para adicionar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Nome Completo
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome Completo *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, informe o nome completo';
                      }
                      if (value.trim().split(' ').length < 2) {
                        return 'Por favor, informe o nome completo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // CPF
                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(
                      labelText: 'CPF *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge_outlined),
                      hintText: '000.000.000-00',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    onChanged: (value) {
                      final formatted = _formatarCPF(value);
                      _cpfController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe o CPF';
                      }
                      if (!_validarCPF(value)) {
                        return 'CPF inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Telefone
                  TextFormField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_outlined),
                      hintText: '(00) 00000-0000',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    onChanged: (value) {
                      final formatted = _formatarTelefone(value);
                      _telefoneController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe o telefone';
                      }
                      final digits = value.replaceAll(RegExp(r'\D'), '');
                      if (digits.length < 10) {
                        return 'Telefone inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'seu@email.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Email inválido';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tipo de Veículo
                  const Text(
                    'Tipo de Veículo *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTipoVeiculoCard('Moto', Icons.two_wheeler),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTipoVeiculoCard(
                          'Carro',
                          Icons.directions_car,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTipoVeiculoCard(
                          'Bicicleta',
                          Icons.pedal_bike,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Campos adicionais para Carro/Moto
                  if (_tipoVeiculo != 'Bicicleta') ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Informações do Veículo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Modelo do Veículo
                    TextFormField(
                      controller: _modeloVeiculoController,
                      decoration: InputDecoration(
                        labelText: 'Modelo do ${_tipoVeiculo} *',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.directions_car_outlined),
                        hintText: 'Ex: Honda CG 160, Fiat Uno',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (_tipoVeiculo != 'Bicicleta' &&
                            (value == null || value.isEmpty)) {
                          return 'Por favor, informe o modelo do veículo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Placa do Veículo
                    TextFormField(
                      controller: _placaVeiculoController,
                      decoration: const InputDecoration(
                        labelText: 'Placa do Veículo *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.confirmation_number_outlined),
                        hintText: 'ABC-1234',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9]'),
                        ),
                        LengthLimitingTextInputFormatter(7),
                      ],
                      onChanged: (value) {
                        final formatted = _formatarPlaca(value);
                        _placaVeiculoController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );
                      },
                      validator: (value) {
                        if (_tipoVeiculo != 'Bicicleta' &&
                            (value == null || value.isEmpty)) {
                          return 'Por favor, informe a placa do veículo';
                        }
                        if (value != null && value.isNotEmpty) {
                          final placa = value.replaceAll(RegExp(r'\D'), '');
                          if (placa.length < 7) {
                            return 'Placa inválida';
                          }
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Botão Salvar
                  ElevatedButton(
                    onPressed: _salvarCadastro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'SALVAR CADASTRO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildTipoVeiculoCard(String tipo, IconData icon) {
    final isSelected = _tipoVeiculo == tipo;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tipoVeiculo = tipo;
          if (tipo == 'Bicicleta') {
            _modeloVeiculoController.clear();
            _placaVeiculoController.clear();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              tipo,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
