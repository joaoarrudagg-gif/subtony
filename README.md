# Consulta CEP

Aplicativo Flutter que consulta um CEP na API [ViaCEP](https://viacep.com.br/)
usando o pacote [http](https://pub.dev/packages/http).

## Funcionalidades

- Consulta de CEP (8 números)
- Logradouro, bairro, localidade e UF, cada um em um `TextField`
- Indicador de carregamento
- Mensagens para CEP inválido, CEP inexistente e falha de conexão

## Como executar

```bash
flutter create .   # gera as pastas das plataformas, se ainda não existirem
flutter pub get
flutter run
```

### Permissão de internet

- **Android** (necessária na versão release): em
  `android/app/src/main/AndroidManifest.xml`, adicione antes de `<application>`:
  `<uses-permission android:name="android.permission.INTERNET"/>`
- **macOS**: adicione `com.apple.security.network.client` com valor `true` em
  `macos/Runner/DebugProfile.entitlements` e `Release.entitlements`.

## Testes

```bash
flutter test
```

## Estrutura

```
lib/
├── main.dart
├── models/endereco.dart
├── pages/consulta_cep_page.dart
└── services/via_cep_service.dart
```
