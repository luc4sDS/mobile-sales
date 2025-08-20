class Parametros {
  // Database fields
  int? parCusu;
  String? parUsuario;
  String? parChave;
  String? parSenha;
  String? parImpCli;
  String? parAlteraPreco;
  String? parEndeIPTeste;
  String? parEndIPProd;
  int? parPortaProd;
  int? parPortaTeste;
  int? parSincronia;
  String? parUltSincronia; // Stored as ISO8601 string
  String? parEmpresa;
  String? parBloqueado;
  String? parCadastraCliente;
  String? parPedidoClienteNovo;
  String? parDesconto;
  String? parFinanceiro;
  String? parProdutosDesativados;
  String? parClientesDesativados;
  double? parBonificacao;
  double parLimiteDesconto;
  String? parDescontoGeral;
  int? parValidadePedido;
  String? parCnpj;
  int parVersao;
  String? parTabelaEstado;
  String? parSaldo;
  String? parHostInterno;
  String? parVendNome;

  // Constructor with default values
  Parametros({
    this.parCusu,
    this.parUsuario,
    this.parChave,
    this.parSenha,
    this.parImpCli,
    this.parAlteraPreco,
    this.parEndeIPTeste,
    this.parEndIPProd,
    this.parPortaProd,
    this.parPortaTeste,
    this.parSincronia,
    this.parUltSincronia,
    this.parEmpresa,
    this.parBloqueado,
    this.parCadastraCliente,
    this.parPedidoClienteNovo,
    this.parDesconto,
    this.parFinanceiro,
    this.parProdutosDesativados,
    this.parClientesDesativados,
    this.parBonificacao,
    this.parLimiteDesconto = 0.0, // Default value
    this.parDescontoGeral,
    this.parValidadePedido,
    this.parCnpj,
    this.parVersao = 1, // Default value
    this.parTabelaEstado,
    this.parSaldo,
    this.parHostInterno,
    this.parVendNome,
  });

  // Convert a Map to Parametros
  factory Parametros.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic value, [double defaultValue = 0.0]) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    return Parametros(
      parCusu: map['PAR_CUSU'] as int?,
      parUsuario: map['PAR_USUARIO'] as String?,
      parChave: map['PAR_CHAVE'] as String?,
      parSenha: map['PAR_SENHA'] as String?,
      parImpCli: map['PAR_IMPCLI'] as String?,
      parAlteraPreco: map['PAR_ALTERAPRECO'] as String?,
      parEndeIPTeste: map['PAR_ENDEIPTESTE'] as String?,
      parEndIPProd: map['PAR_ENDIPPROD'] as String?,
      parPortaProd: map['PAR_PORTAPROD'] as int?,
      parPortaTeste: map['PAR_PORTATESTE'] as int?,
      parSincronia: map['PAR_SINCRONIA'] as int?,
      parUltSincronia: map['PAR_ULTSINCRONIA'] as String?,
      parEmpresa: map['PAR_EMPRESA'] as String?,
      parBloqueado: map['PAR_BLOQUEADO'] as String?,
      parCadastraCliente: map['PAR_CADASTRACLIENTE'] as String?,
      parPedidoClienteNovo: map['PAR_PEDIDOCLIENTENOVO'] as String?,
      parDesconto: map['PAR_DESCONTO'] as String?,
      parFinanceiro: map['PAR_FINANCEIRO'] as String?,
      parProdutosDesativados: map['PAR_PRODUTOSDESATIVADOS'] as String?,
      parClientesDesativados: map['PAR_CLIENTESDESATIVADOS'] as String?,
      parBonificacao: map.containsKey('PAR_BONIFICACAO')
          ? parseDouble(map['PAR_BONIFICACAO'])
          : null,
      parLimiteDesconto: parseDouble(map['PAR_LIMITEDESCONTO'], 0.0),
      parDescontoGeral: map['PAR_DESCONTOGERAL'] as String?,
      parValidadePedido: map['PAR_VALIDADEPEDIDO'] as int?,
      parCnpj: map['PAR_CNPJ'] as String?,
      parVersao: map['PAR_VERSAO'] as int? ?? 1,
      parTabelaEstado: map['PAR_TABELAESTADO'] as String?,
      parSaldo: map['PAR_SALDO'] as String?,
      parHostInterno: map['PAR_HOSTINTERNO'] as String?,
      parVendNome: map['PAR_VENDNOME'] as String?,
    );
  }

  // Convert Parametros to Map
  Map<String, dynamic> toMap() {
    return {
      'PAR_CUSU': parCusu,
      'PAR_USUARIO': parUsuario,
      'PAR_CHAVE': parChave,
      'PAR_SENHA': parSenha,
      'PAR_IMPCLI': parImpCli,
      'PAR_ALTERAPRECO': parAlteraPreco,
      'PAR_ENDEIPTESTE': parEndeIPTeste,
      'PAR_ENDIPPROD': parEndIPProd,
      'PAR_PORTAPROD': parPortaProd,
      'PAR_PORTATESTE': parPortaTeste,
      'PAR_SINCRONIA': parSincronia,
      'PAR_ULTSINCRONIA': parUltSincronia,
      'PAR_EMPRESA': parEmpresa,
      'PAR_BLOQUEADO': parBloqueado,
      'PAR_CADASTRACLIENTE': parCadastraCliente,
      'PAR_PEDIDOCLIENTENOVO': parPedidoClienteNovo,
      'PAR_DESCONTO': parDesconto,
      'PAR_FINANCEIRO': parFinanceiro,
      'PAR_PRODUTOSDESATIVADOS': parProdutosDesativados,
      'PAR_CLIENTESDESATIVADOS': parClientesDesativados,
      'PAR_BONIFICACAO': parBonificacao,
      'PAR_LIMITEDESCONTO': parLimiteDesconto,
      'PAR_DESCONTOGERAL': parDescontoGeral,
      'PAR_VALIDADEPEDIDO': parValidadePedido,
      'PAR_CNPJ': parCnpj,
      'PAR_VERSAO': parVersao,
      'PAR_TABELAESTADO': parTabelaEstado,
      'PAR_SALDO': parSaldo,
      'PAR_HOSTINTERNO': parHostInterno,
      'PAR_VENDNOME': parVendNome,
    };
  }

  // Helper method to convert string date to DateTime
  DateTime? get ultsincroniaAsDateTime {
    return parUltSincronia != null ? DateTime.parse(parUltSincronia!) : null;
  }

  // Helper to set datetime from DateTime object
  set ultsincroniaAsDateTime(DateTime? date) {
    parUltSincronia = date?.toIso8601String();
  }

  // CopyWith method for immutability
  Parametros copyWith({
    int? parCusu,
    String? parUsuario,
    String? parChave,
    String? parSenha,
    String? parImpCli,
    String? parAlteraPreco,
    String? parEndeIPTeste,
    String? parEndIPProd,
    int? parPortaProd,
    int? parPortaTeste,
    int? parSincronia,
    String? parUltSincronia,
    String? parEmpresa,
    String? parBloqueado,
    String? parCadastraCliente,
    String? parPedidoClienteNovo,
    String? parDesconto,
    String? parFinanceiro,
    String? parProdutosDesativados,
    String? parClientesDesativados,
    double? parBonificacao,
    double? parLimitedesconto,
    String? parDescontoGeral,
    int? parValidadePedido,
    String? parCnpj,
    int? parVersao,
    String? parTabelaEstado,
    String? parSaldo,
    String? parHostInterno,
    String? parVendNome,
  }) {
    return Parametros(
      parCusu: parCusu ?? this.parCusu,
      parUsuario: parUsuario ?? this.parUsuario,
      parChave: parChave ?? this.parChave,
      parSenha: parSenha ?? this.parSenha,
      parImpCli: parImpCli ?? this.parImpCli,
      parAlteraPreco: parAlteraPreco ?? this.parAlteraPreco,
      parEndeIPTeste: parEndeIPTeste ?? this.parEndeIPTeste,
      parEndIPProd: parEndIPProd ?? this.parEndIPProd,
      parPortaProd: parPortaProd ?? this.parPortaProd,
      parPortaTeste: parPortaTeste ?? this.parPortaTeste,
      parSincronia: parSincronia ?? this.parSincronia,
      parUltSincronia: parUltSincronia ?? this.parUltSincronia,
      parEmpresa: parEmpresa ?? this.parEmpresa,
      parBloqueado: parBloqueado ?? this.parBloqueado,
      parCadastraCliente: parCadastraCliente ?? this.parCadastraCliente,
      parPedidoClienteNovo: parPedidoClienteNovo ?? this.parPedidoClienteNovo,
      parDesconto: parDesconto ?? this.parDesconto,
      parFinanceiro: parFinanceiro ?? this.parFinanceiro,
      parProdutosDesativados:
          parProdutosDesativados ?? this.parProdutosDesativados,
      parClientesDesativados:
          parClientesDesativados ?? this.parClientesDesativados,
      parBonificacao: parBonificacao ?? this.parBonificacao,
      parLimiteDesconto: parLimiteDesconto,
      parDescontoGeral: parDescontoGeral ?? this.parDescontoGeral,
      parValidadePedido: parValidadePedido ?? this.parValidadePedido,
      parCnpj: parCnpj ?? this.parCnpj,
      parVersao: parVersao ?? this.parVersao,
      parTabelaEstado: parTabelaEstado ?? this.parTabelaEstado,
      parSaldo: parSaldo ?? this.parSaldo,
      parHostInterno: parHostInterno ?? this.parHostInterno,
      parVendNome: parVendNome ?? this.parVendNome,
    );
  }
}
