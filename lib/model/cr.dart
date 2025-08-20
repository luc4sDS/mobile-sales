class Cr {
  int crId;
  int crParcela;
  int crCliCodigo;
  String crCliNome;
  String crVndChave;
  int crVndId;
  DateTime crEmissao;
  double crValor;
  double crDesc;
  double crJuros;
  double crMulta;
  DateTime crVencimento;
  DateTime? crPagto;
  String? crEnviado;

  Cr({
    required this.crId,
    required this.crParcela,
    required this.crCliCodigo,
    required this.crCliNome,
    required this.crVndChave,
    required this.crVndId,
    required this.crEmissao,
    required this.crValor,
    required this.crDesc,
    required this.crJuros,
    required this.crMulta,
    required this.crVencimento,
    this.crPagto,
    this.crEnviado,
  });
}
