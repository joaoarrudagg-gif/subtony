import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  bool _carregando = false;

  @override
  void dispose() {
    _cepController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _localidadeController.dispose();
    _ufController.dispose();
    // Fecha apenas o serviço criado por esta tela.
    if (widget.service == null) _service.dispose();
    super.dispose();
  }

  Future<void> _consultar() async {
    if (_carregando) return;

    FocusScope.of(context).unfocus();
    _limparResultado();
    setState(() => _carregando = true);

    try {
      final endereco = await _service.buscar(_cepController.text);
      if (!mounted) return;

      _logradouroController.text = endereco.logradouro;
      _bairroController.text = endereco.bairro;
      _localidadeController.text = endereco.localidade;
      _ufController.text = endereco.uf;
    } on ViaCepException catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(erro.mensagem)));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _limparResultado() {
    _logradouroController.clear();
    _bairroController.clear();
    _localidadeController.clear();
    _ufController.clear();
  }

  Widget _campoResultado(String rotulo, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextField(
        key: Key(rotulo),
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
            key: const Key('CEP'),
            controller: _cepController,
            enabled: !_carregando,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            onSubmitted: (_) => _consultar(),
            decoration: const InputDecoration(
              labelText: 'CEP',
              hintText: 'Somente números',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _carregando ? null : _consultar,
            icon: _carregando
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
            label: Text(_carregando ? 'Consultando...' : 'Consultar'),
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
