/// Endereço retornado pela API ViaCEP.
class Endereco {
  const Endereco({
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      logradouro: json['logradouro'] as String? ?? '',
      bairro: json['bairro'] as String? ?? '',
      localidade: json['localidade'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
    );
  }
}
