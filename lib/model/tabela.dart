class TabelaPrecoCabecalho {
  final int tbpId;
  final String tbpDesc;
  final String tbpAtivo;

  TabelaPrecoCabecalho({
    required this.tbpId,
    required this.tbpDesc,
    this.tbpAtivo = 'S',
  });

  factory TabelaPrecoCabecalho.fromMap(Map<String, dynamic> map) {
    return TabelaPrecoCabecalho(
      tbpId: map['TBP_ID'] as int,
      tbpDesc: map['TBP_DESC'] as String,
      tbpAtivo: map['TBP_ATIVO'] as String? ?? 'S',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TBP_ID': tbpId,
      'TBP_DESC': tbpDesc,
      'TBP_ATIVO': tbpAtivo,
    };
  }

  TabelaPrecoCabecalho copyWith({
    int? tbpId,
    String? tbpDesc,
    String? tbpAtivo,
  }) {
    return TabelaPrecoCabecalho(
      tbpId: tbpId ?? this.tbpId,
      tbpDesc: tbpDesc ?? this.tbpDesc,
      tbpAtivo: tbpAtivo ?? this.tbpAtivo,
    );
  }

  @override
  String toString() {
    return 'TabelaPrecoCabecalho(tbpId: $tbpId, tbpDesc: $tbpDesc, tbpAtivo: $tbpAtivo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TabelaPrecoCabecalho &&
        other.tbpId == tbpId &&
        other.tbpDesc == tbpDesc &&
        other.tbpAtivo == tbpAtivo;
  }

  @override
  int get hashCode => tbpId.hashCode ^ tbpDesc.hashCode ^ tbpAtivo.hashCode;
}
