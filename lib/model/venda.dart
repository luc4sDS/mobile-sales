import 'package:intl/intl.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/utils/utils.dart';

class Venda {
  final int vndId;
  final String? vndChave;
  final DateTime vndDataHora;
  final DateTime? vndPrevent;
  final int vndVend;
  final String vndVendNome;
  final String? vndCliCnpj;
  final String vndCliNome;
  final String? vndCliFant;
  final int? vndFormaPagto;
  final String? vndFormaNome;
  final int? vndMeio;
  final String? vndMeioNome;
  final double vndValor;
  final double vndDesconto;
  final double vndFrete;
  final double vndTotalSt;
  final double vndTotalIpi;
  final double vndTotal;
  final String? vndObs;
  final String vndEnviado;
  final double vndPeso;
  final int? vndEntrega;
  final String? vndNEntrega;
  final double? vndLatitude;
  final double? vndLongitude;
  final int? vndTabela;
  final String? vndUf;
  final String? vndCidade;
  final String? vndEnderecoEnt;
  final String? vndNumeroEnt;
  final String? vndBairroEnt;
  final String? vndCidadeEnt;
  final String? vndEstadoEnt;
  final String? vndCepEnt;
  final String? vndComplEnt;
  final String? vndEmail;
  final double vndPrAcrescimo;
  final double vndPrDesconto;
  final int vndCliCod;
  final String? vndSincronia;
  final DateTime? vndAtualizacao;
  final int? vndParcelas;
  final double vndTotalBonificacao;
  final double vndSaldoBonificacao;
  final List<VendaItem> itens; // Novo campo adicionado

  Venda({
    required this.vndId,
    this.vndChave,
    required this.vndDataHora,
    this.vndPrevent,
    required this.vndVend,
    required this.vndVendNome,
    this.vndCliCnpj,
    required this.vndCliNome,
    this.vndCliFant,
    this.vndFormaPagto,
    this.vndFormaNome,
    this.vndMeio,
    this.vndMeioNome,
    required this.vndValor,
    this.vndDesconto = 0,
    this.vndFrete = 0,
    this.vndTotalSt = 0,
    this.vndTotalIpi = 0,
    required this.vndTotal,
    this.vndObs,
    this.vndEnviado = 'N',
    this.vndPeso = 0,
    this.vndEntrega,
    this.vndNEntrega,
    this.vndLatitude,
    this.vndLongitude,
    this.vndTabela,
    this.vndUf,
    this.vndCidade,
    this.vndEnderecoEnt,
    this.vndNumeroEnt,
    this.vndBairroEnt,
    this.vndCidadeEnt,
    this.vndEstadoEnt,
    this.vndCepEnt,
    this.vndComplEnt,
    this.vndEmail,
    this.vndPrAcrescimo = 0,
    this.vndPrDesconto = 0,
    this.vndCliCod = 0,
    this.vndSincronia,
    this.vndAtualizacao,
    this.vndParcelas,
    this.vndTotalBonificacao = 0,
    this.vndSaldoBonificacao = 0,
    this.itens = const [], // Inicializado como lista vazia por padrão
  });

  @override
  String toString() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final buffer = StringBuffer();

    buffer.writeln('Venda:');
    buffer.writeln('----------------------------------------');
    buffer.writeln('ID: $vndId');
    buffer.writeln('Chave: ${vndChave ?? "N/A"}');
    buffer.writeln('Data/Hora: ${dateFormat.format(vndDataHora)}');
    if (vndPrevent != null) {
      buffer.writeln('Data Prevista: ${dateFormat.format(vndPrevent!)}');
    }
    buffer.writeln('----------------------------------------');
    buffer.writeln('Vendedor:');
    buffer.writeln('  Código: $vndVend');
    buffer.writeln('  Nome: $vndVendNome');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Cliente:');
    buffer.writeln('  ID: $vndCliCod');
    buffer.writeln('  Nome: $vndCliNome');
    buffer.writeln('  Fantasia: ${vndCliFant ?? "N/A"}');
    buffer.writeln('  CNPJ: ${vndCliCnpj ?? "N/A"}');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Valores:');
    buffer.writeln('  Valor: ${vndValor.toStringAsFixed(2)}');
    buffer.writeln('  Desconto: ${vndDesconto.toStringAsFixed(2)}');
    buffer.writeln('  Frete: ${vndFrete.toStringAsFixed(2)}');
    buffer.writeln('  ST: ${vndTotalSt.toStringAsFixed(2)}');
    buffer.writeln('  IPI: ${vndTotalIpi.toStringAsFixed(2)}');
    buffer.writeln('  Total: ${vndTotal.toStringAsFixed(2)}');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Pagamento:');
    buffer.writeln(
        '  Forma: ${vndFormaNome ?? "N/A"} (${vndFormaPagto ?? "N/A"})');
    buffer.writeln('  Meio: ${vndMeioNome ?? "N/A"} (${vndMeio ?? "N/A"})');
    buffer.writeln('  Parcelas: ${vndParcelas ?? "N/A"}');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Bonificação:');
    buffer.writeln('  Total: ${vndTotalBonificacao.toStringAsFixed(2)}');
    buffer.writeln('  Saldo: ${vndSaldoBonificacao.toStringAsFixed(2)}');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Entrega:');
    buffer.writeln('  Tipo: ${vndEntrega ?? "N/A"}');
    buffer.writeln('  Nº Entrega: ${vndNEntrega ?? "N/A"}');
    if (vndLatitude != null && vndLongitude != null) {
      buffer.writeln('  Localização: ${vndLatitude}, ${vndLongitude}');
    }
    buffer.writeln('----------------------------------------');
    buffer.writeln('Endereço de Entrega:');
    buffer.writeln('  ${vndEnderecoEnt ?? "N/A"}, ${vndNumeroEnt ?? "N/A"}');
    buffer.writeln('  ${vndBairroEnt ?? "N/A"}');
    buffer.writeln('  ${vndCidadeEnt ?? "N/A"}/${vndEstadoEnt ?? "N/A"}');
    buffer.writeln('  CEP: ${vndCepEnt ?? "N/A"}');
    buffer.writeln('  Complemento: ${vndComplEnt ?? "N/A"}');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Observações: ${vndObs ?? "Nenhuma"}');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Itens da Venda (${itens.length}):');

    for (var (index, item) in itens.indexed) {
      buffer.writeln('  ${index + 1}. ${item.vdiDescricao}');
      buffer.writeln('     Código: ${item.vdiProdCod}');
      buffer.writeln('     Quantidade: ${item.vdiQtd.toStringAsFixed(2)}');
      buffer.writeln('     Unitário: ${item.vdiUnit.toStringAsFixed(2)}');
      buffer.writeln('     Total: ${item.vdiTotal.toStringAsFixed(2)}');
      if (index < itens.length - 1) buffer.writeln('     ---');
    }

    buffer.writeln('----------------------------------------');
    buffer
        .writeln('Status: ${vndEnviado == 'S' ? 'Sincronizado' : 'Pendente'}');
    if (vndAtualizacao != null) {
      buffer
          .writeln('Última Atualização: ${dateFormat.format(vndAtualizacao!)}');
    }

    return buffer.toString();
  }

  factory Venda.fromMap(Map<String, dynamic> map) {
    return Venda(
      vndId: map['VND_ID'] as int,
      vndChave: map['VND_CHAVE'] as String?,
      vndDataHora: Utils().parseDateFlexivel(map['VND_DATAHORA'] as String),
      vndPrevent: map['VND_PREVENT'] != null
          ? DateFormat('MM-dd-yyyy').parse(map['VND_PREVENT'] as String)
          : null,
      vndVend: map['VND_VEND'] as int,
      vndVendNome: map['VND_VENDNOME'] as String,
      vndCliCnpj: map['VND_CLI_CNPJ'] as String?,
      vndCliNome: map['VND_CLI_NOME'] as String,
      vndCliFant: map['VND_CLI_FANT'] as String?,
      vndFormaPagto: map['VND_FORMAPAGTO'] as int?,
      vndFormaNome: map['VND_FORMANOME'] as String?,
      vndMeio: map['VND_MEIO'] as int?,
      vndMeioNome: map['VND_MEIONOME'] as String?,
      vndValor: (map['VND_VALOR'] as num).toDouble(),
      vndDesconto: (map['VND_DESCONTO'] as num?)?.toDouble() ?? 0,
      vndFrete: (map['VND_FRETE'] as num?)?.toDouble() ?? 0,
      vndTotalSt: (map['VND_TOTALST'] as num?)?.toDouble() ?? 0,
      vndTotalIpi: (map['VND_TOTALIPI'] as num?)?.toDouble() ?? 0,
      vndTotal: (map['VND_TOTAL'] as num).toDouble(),
      vndObs: map['VND_OBS'] as String?,
      vndEnviado: map['VND_ENVIADO'] as String? ?? 'N',
      vndPeso: (map['VND_PESO'] as num?)?.toDouble() ?? 0,
      vndEntrega: map['VND_ENTREGA'] as int?,
      vndNEntrega: map['VND_NENTREGA'] as String?,
      vndLatitude: (map['VND_LATITUDE'] as num?)?.toDouble(),
      vndLongitude: (map['VND_LONGITUDE'] as num?)?.toDouble(),
      vndTabela: map['VND_TABELA'] as int?,
      vndUf: map['VND_UF'] as String?,
      vndCidade: map['VND_CIDADE'] as String?,
      vndEnderecoEnt: map['VND_ENDERECOENT'] as String?,
      vndNumeroEnt: map['VND_NUMEROENT'] as String?,
      vndBairroEnt: map['VND_BAIRROENT'] as String?,
      vndCidadeEnt: map['VND_CIDADEENT'] as String?,
      vndEstadoEnt: map['VND_ESTADOENT'] as String?,
      vndCepEnt: map['VND_CEPENT'] as String?,
      vndComplEnt: map['VND_COMPLENT'] as String?,
      vndEmail: map['VND_EMAIL'] as String?,
      vndPrAcrescimo: (map['VND_PRACRESCIMO'] as num?)?.toDouble() ?? 0,
      vndPrDesconto: (map['VND_PRDESCONTO'] as num?)?.toDouble() ?? 0,
      vndCliCod: (map['VND_CLI_COD'] as int?) ?? 0,
      vndSincronia: map['VND_SINCRONIA'] as String?,
      vndAtualizacao: map['VND_ATUALIZACAO'] != null
          ? Utils().parseDateFlexivel(map['VND_ATUALIZACAO'] as String)
          : null,
      vndParcelas: map['VND_PARCELAS'] as int?,
      vndTotalBonificacao:
          (map['VND_TOTALBONIFICACAO'] as num?)?.toDouble() ?? 0,
      vndSaldoBonificacao:
          (map['VND_SALDOBONIFICACAO'] as num?)?.toDouble() ?? 0,
      itens: map['ITENS'] != null
          ? (map['ITENS'] as List).map((i) => VendaItem.fromMap(i)).toList()
          : [], // Mapeia os itens se existirem
    );
  }

  factory Venda.fromMapAPI(Map<String, dynamic> map) {
    return Venda(
      vndId: map['VND_ID'] as int,
      vndChave: map['VND_CHAVE'] as String?,
      vndDataHora: Utils().parseDateFlexivel(map['VND_DATAHORA'] as String),
      vndPrevent: map['VND_PREVENT'] != null
          ? DateFormat('MM-dd-yyyy').parse(map['VND_PREVENT'] as String)
          : null,
      vndVend: map['VND_VEND'] as int,
      vndVendNome: map['VND_VENDNOME'] as String,
      vndCliCnpj: map['VND_CLI_CNPJ'] as String?,
      vndCliNome: map['VND_CLI_NOME'] as String,
      vndCliFant: map['VND_CLI_FANT'] as String?,
      vndFormaPagto: map['VND_FORMAPAGTO'] as int?,
      vndFormaNome: map['VND_FORMANOME'] as String?,
      vndMeio: map['VND_MEIO'] as int?,
      vndMeioNome: map['VND_MEIONOME'] as String?,
      vndValor: (map['VND_VALOR'] as num).toDouble(),
      vndDesconto: (map['VND_DESCONTO'] as num?)?.toDouble() ?? 0,
      vndFrete: (map['VND_FRETE'] as num?)?.toDouble() ?? 0,
      vndTotalSt: (map['VND_TOTALST'] as num?)?.toDouble() ?? 0,
      vndTotalIpi: (map['VND_TOTALIPI'] as num?)?.toDouble() ?? 0,
      vndTotal: (map['VND_TOTAL'] as num).toDouble(),
      vndObs: map['VND_OBS'] as String?,
      vndEnviado: map['VND_SITUACAO'] as String? ?? 'C',
      vndPeso: (map['VND_PESO'] as num?)?.toDouble() ?? 0,
      vndEntrega: map['VND_ENTREGA'] as int?,
      vndNEntrega: map['VND_NENTREGA'] as String?,
      vndLatitude: (map['VND_LATITUDE'] as num?)?.toDouble(),
      vndLongitude: (map['VND_LONGITUDE'] as num?)?.toDouble(),
      vndTabela: map['VND_TABELA'] as int?,
      vndUf: map['VND_UF'] as String?,
      vndCidade: map['VND_CIDADEENT'] as String?,
      vndEnderecoEnt: map['VND_ENDERECOENT'] as String?,
      vndNumeroEnt: map['VND_NUMEROENT'] as String?,
      vndBairroEnt: map['VND_BAIRROENT'] as String?,
      vndCidadeEnt: map['VND_CIDADEENT'] as String?,
      vndEstadoEnt: map['VND_ESTADOENT'] as String?,
      vndCepEnt: map['VND_CEPENT'] as String?,
      vndComplEnt: map['VND_COMPLENT'] as String?,
      vndEmail: map['VND_EMAIL'] as String?,
      vndPrAcrescimo: (map['VND_PRACRESCIMO'] as num?)?.toDouble() ?? 0,
      vndPrDesconto: (map['VND_PRDESCONTO'] as num?)?.toDouble() ?? 0,
      vndCliCod: (map['VND_CLI_CODIGO'] as int?) ?? 0,
      vndSincronia: map['VND_SINCRONIA'] as String?,
      vndAtualizacao: map['VND_ATUALIZACAO'] != null
          ? Utils().parseDateFlexivel(map['VND_ATUALIZACAO'] as String)
          : null,
      vndParcelas: map['VND_PARCELAS'] as int?,
      vndTotalBonificacao:
          (map['VND_TOTALBONIFICACAO'] as num?)?.toDouble() ?? 0,
      vndSaldoBonificacao:
          (map['VND_SALDOBONIFICACAO'] as num?)?.toDouble() ?? 0,
      itens: map['ITENS'] != null
          ? (map['ITENS'] as List).map((i) => VendaItem.fromMapAPI(i)).toList()
          : [], // Mapeia os itens se existirem
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'VND_ID': vndId,
      'VND_CHAVE': vndChave,
      'VND_DATAHORA': DateFormat('yyyy-MM-dd HH:mm:ss').format(vndDataHora),
      'VND_PREVENT': vndPrevent != null
          ? DateFormat('yyyy-MM-dd').format(vndPrevent!)
          : null,
      'VND_VEND': vndVend,
      'VND_VENDNOME': vndVendNome,
      'VND_CLI_CNPJ': vndCliCnpj,
      'VND_CLI_NOME': vndCliNome,
      'VND_CLI_FANT': vndCliFant,
      'VND_FORMAPAGTO': vndFormaPagto,
      'VND_FORMANOME': vndFormaNome,
      'VND_MEIO': vndMeio,
      'VND_MEIONOME': vndMeioNome,
      'VND_VALOR': vndValor,
      'VND_DESCONTO': vndDesconto,
      'VND_FRETE': vndFrete,
      'VND_TOTALST': vndTotalSt,
      'VND_TOTALIPI': vndTotalIpi,
      'VND_TOTAL': vndTotal,
      'VND_OBS': vndObs,
      'VND_ENVIADO': vndEnviado,
      'VND_PESO': vndPeso,
      'VND_ENTREGA': vndEntrega,
      'VND_NENTREGA': vndNEntrega,
      'VND_LATITUDE': vndLatitude,
      'VND_LONGITUDE': vndLongitude,
      'VND_TABELA': vndTabela,
      'VND_UF': vndUf,
      'VND_CIDADE': vndCidade,
      'VND_ENDERECOENT': vndEnderecoEnt,
      'VND_NUMEROENT': vndNumeroEnt,
      'VND_BAIRROENT': vndBairroEnt,
      'VND_CIDADEENT': vndCidadeEnt,
      'VND_ESTADOENT': vndEstadoEnt,
      'VND_CEPENT': vndCepEnt,
      'VND_COMPLENT': vndComplEnt,
      'VND_EMAIL': vndEmail,
      'VND_PRACRESCIMO': vndPrAcrescimo,
      'VND_PRDESCONTO': vndPrDesconto,
      'VND_CLI_COD': vndCliCod,
      'VND_SINCRONIA': vndSincronia,
      'VND_ATUALIZACAO': vndAtualizacao != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(vndAtualizacao!)
          : null,
      'VND_PARCELAS': vndParcelas,
      'VND_TOTALBONIFICACAO': vndTotalBonificacao,
      'VND_SALDOBONIFICACAO': vndSaldoBonificacao,
      'ITENS': itens
          .map((item) => item.toMap())
          .toList(), // Converte os itens para mapas
    };
  }

  Venda copyWith({
    int? vndId,
    String? vndChave,
    DateTime? vndDataHora,
    DateTime? vndPrevent,
    int? vndVend,
    String? vndVendNome,
    String? vndCliCnpj,
    String? vndCliNome,
    String? vndCliFant,
    int? vndFormaPagto,
    String? vndFormaNome,
    int? vndMeio,
    String? vndMeioNome,
    double? vndValor,
    double? vndDesconto,
    double? vndFrete,
    double? vndTotalSt,
    double? vndTotalIpi,
    double? vndTotal,
    String? vndObs,
    String? vndEnviado,
    double? vndPeso,
    int? vndEntrega,
    String? vndNEntrega,
    double? vndLatitude,
    double? vndLongitude,
    int? vndTabela,
    String? vndUf,
    String? vndCidade,
    String? vndEnderecoEnt,
    String? vndNumeroEnt,
    String? vndBairroEnt,
    String? vndCidadeEnt,
    String? vndEstadoEnt,
    String? vndCepEnt,
    String? vndComplEnt,
    String? vndEmail,
    double? vndPrAcrescimo,
    double? vndPrDesconto,
    int? vndCliCod,
    String? vndSincronia,
    DateTime? vndAtualizacao,
    int? vndParcelas,
    double? vndTotalBonificacao,
    double? vndSaldoBonificacao,
    List<VendaItem>? itens, // Novo parâmetro no copyWith
  }) {
    return Venda(
      vndId: vndId ?? this.vndId,
      vndChave: vndChave ?? this.vndChave,
      vndDataHora: vndDataHora ?? this.vndDataHora,
      vndPrevent: vndPrevent ?? this.vndPrevent,
      vndVend: vndVend ?? this.vndVend,
      vndVendNome: vndVendNome ?? this.vndVendNome,
      vndCliCnpj: vndCliCnpj ?? this.vndCliCnpj,
      vndCliNome: vndCliNome ?? this.vndCliNome,
      vndCliFant: vndCliFant ?? this.vndCliFant,
      vndFormaPagto: vndFormaPagto ?? this.vndFormaPagto,
      vndFormaNome: vndFormaNome ?? this.vndFormaNome,
      vndMeio: vndMeio ?? this.vndMeio,
      vndMeioNome: vndMeioNome ?? this.vndMeioNome,
      vndValor: vndValor ?? this.vndValor,
      vndDesconto: vndDesconto ?? this.vndDesconto,
      vndFrete: vndFrete ?? this.vndFrete,
      vndTotalSt: vndTotalSt ?? this.vndTotalSt,
      vndTotalIpi: vndTotalIpi ?? this.vndTotalIpi,
      vndTotal: vndTotal ?? this.vndTotal,
      vndObs: vndObs ?? this.vndObs,
      vndEnviado: vndEnviado ?? this.vndEnviado,
      vndPeso: vndPeso ?? this.vndPeso,
      vndEntrega: vndEntrega ?? this.vndEntrega,
      vndNEntrega: vndNEntrega ?? this.vndNEntrega,
      vndLatitude: vndLatitude ?? this.vndLatitude,
      vndLongitude: vndLongitude ?? this.vndLongitude,
      vndTabela: vndTabela ?? this.vndTabela,
      vndUf: vndUf ?? this.vndUf,
      vndCidade: vndCidade ?? this.vndCidade,
      vndEnderecoEnt: vndEnderecoEnt ?? this.vndEnderecoEnt,
      vndNumeroEnt: vndNumeroEnt ?? this.vndNumeroEnt,
      vndBairroEnt: vndBairroEnt ?? this.vndBairroEnt,
      vndCidadeEnt: vndCidadeEnt ?? this.vndCidadeEnt,
      vndEstadoEnt: vndEstadoEnt ?? this.vndEstadoEnt,
      vndCepEnt: vndCepEnt ?? this.vndCepEnt,
      vndComplEnt: vndComplEnt ?? this.vndComplEnt,
      vndEmail: vndEmail ?? this.vndEmail,
      vndPrAcrescimo: vndPrAcrescimo ?? this.vndPrAcrescimo,
      vndPrDesconto: vndPrDesconto ?? this.vndPrDesconto,
      vndCliCod: vndCliCod ?? this.vndCliCod,
      vndSincronia: vndSincronia ?? this.vndSincronia,
      vndAtualizacao: vndAtualizacao ?? this.vndAtualizacao,
      vndParcelas: vndParcelas ?? this.vndParcelas,
      vndTotalBonificacao: vndTotalBonificacao ?? this.vndTotalBonificacao,
      vndSaldoBonificacao: vndSaldoBonificacao ?? this.vndSaldoBonificacao,
      itens: itens ?? this.itens, // Copia os itens ou mantém os existentes
    );
  }
}
