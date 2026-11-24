import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/endereco.dart';

class ViaCepService {
  ViaCepService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Endereco> buscar(String cep) async {
    final url = Uri.https('viacep.com.br', '/ws/$cep/json/');
    final resposta = await _client.get(url);
    final json = jsonDecode(utf8.decode(resposta.bodyBytes));

    return Endereco.fromJson(json as Map<String, dynamic>);
  }
}
