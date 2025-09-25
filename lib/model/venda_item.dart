class VendaItem {
  final int? vdiId;
  final int vdiVndId;
  final String? vdiVndChave;
  final String? vdiEan;
  final int vdiProdCod;
  final String vdiDescricao;
  final String vdiTipo;
  final double vdiQtd;
  final double vdiUnit;
  final double vdiTotal;
  final double vdiDesc;
  final double vdiAlintra;
  final double vdiAlinter;
  final double vdiAlipi;
  final double vdiMva;
  final double vdiRedbase;
  final double vdiVlst;
  final double vdiVlipi;
  final double vdiTotalg;
  final double vdiPreco;
  final double vdiPeso;
  final double vdiCusto;
  final String? vdiObs;
  final double vdiPbonificacao;
  final double vdiVbonificacao;
  final bool vdiBonificado;
  final String vdiLance;
  final double vdiPmin;

  VendaItem({
    this.vdiId,
    required this.vdiVndId,
    this.vdiVndChave,
    this.vdiEan,
    required this.vdiProdCod,
    required this.vdiDescricao,
    this.vdiTipo = 'P', // Padrão 'P' (Produto)
    required this.vdiQtd,
    required this.vdiUnit,
    required this.vdiTotal,
    this.vdiDesc = 0,
    this.vdiAlintra = 0,
    this.vdiAlinter = 0,
    this.vdiAlipi = 0,
    this.vdiMva = 0,
    this.vdiRedbase = 0,
    this.vdiVlst = 0,
    this.vdiVlipi = 0,
    required this.vdiTotalg,
    required this.vdiPreco,
    this.vdiPeso = 0,
    this.vdiCusto = 0,
    this.vdiObs,
    this.vdiPbonificacao = 0,
    this.vdiVbonificacao = 0,
    this.vdiBonificado = false,
    this.vdiLance = 'N',
    this.vdiPmin = 0,
  });

  factory VendaItem.fromMap(Map<String, dynamic> map) {
    return VendaItem(
      vdiId: map['VDI_ID'] as int?,
      vdiVndId: map['VDI_VND_ID'] as int,
      vdiVndChave: map['VDI_VND_CHAVE'] as String?,
      vdiEan: map['VDI_EAN'] as String?,
      vdiProdCod: map['VDI_PROD_COD'] as int,
      vdiDescricao: map['VDI_DESCRICAO'] as String,
      vdiTipo: map['VDI_TIPO'] as String? ?? 'P',
      vdiQtd: (map['VDI_QTD'] as num).toDouble(),
      vdiUnit: (map['VDI_UNIT'] as num).toDouble(),
      vdiTotal: (map['VDI_TOTAL'] as num).toDouble(),
      vdiDesc: (map['VDI_DESC'] as num?)?.toDouble() ?? 0,
      vdiAlintra: (map['VDI_ALINTRA'] as num?)?.toDouble() ?? 0,
      vdiAlinter: (map['VDI_ALINTER'] as num?)?.toDouble() ?? 0,
      vdiAlipi: (map['VDI_ALIPI'] as num?)?.toDouble() ?? 0,
      vdiMva: (map['VDI_MVA'] as num?)?.toDouble() ?? 0,
      vdiRedbase: (map['VDI_REDBASE'] as num?)?.toDouble() ?? 0,
      vdiVlst: (map['VDI_VLST'] as num?)?.toDouble() ?? 0,
      vdiVlipi: (map['VDI_VLIPI'] as num?)?.toDouble() ?? 0,
      vdiTotalg: (map['VDI_TOTALG'] as num).toDouble(),
      vdiPreco: (map['VDI_PRECO'] as num).toDouble(),
      vdiPeso: (map['VDI_PESO'] as num?)?.toDouble() ?? 0,
      vdiCusto: (map['VDI_CUSTO'] as num?)?.toDouble() ?? 0,
      vdiObs: map['VDI_OBS'] as String?,
      vdiPbonificacao: (map['VDI_PBONIFICACAO'] as num?)?.toDouble() ?? 0,
      vdiVbonificacao: (map['VDI_VBONIFICACAO'] as num?)?.toDouble() ?? 0,
      vdiBonificado: (map['VDI_BONIFICADO'] as int) == 1,
      vdiLance: map['VDI_LANCE'] as String? ?? 'N',
      vdiPmin: (map['VDI_PMIN'] as num?)?.toDouble() ?? 0,
    );
  }

  factory VendaItem.fromMapAPI(Map<String, dynamic> map) {
    return VendaItem(
      vdiId: map['VDI_ID'] as int?,
      vdiVndId: map['VDI_VND_ID'] as int,
      vdiVndChave: map['VDI_VND_CHAVE'] as String?,
      vdiEan: (map['VDI_EAN'] as int?) == null
          ? null
          : (map['VDI_EAN'] as int).toString(),
      vdiProdCod: map['VDI_PROD_COD'] as int,
      vdiDescricao: map['VDI_DESCRICAO'] as String,
      vdiTipo: map['VDI_TIPO'] as String? ?? 'P',
      vdiQtd: (map['VDI_QTD'] as num).toDouble(),
      vdiUnit: (map['VDI_UNIT'] as num).toDouble(),
      vdiTotal: (map['VDI_TOTAL'] as num).toDouble(),
      vdiDesc: (map['VDI_DESC'] as num?)?.toDouble() ?? 0,
      vdiAlintra: (map['VDI_ALINTRA'] as num?)?.toDouble() ?? 0,
      vdiAlinter: (map['VDI_ALINTER'] as num?)?.toDouble() ?? 0,
      vdiAlipi: (map['VDI_ALIPI'] as num?)?.toDouble() ?? 0,
      vdiMva: (map['VDI_MVA'] as num?)?.toDouble() ?? 0,
      vdiRedbase: (map['VDI_REDBASE'] as num?)?.toDouble() ?? 0,
      vdiVlst: (map['VDI_VLST'] as num?)?.toDouble() ?? 0,
      vdiVlipi: (map['VDI_VLIPI'] as num?)?.toDouble() ?? 0,
      vdiTotalg: (map['VDI_TOTALG'] as num).toDouble(),
      vdiPreco: (map['VDI_PRECO'] as num).toDouble(),
      vdiPeso: (map['VDI_PESO'] as num?)?.toDouble() ?? 0,
      vdiCusto: (map['VDI_CUSTO'] as num?)?.toDouble() ?? 0,
      vdiObs: map['VDI_OBS'] as String?,
      vdiPbonificacao: (map['VDI_PBONIFICACAO'] as num?)?.toDouble() ?? 0,
      vdiVbonificacao: (map['VDI_VBONIFICACAO'] as num?)?.toDouble() ?? 0,
      vdiBonificado: map['VDI_BONIFICADO'] as bool,
      vdiLance: map['VDI_LANCE'] as String? ?? 'N',
      vdiPmin: (map['VDI_PMIN'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'VDI_ID': vdiId,
      'VDI_VND_ID': vdiVndId,
      'VDI_VND_CHAVE': vdiVndChave,
      'VDI_EAN': vdiEan,
      'VDI_PROD_COD': vdiProdCod,
      'VDI_DESCRICAO': vdiDescricao,
      'VDI_TIPO': vdiTipo,
      'VDI_QTD': vdiQtd,
      'VDI_UNIT': vdiUnit,
      'VDI_TOTAL': vdiTotal,
      'VDI_DESC': vdiDesc,
      'VDI_ALINTRA': vdiAlintra,
      'VDI_ALINTER': vdiAlinter,
      'VDI_ALIPI': vdiAlipi,
      'VDI_MVA': vdiMva,
      'VDI_REDBASE': vdiRedbase,
      'VDI_VLST': vdiVlst,
      'VDI_VLIPI': vdiVlipi,
      'VDI_TOTALG': vdiTotalg,
      'VDI_PRECO': vdiPreco,
      'VDI_PESO': vdiPeso,
      'VDI_CUSTO': vdiCusto,
      'VDI_OBS': vdiObs,
      'VDI_PBONIFICACAO': vdiPbonificacao,
      'VDI_VBONIFICACAO': vdiVbonificacao,
      'VDI_BONIFICADO': vdiBonificado ? 1 : 0,
      'VDI_LANCE': vdiLance,
      'VDI_PMIN': vdiPmin,
    };
  }

  Map<String, dynamic> toMapAPI() {
    return {
      'VDI_VND_ID': vdiVndId,
      'VDI_VND_CHAVE': vdiVndChave,
      'VDI_EAN': vdiEan,
      'VDI_PROD_COD': vdiProdCod,
      'VDI_DESCRICAO': vdiDescricao,
      'VDI_QTD': double.parse(vdiQtd.toStringAsFixed(2)),
      'VDI_UNIT': double.parse(vdiUnit.toStringAsFixed(2)),
      'VDI_TOTAL': double.parse(vdiTotal.toStringAsFixed(2)),
      'VDI_DESC': double.parse(vdiDesc.toStringAsFixed(2)),
      'VDI_ALST': double.parse((vdiAlinter - vdiAlintra).toStringAsFixed(2)),
      'VDI_ALIPI': double.parse(vdiAlipi.toStringAsFixed(2)),
      'VDI_MVA': double.parse(vdiMva.toStringAsFixed(2)),
      'VDI_REDBASE': double.parse(vdiRedbase.toStringAsFixed(2)),
      'VDI_VLST': double.parse(vdiVlst.toStringAsFixed(2)),
      'VDI_VLIPI': double.parse(vdiVlipi.toStringAsFixed(2)),
      'VDI_TOTALG': double.parse(vdiTotalg.toStringAsFixed(2)),
      'VDI_PRECO': double.parse(vdiPreco.toStringAsFixed(2)),
      'VDI_CUSTO': double.parse(vdiCusto.toStringAsFixed(2)),
      'VDI_BONIFICADO': vdiBonificado ? 'True' : 'False',
      'VDI_PBONIFICACAO': double.parse(vdiPbonificacao.toStringAsFixed(2)),
      'VDI_VBONIFICACAO': double.parse(vdiPbonificacao.toStringAsFixed(2)),
      'VDI_PMIN': double.parse(vdiPmin.toStringAsFixed(2)),
      'VDI_LANCE': vdiLance,
      'VDI_OBS': vdiObs,
    };
  }

  VendaItem copyWith({
    int? vdiId,
    int? vdiVndId,
    String? vdiVndChave,
    String? vdiEan,
    int? vdiProdCod,
    String? vdiDescricao,
    String? vdiTipo,
    double? vdiQtd,
    double? vdiUnit,
    double? vdiTotal,
    double? vdiDesc,
    double? vdiAlintra,
    double? vdiAlinter,
    double? vdiAlipi,
    double? vdiMva,
    double? vdiRedbase,
    double? vdiVlst,
    double? vdiVlipi,
    double? vdiTotalg,
    double? vdiPreco,
    double? vdiPeso,
    double? vdiCusto,
    String? vdiObs,
    double? vdiPbonificacao,
    double? vdiVbonificacao,
    bool? vdiBonificado,
    String? vdiLance,
    String? vdiLance1,
    double? vdiPmin,
  }) {
    return VendaItem(
      vdiId: vdiId ?? this.vdiId,
      vdiVndId: vdiVndId ?? this.vdiVndId,
      vdiVndChave: vdiVndChave ?? this.vdiVndChave,
      vdiEan: vdiEan ?? this.vdiEan,
      vdiProdCod: vdiProdCod ?? this.vdiProdCod,
      vdiDescricao: vdiDescricao ?? this.vdiDescricao,
      vdiTipo: vdiTipo ?? this.vdiTipo,
      vdiQtd: vdiQtd ?? this.vdiQtd,
      vdiUnit: vdiUnit ?? this.vdiUnit,
      vdiTotal: vdiTotal ?? this.vdiTotal,
      vdiDesc: vdiDesc ?? this.vdiDesc,
      vdiAlintra: vdiAlintra ?? this.vdiAlintra,
      vdiAlinter: vdiAlinter ?? this.vdiAlinter,
      vdiAlipi: vdiAlipi ?? this.vdiAlipi,
      vdiMva: vdiMva ?? this.vdiMva,
      vdiRedbase: vdiRedbase ?? this.vdiRedbase,
      vdiVlst: vdiVlst ?? this.vdiVlst,
      vdiVlipi: vdiVlipi ?? this.vdiVlipi,
      vdiTotalg: vdiTotalg ?? this.vdiTotalg,
      vdiPreco: vdiPreco ?? this.vdiPreco,
      vdiPeso: vdiPeso ?? this.vdiPeso,
      vdiCusto: vdiCusto ?? this.vdiCusto,
      vdiObs: vdiObs ?? this.vdiObs,
      vdiPbonificacao: vdiPbonificacao ?? this.vdiPbonificacao,
      vdiVbonificacao: vdiVbonificacao ?? this.vdiVbonificacao,
      vdiBonificado: vdiBonificado ?? this.vdiBonificado,
      vdiLance: vdiLance ?? this.vdiLance,
      vdiPmin: vdiPmin ?? this.vdiPmin,
    );
  }

  @override
  String toString() {
    return 'VendaItem(vdiId: $vdiId, vdiProdCod: $vdiProdCod, vdiDescricao: $vdiDescricao, vdiQtd: $vdiQtd, vdiTotal: $vdiTotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VendaItem &&
        other.vdiId == vdiId &&
        other.vdiVndId == vdiVndId &&
        other.vdiProdCod == vdiProdCod &&
        other.vdiQtd == vdiQtd &&
        other.vdiTotal == vdiTotal;
  }

  @override
  int get hashCode {
    return vdiId.hashCode ^
        vdiVndId.hashCode ^
        vdiProdCod.hashCode ^
        vdiQtd.hashCode ^
        vdiTotal.hashCode;
  }
}
