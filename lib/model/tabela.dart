class TabelaPrecoCabecalho {
  final int tbId;
  final String tbDesc;
  final String tbAtivo;

  TabelaPrecoCabecalho({
    required this.tbId,
    required this.tbDesc,
    this.tbAtivo = 'S',
  });

  factory TabelaPrecoCabecalho.fromMap(Map<String, dynamic> map) {
    return TabelaPrecoCabecalho(
      tbId: map['TB_ID'] as int,
      tbDesc: map['TB_DESC'] as String,
      tbAtivo: map['TB_ATIVO'] as String? ?? 'S',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TB_ID': tbId,
      'TB_DESC': tbDesc,
      'TB_ATIVO': tbAtivo,
    };
  }

  TabelaPrecoCabecalho copyWith({
    int? tbId,
    String? tbDesc,
    String? tbAtivo,
  }) {
    return TabelaPrecoCabecalho(
      tbId: tbId ?? this.tbId,
      tbDesc: tbDesc ?? this.tbDesc,
      tbAtivo: tbAtivo ?? this.tbAtivo,
    );
  }

  @override
  String toString() {
    return 'TabelaPrecoCabecalho(tbpId: $tbId, tbDesc: $tbDesc, tbAtivo: $tbAtivo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TabelaPrecoCabecalho &&
        other.tbId == tbId &&
        other.tbDesc == tbDesc &&
        other.tbAtivo == tbAtivo;
  }

  @override
  int get hashCode => tbId.hashCode ^ tbDesc.hashCode ^ tbAtivo.hashCode;
}
