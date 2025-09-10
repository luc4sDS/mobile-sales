class ClienteEndereco {
  int clieSeq;
  int? clieId;
  String? clieCli;
  String? clieDescricao;
  String? clieEndereco;
  String? clieNumero;
  String? clieBairro;
  String? clieCidade;
  String? clieEstado;
  String? clieCep;
  String? clieEnvia;
  String? clieDeletado;
  String? clieAtivo;
  String? clieCompl;

  ClienteEndereco({
    required this.clieSeq,
    this.clieId,
    this.clieCli,
    this.clieDescricao,
    this.clieEndereco,
    this.clieNumero,
    this.clieBairro,
    this.clieCidade,
    this.clieEstado,
    this.clieCep,
    this.clieEnvia = 'N',
    this.clieDeletado = 'N',
    this.clieAtivo = 'S',
    this.clieCompl,
  });

  factory ClienteEndereco.fromMap(Map<String, dynamic> map) {
    return ClienteEndereco(
      clieSeq: map['CLIE_SEQ'] as int,
      clieId: map['CLIE_ID'] as int?,
      clieCli:
          map['CLIE_CLI'] as String? ?? map['CLIE_IDENTIFICADOR'] as String?,
      clieDescricao: map['CLIE_DESCRICAO'] as String?,
      clieEndereco: map['CLIE_ENDERECO'] as String?,
      clieNumero: map['CLIE_NUMERO'] as String?,
      clieBairro: map['CLIE_BAIRRO'] as String?,
      clieCidade: map['CLIE_CIDADE'] as String?,
      clieEstado: map['CLIE_ESTADO'] as String?,
      clieCep: map['CLIE_CEP'] as String?,
      clieEnvia: map['CLIE_ENVIA'] as String? ?? 'N',
      clieDeletado: map['CLIE_DELETADO'] as String? ?? 'N',
      clieAtivo: map['CLIE_ATIVO'] as String? ?? 'S',
      clieCompl: map['CLIE_COMPL'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CLIE_SEQ': clieSeq,
      'CLIE_ID': clieId,
      'CLIE_CLI': clieCli,
      'CLIE_DESCRICAO': clieDescricao,
      'CLIE_ENDERECO': clieEndereco,
      'CLIE_NUMERO': clieNumero,
      'CLIE_BAIRRO': clieBairro,
      'CLIE_CIDADE': clieCidade,
      'CLIE_ESTADO': clieEstado,
      'CLIE_CEP': clieCep,
      'CLIE_ENVIA': clieEnvia,
      'CLIE_DELETADO': clieDeletado,
      'CLIE_ATIVO': clieAtivo,
      'CLIE_COMPL': clieCompl,
    };
  }

  ClienteEndereco copyWith({
    int? clieSeq,
    int? clieId,
    String? clieCli,
    String? clieDescricao,
    String? clieEndereco,
    String? clieNumero,
    String? clieBairro,
    String? clieCidade,
    String? clieEstado,
    String? clieCep,
    String? clieEnvia,
    String? clieDeletado,
    String? clieAtivo,
    String? clieCompl,
  }) {
    return ClienteEndereco(
      clieSeq: clieSeq ?? this.clieSeq,
      clieId: clieId ?? this.clieId,
      clieCli: clieCli ?? this.clieCli,
      clieDescricao: clieDescricao ?? this.clieDescricao,
      clieEndereco: clieEndereco ?? this.clieEndereco,
      clieNumero: clieNumero ?? this.clieNumero,
      clieBairro: clieBairro ?? this.clieBairro,
      clieCidade: clieCidade ?? this.clieCidade,
      clieEstado: clieEstado ?? this.clieEstado,
      clieCep: clieCep ?? this.clieCep,
      clieEnvia: clieEnvia ?? this.clieEnvia,
      clieDeletado: clieDeletado ?? this.clieDeletado,
      clieAtivo: clieAtivo ?? this.clieAtivo,
      clieCompl: clieCompl ?? this.clieCompl,
    );
  }

  @override
  String toString() {
    return 'ClienteEndereco('
        'clieSeq: $clieSeq, '
        'clieId: $clieId, '
        'clieCli: $clieCli, '
        'clieDescricao: $clieDescricao, '
        'clieEndereco: $clieEndereco, '
        'clieNumero: $clieNumero, '
        'clieBairro: $clieBairro, '
        'clieCidade: $clieCidade, '
        'clieEstado: $clieEstado, '
        'clieCep: $clieCep, '
        'clieEnvia: $clieEnvia, '
        'clieDeletado: $clieDeletado, '
        'clieAtivo: $clieAtivo, '
        'clieCompl: $clieCompl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClienteEndereco &&
        other.clieSeq == clieSeq &&
        other.clieId == clieId &&
        other.clieCli == clieCli &&
        other.clieDescricao == clieDescricao &&
        other.clieEndereco == clieEndereco &&
        other.clieNumero == clieNumero &&
        other.clieBairro == clieBairro &&
        other.clieCidade == clieCidade &&
        other.clieEstado == clieEstado &&
        other.clieCep == clieCep &&
        other.clieEnvia == clieEnvia &&
        other.clieDeletado == clieDeletado &&
        other.clieAtivo == clieAtivo &&
        other.clieCompl == clieCompl;
  }

  @override
  int get hashCode {
    return clieSeq.hashCode ^
        clieId.hashCode ^
        clieCli.hashCode ^
        clieDescricao.hashCode ^
        clieEndereco.hashCode ^
        clieNumero.hashCode ^
        clieBairro.hashCode ^
        clieCidade.hashCode ^
        clieEstado.hashCode ^
        clieCep.hashCode ^
        clieEnvia.hashCode ^
        clieDeletado.hashCode ^
        clieAtivo.hashCode ^
        clieCompl.hashCode;
  }
}
