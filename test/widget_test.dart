import 'dart:convert';

import 'package:consulta_cep/main.dart';
import 'package:consulta_cep/services/via_cep_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

ViaCepService servicoFalso(Map<String, dynamic> corpo) {
  return ViaCepService(
    client: MockClient(
      (_) async => http.Response.bytes(utf8.encode(jsonEncode(corpo)), 200),
    ),
  );
}

String textoDoCampo(WidgetTester tester, String chave) {
  return tester.widget<TextField>(find.byKey(Key(chave))).controller!.text;
}

Future<void> consultar(WidgetTester tester, String cep) async {
  await tester.enterText(find.byKey(const Key('CEP')), cep);
  await tester.tap(find.text('Consultar'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('preenche cada campo com o retorno da API', (tester) async {
    final service = servicoFalso({
      'logradouro': 'Praça da Sé',
      'bairro': 'Sé',
      'localidade': 'São Paulo',
      'uf': 'SP',
    });
    await tester.pumpWidget(ConsultaCepApp(service: service));

    await consultar(tester, '01001000');

    expect(textoDoCampo(tester, 'Logradouro'), 'Praça da Sé');
    expect(textoDoCampo(tester, 'Bairro'), 'Sé');
    expect(textoDoCampo(tester, 'Localidade'), 'São Paulo');
    expect(textoDoCampo(tester, 'UF'), 'SP');
  });

  testWidgets('avisa quando o CEP não existe', (tester) async {
    final service = servicoFalso({'erro': 'true'});
    await tester.pumpWidget(ConsultaCepApp(service: service));

    await consultar(tester, '99999999');

    expect(find.text('CEP não encontrado.'), findsOneWidget);
  });

  testWidgets('avisa quando o CEP está incompleto', (tester) async {
    await tester.pumpWidget(ConsultaCepApp(service: servicoFalso({})));

    await consultar(tester, '123');

    expect(find.text('Digite um CEP com 8 números.'), findsOneWidget);
  });
}
