import 'dart:typed_data';

class Produto {
  final int prodId;
  final String prodDescricao;
  final double prodPreco;
  final String? prodCbarra;
  final String? prodGrupo;
  final String? prodSubgrupo;
  final String? prodMarca;
  final double prodLimdesc;
  final String? prodBonifica;
  final Uint8List? prodImg;
  final String? prodCor;
  final String? prodDevolve;
  final String prodAtivo;
  final String? prodDescricaotec;
  final String? prodEmbalagem;
  final double? prodSaldo;
  final double? prodPbonificacao;
  final String? prodCorte;
  final String? prodCorte1;
  final double? prodPmin;

  Produto({
    required this.prodId,
    required this.prodDescricao,
    required this.prodPreco,
    this.prodCbarra,
    this.prodGrupo,
    this.prodSubgrupo,
    this.prodMarca,
    this.prodLimdesc = 0,
    this.prodBonifica = 'N',
    this.prodImg,
    this.prodCor,
    this.prodDevolve = 'N',
    this.prodAtivo = 'S',
    this.prodDescricaotec,
    this.prodEmbalagem,
    this.prodSaldo,
    this.prodPbonificacao,
    this.prodCorte = 'N',
    this.prodCorte1 = 'N',
    this.prodPmin,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      prodId: map['PROD_ID'] as int,
      prodDescricao: map['PROD_DESCRICAO'] as String,
      prodPreco: (map['PROD_PRECO'] as num?)?.toDouble() ?? 0,
      prodCbarra: map['PROD_CBARRA'] as String?,
      prodGrupo: map['PROD_GRUPO'] as String?,
      prodSubgrupo: map['PROD_SUBGRUPO'] as String?,
      prodMarca: map['PROD_MARCA'] as String?,
      prodLimdesc: (map['PROD_LIMDESC'] as num?)?.toDouble() ?? 0,
      prodBonifica: map['PROD_BONIFICA'] as String? ?? 'N',
      prodImg: map['PROD_IMG'] as Uint8List?,
      prodCor: map['PROD_COR'] as String?,
      prodDevolve: map['PROD_DEVOLVE'] as String? ?? 'N',
      prodAtivo: map['PROD_ATIVO'] as String? ?? 'S',
      prodDescricaotec: map['PROD_DESCRICAOTEC'] as String?,
      prodEmbalagem: map['PROD_EMBALAGEM'] as String?,
      prodSaldo: (map['PROD_SALDO'] as num?)?.toDouble(),
      prodPbonificacao: (map['PROD_PBONIFICACAO'] as num?)?.toDouble(),
      prodCorte: map['PROD_CORTE'] as String? ?? 'N',
      prodCorte1: map['PROD_CORTE1'] as String? ?? 'N',
      prodPmin: (map['PROD_PMIN'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PROD_ID': prodId,
      'PROD_DESCRICAO': prodDescricao,
      'PROD_PRECO': prodPreco,
      'PROD_CBARRA': prodCbarra,
      'PROD_GRUPO': prodGrupo,
      'PROD_SUBGRUPO': prodSubgrupo,
      'PROD_MARCA': prodMarca,
      'PROD_LIMDESC': prodLimdesc,
      'PROD_BONIFICA': prodBonifica,
      'PROD_IMG': prodImg,
      'PROD_COR': prodCor,
      'PROD_DEVOLVE': prodDevolve,
      'PROD_ATIVO': prodAtivo,
      'PROD_DESCRICAOTEC': prodDescricaotec,
      'PROD_EMBALAGEM': prodEmbalagem,
      'PROD_SALDO': prodSaldo,
      'PROD_PBONIFICACAO': prodPbonificacao,
      'PROD_CORTE': prodCorte,
      'PROD_CORTE1': prodCorte1,
      'PROD_PMIN': prodPmin,
    };
  }

  Produto copyWith({
    int? prodId,
    String? prodDescricao,
    double? prodPreco,
    String? prodCbarra,
    String? prodGrupo,
    String? prodSubgrupo,
    String? prodMarca,
    double? prodLimdesc,
    String? prodBonifica,
    Uint8List? prodImg,
    String? prodCor,
    String? prodDevolve,
    String? prodAtivo,
    String? prodDescricaotec,
    String? prodEmbalagem,
    double? prodSaldo,
    double? prodPbonificacao,
    String? prodCorte,
    String? prodCorte1,
    double? prodPmin,
  }) {
    return Produto(
      prodId: prodId ?? this.prodId,
      prodDescricao: prodDescricao ?? this.prodDescricao,
      prodPreco: prodPreco ?? this.prodPreco,
      prodCbarra: prodCbarra ?? this.prodCbarra,
      prodGrupo: prodGrupo ?? this.prodGrupo,
      prodSubgrupo: prodSubgrupo ?? this.prodSubgrupo,
      prodMarca: prodMarca ?? this.prodMarca,
      prodLimdesc: prodLimdesc ?? this.prodLimdesc,
      prodBonifica: prodBonifica ?? this.prodBonifica,
      prodImg: prodImg ?? this.prodImg,
      prodCor: prodCor ?? this.prodCor,
      prodDevolve: prodDevolve ?? this.prodDevolve,
      prodAtivo: prodAtivo ?? this.prodAtivo,
      prodDescricaotec: prodDescricaotec ?? this.prodDescricaotec,
      prodEmbalagem: prodEmbalagem ?? this.prodEmbalagem,
      prodSaldo: prodSaldo ?? this.prodSaldo,
      prodPbonificacao: prodPbonificacao ?? this.prodPbonificacao,
      prodCorte: prodCorte ?? this.prodCorte,
      prodCorte1: prodCorte1 ?? this.prodCorte1,
      prodPmin: prodPmin ?? this.prodPmin,
    );
  }

  @override
  String toString() {
    return 'Produto('
        'prodId: $prodId, '
        'prodDescricao: $prodDescricao, '
        'prodPreco: $prodPreco, '
        'prodCbarra: $prodCbarra, '
        'prodGrupo: $prodGrupo, '
        'prodSubgrupo: $prodSubgrupo, '
        'prodMarca: $prodMarca)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Produto &&
        other.prodId == prodId &&
        other.prodDescricao == prodDescricao &&
        other.prodPreco == prodPreco &&
        other.prodCbarra == prodCbarra &&
        other.prodGrupo == prodGrupo &&
        other.prodSubgrupo == prodSubgrupo &&
        other.prodMarca == prodMarca &&
        other.prodLimdesc == prodLimdesc &&
        other.prodBonifica == prodBonifica &&
        other.prodCor == prodCor &&
        other.prodDevolve == prodDevolve &&
        other.prodAtivo == prodAtivo &&
        other.prodDescricaotec == prodDescricaotec &&
        other.prodEmbalagem == prodEmbalagem &&
        other.prodSaldo == prodSaldo &&
        other.prodPbonificacao == prodPbonificacao &&
        other.prodCorte == prodCorte &&
        other.prodCorte1 == prodCorte1 &&
        other.prodPmin == prodPmin;
  }

  @override
  int get hashCode {
    return prodId.hashCode ^
        prodDescricao.hashCode ^
        prodPreco.hashCode ^
        prodCbarra.hashCode ^
        prodGrupo.hashCode ^
        prodSubgrupo.hashCode ^
        prodMarca.hashCode ^
        prodLimdesc.hashCode ^
        prodBonifica.hashCode ^
        prodCor.hashCode ^
        prodDevolve.hashCode ^
        prodAtivo.hashCode ^
        prodDescricaotec.hashCode ^
        prodEmbalagem.hashCode ^
        prodSaldo.hashCode ^
        prodPbonificacao.hashCode ^
        prodCorte.hashCode ^
        prodCorte1.hashCode ^
        prodPmin.hashCode;
  }
}
