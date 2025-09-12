import 'package:mobile_sales/utils/utils.dart';

class UltimasVendas {
  final DateTime uvEmissao;
  final int uvProdCod;
  final String uvProdNome;
  final double uvQtd;
  final double uvUnitario;
  final int uvVndId;
  final double uvTotalG;

  const UltimasVendas({
    required this.uvEmissao,
    required this.uvProdCod,
    required this.uvProdNome,
    required this.uvQtd,
    required this.uvUnitario,
    required this.uvVndId,
    required this.uvTotalG,
  });

  factory UltimasVendas.fromMapApi(Map<String, dynamic> map) {
    return UltimasVendas(
      uvEmissao: Utils().parseDateFlexivel(map['emissao'] as String),
      uvProdCod: map['codigo'] as int? ?? 0,
      uvProdNome: map['nomeproduto'] as String? ?? '',
      uvQtd: (map['qtd'] as num?)?.toDouble() ?? 0.0,
      uvUnitario: (map['unit'] as num?)?.toDouble() ?? 0.0,
      uvVndId: map['sequen'] as int? ?? 0,
      uvTotalG: (map['totalg'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory UltimasVendas.fromMap(Map<String, dynamic> map) {
    return UltimasVendas(
      uvEmissao: Utils().parseDateFlexivel(map['UV_EMISSAO'] as String),
      uvProdCod: map['UV_PROD_COD'] as int? ?? 0,
      uvProdNome: map['UV_PROD_NOME'] as String? ?? '',
      uvQtd: (map['UV_QTD'] as num?)?.toDouble() ?? 0.0,
      uvUnitario: (map['UV_UNITARIO'] as num?)?.toDouble() ?? 0.0,
      uvVndId: map['UV_VND_ID'] as int? ?? 0,
      uvTotalG: (map['UV_TOTALG'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'UV_EMISSAO': uvEmissao,
      'UV_PROD_COD': uvProdCod,
      'UV_PROD_NOME': uvProdNome,
      'UV_QTD': uvQtd,
      'UV_UNITARIO': uvUnitario,
      'UV_VND_ID': uvVndId,
      'UV_TOTALG': uvTotalG,
    };
  }

  UltimasVendas copyWith({
    DateTime? uvEmissao,
    int? uvProdCod,
    String? uvProdNome,
    double? uvQtd,
    double? uvUnitario,
    int? uvVndId,
    double? uvTotalG,
  }) {
    return UltimasVendas(
      uvEmissao: uvEmissao ?? this.uvEmissao,
      uvProdCod: uvProdCod ?? this.uvProdCod,
      uvProdNome: uvProdNome ?? this.uvProdNome,
      uvQtd: uvQtd ?? this.uvQtd,
      uvUnitario: uvUnitario ?? this.uvUnitario,
      uvVndId: uvVndId ?? this.uvVndId,
      uvTotalG: uvTotalG ?? this.uvTotalG,
    );
  }
}
