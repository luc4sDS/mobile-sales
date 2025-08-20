class FormaMeio {
  final int fmForma;
  final int fmMeio;

  FormaMeio({
    required this.fmForma,
    required this.fmMeio,
  });

  factory FormaMeio.fromMap(Map<String, dynamic> map) {
    return FormaMeio(
      fmForma: map['FM_FORMA'] as int,
      fmMeio: map['FM_MEIO'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FM_FORMA': fmForma,
      'FM_MEIO': fmMeio,
    };
  }

  FormaMeio copyWith({
    int? fmForma,
    int? fmMeio,
  }) {
    return FormaMeio(
      fmForma: fmForma ?? this.fmForma,
      fmMeio: fmMeio ?? this.fmMeio,
    );
  }

  @override
  String toString() {
    return 'FormaMeio(fmForma: $fmForma, fmMeio: $fmMeio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormaMeio &&
        other.fmForma == fmForma &&
        other.fmMeio == fmMeio;
  }

  @override
  int get hashCode => fmForma.hashCode ^ fmMeio.hashCode;
}
