class ClienteContato {
  int? clicSeq;
  int? clicId;
  String? clicCli;
  String? clicContato;
  String? clicTelefone;
  String? clicEnvia;
  String? clicDeletado;
  String? clicEmail;

  ClienteContato({
    this.clicSeq,
    this.clicId,
    this.clicCli,
    this.clicContato,
    this.clicTelefone,
    this.clicEnvia,
    this.clicDeletado,
    this.clicEmail,
  });

  factory ClienteContato.fromMap(Map<String, dynamic> map) {
    return ClienteContato(
      clicSeq: map['CLIC_SEQ'] as int?,
      clicId: map['CLIC_ID'] ?? map['CLIC_IDENTIFICADOR'] as int?,
      clicCli: map['CLIC_CLI'] as String? ?? map['CLIC_CNPJ'] as String?,
      clicContato: map['CLIC_CONTATO'] as String?,
      clicTelefone: map['CLIC_TELEFONE'] as String?,
      clicEnvia: map['CLIC_ENVIA'] as String? ?? 'N',
      clicDeletado: map['CLIC_DELETADO'] as String? ?? 'N',
      clicEmail: map['CLIC_EMAIL'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CLIC_SEQ': clicSeq,
      'CLIC_ID': clicId,
      'CLIC_CLI': clicCli,
      'CLIC_CONTATO': clicContato,
      'CLIC_TELEFONE': clicTelefone,
      'CLIC_ENVIA': clicEnvia,
      'CLIC_DELETADO': clicDeletado,
      'CLIC_EMAIL': clicEmail,
    };
  }

  ClienteContato copyWith({
    int? clicSeq,
    int? clicId,
    String? clicCli,
    String? clicContato,
    String? clicTelefone,
    String? clicEnvia,
    String? clicDeletado,
    String? clicEmail,
  }) {
    return ClienteContato(
      clicSeq: clicSeq ?? this.clicSeq,
      clicId: clicId ?? this.clicId,
      clicCli: clicCli ?? this.clicCli,
      clicContato: clicContato ?? this.clicContato,
      clicTelefone: clicTelefone ?? this.clicTelefone,
      clicEnvia: clicEnvia ?? this.clicEnvia,
      clicDeletado: clicDeletado ?? this.clicDeletado,
      clicEmail: clicEmail ?? this.clicEmail,
    );
  }

  @override
  String toString() {
    return 'ClienteContato(clicSeq: $clicSeq, clicId: $clicId, clicCli: $clicCli, clicContato: $clicContato, clicTelefone: $clicTelefone, clicEnvia: $clicEnvia, clicDeletado: $clicDeletado, clicEmail: $clicEmail)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClienteContato &&
        other.clicSeq == clicSeq &&
        other.clicId == clicId &&
        other.clicCli == clicCli &&
        other.clicContato == clicContato &&
        other.clicTelefone == clicTelefone &&
        other.clicEnvia == clicEnvia &&
        other.clicDeletado == clicDeletado &&
        other.clicEmail == clicEmail;
  }

  @override
  int get hashCode {
    return clicSeq.hashCode ^
        clicId.hashCode ^
        clicCli.hashCode ^
        clicContato.hashCode ^
        clicTelefone.hashCode ^
        clicEnvia.hashCode ^
        clicDeletado.hashCode ^
        clicEmail.hashCode;
  }
}
