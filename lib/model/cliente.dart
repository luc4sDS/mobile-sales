class Cliente {
  int? cliId;
  String cliCnpj;
  String? cliInsc;
  String? cliRazao;
  String? cliFantasia;
  String? cliEndereco;
  String? cliNumero;
  String? cliBairro;
  String? cliCidade;
  String? cliEstado;
  String? cliCompl;
  String? cliCep;
  String? cliTelefone;
  String? cliEmail;
  String? cliEnvia;
  String? cliAtivo;
  int? cliTabela;

  Cliente({
    this.cliId,
    required this.cliCnpj,
    this.cliInsc,
    this.cliRazao,
    this.cliFantasia,
    this.cliEndereco,
    this.cliNumero,
    this.cliBairro,
    this.cliCidade,
    this.cliEstado,
    this.cliCompl,
    this.cliCep,
    this.cliTelefone,
    this.cliEmail,
    this.cliEnvia,
    this.cliAtivo,
    this.cliTabela,
  });

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      cliId: map['CLI_ID'] as int?,
      cliCnpj: map['CLI_CNPJ'] as String,
      cliInsc: map['CLI_INSC'] as String?,
      cliRazao: map['CLI_RAZAO'] as String?,
      cliFantasia: map['CLI_FANTASIA'] as String?,
      cliEndereco: map['CLI_ENDERECO'] as String?,
      cliNumero: map['CLI_NUMERO'] as String?,
      cliBairro: map['CLI_BAIRRO'] as String?,
      cliCidade: map['CLI_CIDADE'] as String?,
      cliEstado: map['CLI_ESTADO'] as String?,
      cliCompl: map['CLI_COMPL'] as String?,
      cliCep: map['CLI_CEP'] as String?,
      cliTelefone: map['CLI_TELEFONE'] as String?,
      cliEmail: map['CLI_EMAIL'] as String?,
      cliEnvia: map['CLI_ENVIA'] as String? ?? 'N',
      cliAtivo: map['CLI_ATIVO'] as String?,
      cliTabela: map['CLI_TABELA'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CLI_ID': cliId,
      'CLI_CNPJ': cliCnpj,
      'CLI_INSC': cliInsc,
      'CLI_RAZAO': cliRazao,
      'CLI_FANTASIA': cliFantasia,
      'CLI_ENDERECO': cliEndereco,
      'CLI_NUMERO': cliNumero,
      'CLI_BAIRRO': cliBairro,
      'CLI_CIDADE': cliCidade,
      'CLI_ESTADO': cliEstado,
      'CLI_COMPL': cliCompl,
      'CLI_CEP': cliCep,
      'CLI_TELEFONE': cliTelefone,
      'CLI_EMAIL': cliEmail,
      'CLI_ENVIA': cliEnvia,
      'CLI_ATIVO': cliAtivo,
      'CLI_TABELA': cliTabela,
    };
  }

  Cliente copyWith({
    int? cliId,
    String? cliCnpj,
    String? cliInsc,
    String? cliRazao,
    String? cliFantasia,
    String? cliEndereco,
    String? cliNumero,
    String? cliBairro,
    String? cliCidade,
    String? cliEstado,
    String? cliCompl,
    String? cliCep,
    String? cliTelefone,
    String? cliEmail,
    String? cliEnvia,
    String? cliAtivo,
    int? cliTabela,
  }) {
    return Cliente(
      cliId: cliId ?? this.cliId,
      cliCnpj: cliCnpj ?? this.cliCnpj,
      cliInsc: cliInsc ?? this.cliInsc,
      cliRazao: cliRazao ?? this.cliRazao,
      cliFantasia: cliFantasia ?? this.cliFantasia,
      cliEndereco: cliEndereco ?? this.cliEndereco,
      cliNumero: cliNumero ?? this.cliNumero,
      cliBairro: cliBairro ?? this.cliBairro,
      cliCidade: cliCidade ?? this.cliCidade,
      cliEstado: cliEstado ?? this.cliEstado,
      cliCompl: cliCompl ?? this.cliCompl,
      cliCep: cliCep ?? this.cliCep,
      cliTelefone: cliTelefone ?? this.cliTelefone,
      cliEmail: cliEmail ?? this.cliEmail,
      cliEnvia: cliEnvia ?? this.cliEnvia,
      cliAtivo: cliAtivo ?? this.cliAtivo,
      cliTabela: cliTabela ?? this.cliTabela,
    );
  }
}
