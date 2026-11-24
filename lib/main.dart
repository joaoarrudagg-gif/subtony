import 'package:flutter/material.dart';

void main() {
  runApp(const ConsultaCepApp());
}

class ConsultaCepApp extends StatelessWidget {
  const ConsultaCepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(title: const Text('Consulta CEP')),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'CEP',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
