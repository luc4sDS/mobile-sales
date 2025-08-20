class TipoEntrega {
  final int tpId;
  final String tpDesc;
  final String tpEntrega;
  final String tpAtivo;

  TipoEntrega({
    required this.tpId,
    required this.tpDesc,
    this.tpEntrega = 'S', // Padrão 'S' (Sim)
    this.tpAtivo = 'S', // Padrão 'S' (Ativo)
  });

  factory TipoEntrega.fromMap(Map<String, dynamic> map) {
    return TipoEntrega(
      tpId: map['TP_ID'] as int,
      tpDesc: map['TP_DESC'] as String,
      tpEntrega: map['TP_ENTREGA'] as String? ?? 'S',
      tpAtivo: map['TP_ATIVO'] as String? ?? 'S',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TP_ID': tpId,
      'TP_DESC': tpDesc,
      'TP_ENTREGA': tpEntrega,
      'TP_ATIVO': tpAtivo,
    };
  }

  TipoEntrega copyWith({
    int? tpId,
    String? tpDesc,
    String? tpEntrega,
    String? tpAtivo,
  }) {
    return TipoEntrega(
      tpId: tpId ?? this.tpId,
      tpDesc: tpDesc ?? this.tpDesc,
      tpEntrega: tpEntrega ?? this.tpEntrega,
      tpAtivo: tpAtivo ?? this.tpAtivo,
    );
  }

  @override
  String toString() {
    return 'TipoEntrega(tpId: $tpId, tpDesc: $tpDesc, tpEntrega: $tpEntrega, tpAtivo: $tpAtivo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TipoEntrega &&
        other.tpId == tpId &&
        other.tpDesc == tpDesc &&
        other.tpEntrega == tpEntrega &&
        other.tpAtivo == tpAtivo;
  }

  @override
  int get hashCode {
    return tpId.hashCode ^
        tpDesc.hashCode ^
        tpEntrega.hashCode ^
        tpAtivo.hashCode;
  }
}
