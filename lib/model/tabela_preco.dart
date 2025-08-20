class TabelaPreco {
  final int tbId;
  final int tbProd;
  final double? tbPercent;

  TabelaPreco({
    required this.tbId,
    required this.tbProd,
    this.tbPercent,
  });

  factory TabelaPreco.fromMap(Map<String, dynamic> map) {
    return TabelaPreco(
      tbId: map['TB_ID'] as int,
      tbProd: map['TB_PROD'] as int,
      tbPercent: (map['TB_PERCENT'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TB_ID': tbId,
      'TB_PROD': tbProd,
      'TB_PERCENT': tbPercent,
    };
  }

  TabelaPreco copyWith({
    int? tbId,
    int? tbProd,
    double? tbPercent,
  }) {
    return TabelaPreco(
      tbId: tbId ?? this.tbId,
      tbProd: tbProd ?? this.tbProd,
      tbPercent: tbPercent ?? this.tbPercent,
    );
  }

  @override
  String toString() {
    return 'TabelaPreco(tbId: $tbId, tbProd: $tbProd, tbPercent: $tbPercent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TabelaPreco &&
        other.tbId == tbId &&
        other.tbProd == tbProd &&
        other.tbPercent == tbPercent;
  }

  @override
  int get hashCode => tbId.hashCode ^ tbProd.hashCode ^ tbPercent.hashCode;
}
