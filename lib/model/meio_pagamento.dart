class MeioPagamento {
  final int mpId;
  final String mpDesc;
  final String mpAtivo;

  MeioPagamento({
    required this.mpId,
    required this.mpDesc,
    this.mpAtivo = 'S',
  });

  factory MeioPagamento.fromMap(Map<String, dynamic> map) {
    return MeioPagamento(
      mpId: map['MP_ID'] as int,
      mpDesc: map['MP_DESC'] as String,
      mpAtivo: map['MP_ATIVO'] as String? ?? 'S',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MP_ID': mpId,
      'MP_DESC': mpDesc,
      'MP_ATIVO': mpAtivo,
    };
  }

  MeioPagamento copyWith({
    int? mpId,
    String? mpDesc,
    String? mpAtivo,
  }) {
    return MeioPagamento(
      mpId: mpId ?? this.mpId,
      mpDesc: mpDesc ?? this.mpDesc,
      mpAtivo: mpAtivo ?? this.mpAtivo,
    );
  }

  @override
  String toString() {
    return 'MeioPagamento(mpId: $mpId, mpDesc: $mpDesc, mpAtivo: $mpAtivo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeioPagamento &&
        other.mpId == mpId &&
        other.mpDesc == mpDesc &&
        other.mpAtivo == mpAtivo;
  }

  @override
  int get hashCode => mpId.hashCode ^ mpDesc.hashCode ^ mpAtivo.hashCode;
}
