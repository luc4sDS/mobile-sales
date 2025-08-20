import 'package:intl/intl.dart';

class VendaFinanceiro {
  final int vfId;
  final int vfVndId;
  final int vfLanc;
  final DateTime vfVenc;
  final double vfValor;
  final int vfMeio;
  final String vfNmeio;

  VendaFinanceiro({
    required this.vfId,
    required this.vfVndId,
    required this.vfLanc,
    required this.vfVenc,
    required this.vfValor,
    required this.vfMeio,
    required this.vfNmeio,
  });

  factory VendaFinanceiro.fromMap(Map<String, dynamic> map) {
    return VendaFinanceiro(
      vfId: map['VF_ID'] as int,
      vfVndId: map['VF_VND_ID'] as int,
      vfLanc: map['VF_LANC'] as int,
      vfVenc: DateTime.parse(map['VF_VENC'] as String),
      vfValor: (map['VF_VALOR'] as num).toDouble(),
      vfMeio: map['VF_MEIO'] as int,
      vfNmeio: map['VF_NMEIO'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'VF_ID': vfId,
      'VF_VND_ID': vfVndId,
      'VF_LANC': vfLanc,
      'VF_VENC': DateFormat('yyyy-MM-dd').format(vfVenc),
      'VF_VALOR': vfValor,
      'VF_MEIO': vfMeio,
      'VF_NMEIO': vfNmeio,
    };
  }

  VendaFinanceiro copyWith({
    int? vfId,
    int? vfVndId,
    int? vfLanc,
    DateTime? vfVenc,
    double? vfValor,
    int? vfMeio,
    String? vfNmeio,
  }) {
    return VendaFinanceiro(
      vfId: vfId ?? this.vfId,
      vfVndId: vfVndId ?? this.vfVndId,
      vfLanc: vfLanc ?? this.vfLanc,
      vfVenc: vfVenc ?? this.vfVenc,
      vfValor: vfValor ?? this.vfValor,
      vfMeio: vfMeio ?? this.vfMeio,
      vfNmeio: vfNmeio ?? this.vfNmeio,
    );
  }

  @override
  String toString() {
    return 'VendaFinanceiro('
        'vfId: $vfId, '
        'vfVndId: $vfVndId, '
        'vfLanc: $vfLanc, '
        'vfVenc: ${DateFormat('dd/MM/yyyy').format(vfVenc)}, '
        'vfValor: $vfValor, '
        'vfMeio: $vfMeio, '
        'vfNmeio: $vfNmeio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VendaFinanceiro &&
        other.vfId == vfId &&
        other.vfVndId == vfVndId &&
        other.vfLanc == vfLanc &&
        other.vfVenc == vfVenc &&
        other.vfValor == vfValor &&
        other.vfMeio == vfMeio &&
        other.vfNmeio == vfNmeio;
  }

  @override
  int get hashCode {
    return vfId.hashCode ^
        vfVndId.hashCode ^
        vfLanc.hashCode ^
        vfVenc.hashCode ^
        vfValor.hashCode ^
        vfMeio.hashCode ^
        vfNmeio.hashCode;
  }
}
