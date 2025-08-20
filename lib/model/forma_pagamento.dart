class FormaPagamento {
  final int fpId;
  final String fpDesc;
  final String fpAtv;
  final double fpVmin;
  final double fpJuros;
  final int fpNparcelas;
  final int fpDias;
  final String fpTipo;

  FormaPagamento({
    required this.fpId,
    required this.fpDesc,
    this.fpAtv = 'S',
    this.fpVmin = 0,
    this.fpJuros = 0,
    this.fpNparcelas = 1,
    this.fpDias = 0,
    required this.fpTipo,
  });

  factory FormaPagamento.fromMap(Map<String, dynamic> map) {
    return FormaPagamento(
      fpId: map['FP_ID'] as int,
      fpDesc: map['FP_DESC'] as String,
      fpAtv: map['FP_ATV'] as String? ?? 'S',
      fpVmin: (map['FP_VMIN'] as num?)?.toDouble() ?? 0,
      fpJuros: (map['FP_JUROS'] as num?)?.toDouble() ?? 0,
      fpNparcelas: map['FP_NPARCELAS'] as int? ?? 1,
      fpDias: map['FP_DIAS'] as int? ?? 0,
      fpTipo: map['FP_TIPO'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FP_ID': fpId,
      'FP_DESC': fpDesc,
      'FP_ATV': fpAtv,
      'FP_VMIN': fpVmin,
      'FP_JUROS': fpJuros,
      'FP_NPARCELAS': fpNparcelas,
      'FP_DIAS': fpDias,
      'FP_TIPO': fpTipo,
    };
  }

  FormaPagamento copyWith({
    int? fpId,
    String? fpDesc,
    String? fpAtv,
    double? fpVmin,
    double? fpJuros,
    int? fpNparcelas,
    int? fpDias,
    String? fpTipo,
  }) {
    return FormaPagamento(
      fpId: fpId ?? this.fpId,
      fpDesc: fpDesc ?? this.fpDesc,
      fpAtv: fpAtv ?? this.fpAtv,
      fpVmin: fpVmin ?? this.fpVmin,
      fpJuros: fpJuros ?? this.fpJuros,
      fpNparcelas: fpNparcelas ?? this.fpNparcelas,
      fpDias: fpDias ?? this.fpDias,
      fpTipo: fpTipo ?? this.fpTipo,
    );
  }

  @override
  String toString() {
    return 'FormaPagamento('
        'fpId: $fpId, '
        'fpDesc: $fpDesc, '
        'fpAtv: $fpAtv, '
        'fpVmin: $fpVmin, '
        'fpJuros: $fpJuros, '
        'fpNparcelas: $fpNparcelas, '
        'fpDias: $fpDias, '
        'fpTipo: $fpTipo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormaPagamento &&
        other.fpId == fpId &&
        other.fpDesc == fpDesc &&
        other.fpAtv == fpAtv &&
        other.fpVmin == fpVmin &&
        other.fpJuros == fpJuros &&
        other.fpNparcelas == fpNparcelas &&
        other.fpDias == fpDias &&
        other.fpTipo == fpTipo;
  }

  @override
  int get hashCode {
    return fpId.hashCode ^
        fpDesc.hashCode ^
        fpAtv.hashCode ^
        fpVmin.hashCode ^
        fpJuros.hashCode ^
        fpNparcelas.hashCode ^
        fpDias.hashCode ^
        fpTipo.hashCode;
  }
}
