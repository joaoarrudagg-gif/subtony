import 'package:flutter/material.dart';

import '../services/via_cep_service.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key, this.service});

  final ViaCepService? service;

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  late final ViaCepService _service = widget.service ?? ViaCepService();

  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _localidadeController = TextEditingController();
  final _ufController = TextEditingController();

  @override
  void dispose() {
    _cepController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _localidadeController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  Future<void> _consultar() async {
    final endereco = await _service.buscar(_cepController.text);
    if (!mounted) return;

    _logradouroController.text = endereco.logradouro;
    _bairroController.text = endereco.bairro;
    _localidadeController.text = endereco.localidade;
    _ufController.text = endereco.uf;
  }

  Widget _campoResultado(String rotulo, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: rotulo,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta CEP')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _cepController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'CEP',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _consultar,
            child: const Text('Consultar'),
          ),
          _campoResultado('Logradouro', _logradouroController),
          _campoResultado('Bairro', _bairroController),
          _campoResultado('Localidade', _localidadeController),
          _campoResultado('UF', _ufController),
        ],
      ),
    );
  }
}
