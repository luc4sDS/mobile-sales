class ProdutoSt {
  final int pstProd;
  final String pstEstado;
  final double? pstMargem;
  final double? pstIcmsintra;
  final double? pstIcmsinter;
  final double? pstReducao;

  ProdutoSt({
    required this.pstProd,
    required this.pstEstado,
    this.pstMargem,
    this.pstIcmsintra,
    this.pstIcmsinter,
    this.pstReducao,
  });

  factory ProdutoSt.fromMap(Map<String, dynamic> map) {
    return ProdutoSt(
      pstProd: map['PST_PROD'] as int,
      pstEstado: map['PST_ESTADO'] as String,
      pstMargem: (map['PST_MARGEM'] as num?)?.toDouble(),
      pstIcmsintra: (map['PST_ICMSINTRA'] as num?)?.toDouble(),
      pstIcmsinter: (map['PST_ICMSINTER'] as num?)?.toDouble(),
      pstReducao: (map['PST_REDUCAO'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PST_PROD': pstProd,
      'PST_ESTADO': pstEstado,
      'PST_MARGEM': pstMargem,
      'PST_ICMSINTRA': pstIcmsintra,
      'PST_ICMSINTER': pstIcmsinter,
      'PST_REDUCAO': pstReducao,
    };
  }

  ProdutoSt copyWith({
    int? pstProd,
    String? pstEstado,
    double? pstMargem,
    double? pstIcmsintra,
    double? pstIcmsinter,
    double? pstReducao,
  }) {
    return ProdutoSt(
      pstProd: pstProd ?? this.pstProd,
      pstEstado: pstEstado ?? this.pstEstado,
      pstMargem: pstMargem ?? this.pstMargem,
      pstIcmsintra: pstIcmsintra ?? this.pstIcmsintra,
      pstIcmsinter: pstIcmsinter ?? this.pstIcmsinter,
      pstReducao: pstReducao ?? this.pstReducao,
    );
  }

  @override
  String toString() {
    return 'ProdutoSt('
        'pstProd: $pstProd, '
        'pstEstado: $pstEstado, '
        'pstMargem: $pstMargem, '
        'pstIcmsintra: $pstIcmsintra, '
        'pstIcmsinter: $pstIcmsinter, '
        'pstReducao: $pstReducao)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProdutoSt &&
        other.pstProd == pstProd &&
        other.pstEstado == pstEstado &&
        other.pstMargem == pstMargem &&
        other.pstIcmsintra == pstIcmsintra &&
        other.pstIcmsinter == pstIcmsinter &&
        other.pstReducao == pstReducao;
  }

  @override
  int get hashCode {
    return pstProd.hashCode ^
        pstEstado.hashCode ^
        pstMargem.hashCode ^
        pstIcmsintra.hashCode ^
        pstIcmsinter.hashCode ^
        pstReducao.hashCode;
  }
}
