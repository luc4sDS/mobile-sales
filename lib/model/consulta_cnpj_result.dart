class ConsultaCnpjResult {
  final String? nome;
  final String? fantasia;
  final String? logradouro;
  final String? numero;
  final String? bairro;
  final String? municipio;
  final String? uf;
  final String? situacao;
  final String? email;
  final String? complemento;
  final String? cep;
  final String? numeroDeInscricao;
  final String? telefone;
  final String? tipo;

  // Construtor
  ConsultaCnpjResult({
    this.nome,
    this.fantasia,
    this.logradouro,
    this.numero,
    this.bairro,
    this.municipio,
    this.uf,
    this.situacao,
    this.email,
    this.complemento,
    this.cep,
    this.numeroDeInscricao,
    this.telefone,
    this.tipo,
  });

  // Factory constructor fromMap
  factory ConsultaCnpjResult.fromMap(Map<String, dynamic> map) {
    return ConsultaCnpjResult(
      nome: map['nome'] as String?,
      fantasia: map['fantasia'] as String?,
      logradouro: map['logradouro'] as String?,
      numero: map['numero'] as String?,
      bairro: map['bairro'] as String?,
      municipio: map['municipio'] as String?,
      uf: map['uf'] as String?,
      situacao: map['situacao'] as String?,
      email: map['email'] as String?,
      complemento: map['complemento'] as String?,
      cep: map['cep'] as String?,
      numeroDeInscricao: map['numero_de_inscricao'] as String?,
      telefone: map['telefone'] as String?,
      tipo: map['tipo'] as String?,
    );
  }

  // Método toMap
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'fantasia': fantasia,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'municipio': municipio,
      'uf': uf,
      'situacao': situacao,
      'email': email,
      'complemento': complemento,
      'cep': cep,
      'numero_de_inscricao': numeroDeInscricao,
      'telefone': telefone,
      'tipo': tipo,
    };
  }

  // Opcional: copyWith para facilitar cópias com alterações
  ConsultaCnpjResult copyWith({
    String? nome,
    String? fantasia,
    String? logradouro,
    String? numero,
    String? bairro,
    String? municipio,
    String? uf,
    String? situacao,
    String? email,
    String? complemento,
    String? cep,
    String? numeroDeInscricao,
    String? telefone,
    String? tipo,
  }) {
    return ConsultaCnpjResult(
      nome: nome ?? this.nome,
      fantasia: fantasia ?? this.fantasia,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      municipio: municipio ?? this.municipio,
      uf: uf ?? this.uf,
      situacao: situacao ?? this.situacao,
      email: email ?? this.email,
      complemento: complemento ?? this.complemento,
      cep: cep ?? this.cep,
      numeroDeInscricao: numeroDeInscricao ?? this.numeroDeInscricao,
      telefone: telefone ?? this.telefone,
      tipo: tipo ?? this.tipo,
    );
  }
}
