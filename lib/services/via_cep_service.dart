import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/endereco.dart';

/// Erro de consulta com uma mensagem pronta para ser exibida ao usuário.
class ViaCepException implements Exception {
  const ViaCepException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}

class ViaCepService {
  ViaCepService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Endereco> buscar(String cep) async {
    if (!RegExp(r'^\d{8}$').hasMatch(cep)) {
      throw const ViaCepException('Digite um CEP com 8 números.');
    }

    final url = Uri.https('viacep.com.br', '/ws/$cep/json/');

    try {
      final resposta =
          await _client.get(url).timeout(const Duration(seconds: 10));

      if (resposta.statusCode != 200) {
        throw ViaCepException(
          'Falha na consulta (código ${resposta.statusCode}).',
        );
      }

      final json =
          jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;

      // CEP com formato válido, mas inexistente: a API responde com "erro".
      if (json.containsKey('erro')) {
        throw const ViaCepException('CEP não encontrado.');
      }

      return Endereco.fromJson(json);
    } on TimeoutException {
      throw const ViaCepException('A consulta demorou demais. Tente novamente.');
    } on http.ClientException {
      throw const ViaCepException('Sem conexão. Verifique sua internet.');
    } on FormatException {
      throw const ViaCepException('Resposta inválida da API.');
    }
  }

  void dispose() => _client.close();
}
