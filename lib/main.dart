import 'package:flutter/material.dart';

import 'pages/consulta_cep_page.dart';
import 'services/via_cep_service.dart';

void main() {
  runApp(const ConsultaCepApp());
}

class ConsultaCepApp extends StatelessWidget {
  const ConsultaCepApp({super.key, this.service});

  /// Permite substituir o serviço nos testes.
  final ViaCepService? service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: ConsultaCepPage(service: service),
    );
  }
}
