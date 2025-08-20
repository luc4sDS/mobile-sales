import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "mobilesales.db");
    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE PARAMETROS (
          PAR_CUSU INTEGER,
          PAR_USUARIO TEXT,
          PAR_CHAVE TEXT,
          PAR_SENHA TEXT,
          PAR_IMPCLI TEXT,
          PAR_ALTERAPRECO TEXT,
          PAR_ENDEIPTESTE TEXT,
          PAR_ENDIPPROD TEXT,
          PAR_PORTAPROD INTEGER,
          PAR_PORTATESTE INTEGER,
          PAR_SINCRONIA INTEGER,
          PAR_ULTSINCRONIA TEXT, -- SQLite uses TEXT for datetime
          PAR_EMPRESA TEXT,
          PAR_BLOQUEADO TEXT,
          PAR_CADASTRACLIENTE TEXT,
          PAR_PEDIDOCLIENTENOVO TEXT,
          PAR_DESCONTO TEXT,
          PAR_FINANCEIRO TEXT,
          PAR_PRODUTOSDESATIVADOS TEXT,
          PAR_CLIENTESDESATIVADOS TEXT,
          PAR_BONIFICACAO REAL,
          PAR_LIMITEDESCONTO REAL DEFAULT 0,
          PAR_DESCONTOGERAL TEXT,
          PAR_VALIDADEPEDIDO INTEGER,
          PAR_CNPJ TEXT,
          PAR_VERSAO INTEGER DEFAULT 1,
          PAR_TABELAESTADO TEXT,
          PAR_SALDO TEXT,
          PAR_HOSTINTERNO TEXT,
          PAR_VENDNOME TEXT
        );''');

        await db.execute('''CREATE TABLE CLIENTES (
          CLI_ID INTEGER NOT NULL,
          CLI_CNPJ TEXT PRIMARY KEY UNIQUE,
          CLI_INSC TEXT,
          CLI_RAZAO TEXT,
          CLI_FANTASIA TEXT,
          CLI_ENDERECO TEXT,
          CLI_NUMERO TEXT,
          CLI_BAIRRO TEXT,
          CLI_CIDADE TEXT,
          CLI_ESTADO TEXT,
          CLI_COMPL TEXT,
          CLI_CEP TEXT,
          CLI_TELEFONE TEXT,
          CLI_EMAIL TEXT,
          CLI_ENVIA TEXT,
          CLI_ATIVO TEXT,
          CLI_TABELA INTEGER
        );''');

        await db.execute('''CREATE TABLE CLIENTES_CONTATOS (
          CLIC_SEQ INTEGER PRIMARY KEY AUTOINCREMENT,
          CLIC_ID INTEGER,
          CLIC_CLI TEXT,
          CLIC_CONTATO TEXT,
          CLIC_TELEFONE TEXT,
          CLIC_ENVIA TEXT,
          CLIC_DELETADO TEXT,
          CLIC_EMAIL TEXT
        );''');

        await db.execute('''CREATE TABLE CLIENTES_ENDERECOS (
          CLIE_SEQ INTEGER PRIMARY KEY AUTOINCREMENT,
          CLIE_ID INTEGER,
          CLIE_CLI TEXT,
          CLIE_DESCRICAO TEXT,
          CLIE_ENDERECO TEXT,
          CLIE_NUMERO TEXT,
          CLIE_BAIRRO TEXT,
          CLIE_CIDADE TEXT,
          CLIE_ESTADO TEXT,
          CLIE_CEP TEXT,
          CLIE_ENVIA TEXT,
          CLIE_DELETADO TEXT,
          CLIE_ATIVO TEXT,
          CLIE_COMPL TEXT
        );''');

        await db.execute('''CREATE TABLE CR (
          CR_ID INTEGER PRIMARY KEY,
          CR_PARCELA INTEGER,
          CR_CLI_CODIGO INTEGER,
          CR_CLI_NOME VARCHAR(120),
          CR_VND_CHAVE VARCHAR(70),
          CR_VND_ID INTEGER,
          CR_EMISSAO DATE,
          CR_VALOR NUMERIC(15,2),
          CR_DESC NUMERIC(15,2),
          CR_JUROS NUMERIC(15,2),
          CR_MULTA NUMERIC(15,2),
          CR_VENCIMENTO DATE,
          CR_PAGTO DATE,
          CR_ENVIADO VARCHAR(1)
        );''');

        await db.execute('''CREATE TABLE CRONOGRAMA (
          CRG_DATAENVIO DATETIME,
          CRG_DATAVISUAL DATETIME,
          CRG_CLIENTE INTEGER,
          CRG_MSG VARCHAR(250)
        );''');

        await db.execute('''CREATE TABLE FORMAS_MEIO (
          FM_FORMA INTEGER PRIMARY KEY,
          FM_MEIO INTEGER,
          UNIQUE(FM_FORMA, FM_MEIO)
        );''');

        await db.execute('''CREATE TABLE FORMAS_PAGAMENTO (
          FP_ID INTEGER PRIMARY KEY,
          FP_DESC TEXT,
          FP_ATV TEXT,
          FP_VMIN REAL,
          FP_JUROS REAL,
          FP_NPARCELAS INTEGER,
          FP_DIAS INTEGER,
          FP_TIPO TEXT
        );''');

        await db.execute('''CREATE TABLE MEIOS_PAGAMENTO (
          MP_ID INTEGER PRIMARY KEY,
          MP_DESC TEXT,
          MP_ATIVO TEXT
        );''');

        await db.execute('''CREATE TABLE PRODUTOS (
          PROD_ID INTEGER PRIMARY KEY,
          PROD_DESCRICAO TEXT,
          PROD_PRECO REAL,
          PROD_CBARRA TEXT,
          PROD_GRUPO TEXT,
          PROD_SUBGRUPO TEXT,
          PROD_MARCA TEXT,
          PROD_LIMDESC REAL DEFAULT 0,
          PROD_BONIFICA TEXT,
          PROD_IMG BLOB,
          PROD_COR TEXT,
          PROD_DEVOLVE TEXT,
          PROD_ATIVO TEXT,
          PROD_DESCRICAOTEC TEXT,
          PROD_EMBALAGEM TEXT,
          PROD_SALDO REAL,
          PROD_PBONIFICACAO REAL,
          PROD_CORTE TEXT,
          PROD_CORTE1 TEXT,
          PROD_PMIN REAL
        );''');

        await db.execute('''CREATE TABLE PRODUTOS_ST (
          PST_PROD INTEGER NOT NULL,
          PST_ESTADO TEXT NOT NULL,
          PST_MARGEM REAL,
          PST_ICMSINTRA REAL,
          PST_ICMSINTER REAL,
          PST_REDUCAO REAL,
          UNIQUE(PST_PROD, PST_ESTADO)
        );''');

        await db.execute('''CREATE TABLE TABELA_PRECO (
          TB_ID INTEGER NOT NULL,
          TB_PROD INTEGER NOT NULL,
          TB_PERCENT REAL,
          UNIQUE(TB_ID, TB_PROD)
        );''');

        await db.execute('''CREATE TABLE VENDAS (
          VND_ID INTEGER PRIMARY KEY,
          VND_CHAVE TEXT,
          VND_DATAHORA TEXT,  -- SQLite usa TEXT para DATETIME
          VND_PREVENT TEXT,   -- SQLite usa TEXT para DATE
          VND_VEND INTEGER,
          VND_VENDNOME TEXT,
          VND_CLI_CNPJ TEXT,
          VND_CLI_NOME TEXT,
          VND_CLI_FANT TEXT,
          VND_FORMAPAGTO INTEGER,
          VND_FORMANOME TEXT,
          VND_MEIO INTEGER,
          VND_MEIONOME TEXT,
          VND_VALOR REAL,
          VND_DESCONTO REAL,
          VND_FRETE REAL,
          VND_TOTALST REAL,
          VND_TOTALIPI REAL,
          VND_TOTAL REAL,
          VND_OBS TEXT,
          VND_ENVIADO TEXT,
          VND_PESO REAL,
          VND_ENTREGA INTEGER,
          VND_NENTREGA TEXT,
          VND_LATITUDE REAL,
          VND_LONGITUDE REAL,
          VND_TABELA INTEGER,
          VND_UF TEXT,
          VND_CIDADE TEXT,
          VND_ENDERECOENT TEXT,
          VND_NUMEROENT TEXT,
          VND_BAIRROENT TEXT,
          VND_CIDADEENT TEXT,
          VND_ESTADOENT TEXT,
          VND_CEPENT TEXT,
          VND_COMPLENT TEXT,
          VND_EMAIL TEXT,
          VND_PRACRESCIMO REAL DEFAULT 0,
          VND_PRDESCONTO REAL DEFAULT 0,
          VND_CLI_COD INTEGER DEFAULT 0,
          VND_SINCRONIA TEXT,
          VND_ATUALIZACAO TEXT,  -- SQLite usa TEXT para DATETIME
          VND_PARCELAS INTEGER,
          VND_TOTALBONIFICACAO REAL,
          VND_SALDOBONIFICACAO REAL
        );''');

        await db.execute('''CREATE TABLE VENDAS_ITENS (
          VDI_ID INTEGER PRIMARY KEY,
          VDI_VND_ID INTEGER,
          VDI_VND_CHAVE TEXT,
          VDI_EAN INTEGER,
          VDI_PROD_COD INTEGER,
          VDI_DESCRICAO TEXT,
          VDI_TIPO TEXT,
          VDI_QTD REAL,
          VDI_UNIT REAL,
          VDI_TOTAL REAL,
          VDI_DESC REAL,
          VDI_ALINTRA REAL,
          VDI_ALINTER REAL,
          VDI_ALIPI REAL,
          VDI_MVA REAL,
          VDI_REDBASE REAL,
          VDI_VLST REAL,
          VDI_VLIPI REAL,
          VDI_TOTALG REAL,
          VDI_PRECO REAL,
          VDI_PESO REAL,
          VDI_CUSTO REAL,
          VDI_OBS TEXT,
          VDI_PBONIFICACAO REAL,
          VDI_VBONIFICACAO REAL,
          VDI_BONIFICADO INTEGER, -- SQLite não tem BOOLEAN, usamos INTEGER (0 ou 1)
          VDI_LANCE TEXT,
          VDI_LANCE1 TEXT,
          VDI_PMIN REAL
        );''');

        await db.execute('''CREATE TABLE TIPO_ENTREGA (
          TP_ID INTEGER PRIMARY KEY,
          TP_DESC TEXT,
          TP_ENTREGA TEXT,
          TP_ATIVO TEXT
        );''');

        await db.execute('''CREATE TABLE VENDAS_FINANCEIRO (
          VF_ID INTEGER PRIMARY KEY,
          VF_VND_ID INTEGER,
          VF_LANC INTEGER,
          VF_VENC TEXT, -- SQLite não tem tipo DATE nativo, usamos TEXT
          VF_VALOR REAL,
          VF_MEIO INTEGER,
          VF_NMEIO TEXT
        );''');

        await db.execute('''CREATE TABLE TABELA (
          TBP_ID INTEGER PRIMARY KEY,
          TBP_DESC TEXT,
          TBP_ATIVO TEXT
        );''');
      },
    );
  }
}
