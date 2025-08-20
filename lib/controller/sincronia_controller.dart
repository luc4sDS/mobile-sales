import 'dart:async';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/cliente.dart';
import 'package:mobile_sales/model/cliente_contato.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';
import 'package:mobile_sales/model/forma_meio.dart';
import 'package:mobile_sales/model/forma_pagamento.dart';
import 'package:mobile_sales/model/meio_pagamento.dart';
import 'package:mobile_sales/model/produto.dart';
import 'package:mobile_sales/model/produto_st.dart';
import 'package:mobile_sales/model/tabela.dart';
import 'package:mobile_sales/model/tabela_preco.dart';
import 'package:mobile_sales/model/tipo_entrega.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class SincroniaController {
  List<Cliente> clientes = [];
  List<ClienteContato> contatos = [];
  List<ClienteEndereco> enderecos = [];
  List<FormaPagamento> formasPag = [];
  List<FormaMeio> formasMeio = [];
  List<MeioPagamento> meiosPag = [];
  List<Produto> produtos = [];
  List<TabelaPreco> tabelaPreco = [];
  List<ProdutoSt> produtosST = [];
  List<TipoEntrega> tiposEntrega = [];
  List<TabelaPrecoCabecalho> tabelaPrecoCabecalhos = [];
  List<Venda> vendas = [];

  int get totalRegistros =>
      clientes.length +
      contatos.length +
      enderecos.length +
      produtos.length +
      tabelaPreco.length +
      produtosST.length +
      formasPag.length +
      meiosPag.length +
      formasMeio.length +
      tiposEntrega.length +
      tabelaPrecoCabecalhos.length +
      vendas.length +
      tabelaPreco.length;

  String _extractErrorMessage(dynamic responseData) {
    try {
      if (responseData is Map) {
        return responseData['message'] ??
            responseData['error'] ??
            responseData.toString();
      }
      return responseData.toString();
    } catch (_) {
      return 'Erro ao interpretar resposta';
    }
  }

  Future<DownloadResult<T>> baixarDados<T>({
    required String baseUrl,
    required String endpoint,
    required T Function(Map<String, dynamic>) fromMap,
    Map<String, dynamic> queryParams = const {},
    Map<String, dynamic> headers = const {},
    Dio? dioInstance,
    int timeoutSeconds = 60,
    bool normalizeKeys = true,
    bool Function(Map<String, dynamic>)? filter,
    Function(int, int)? onProgress,
  }) async {
    final dio = dioInstance ?? Dio();
    try {
      Response<dynamic> response = await dio
          .get(
            '${baseUrl.startsWith('http') ? baseUrl : 'https://$baseUrl'}/$endpoint',
            queryParameters: queryParams,
            options: Options(
              headers: headers,
              responseType: ResponseType.json,
            ),
            onReceiveProgress: onProgress,
          )
          .timeout(
            Duration(seconds: timeoutSeconds),
            onTimeout: () => throw DioException(
              requestOptions: RequestOptions(),
              error: 'Timeout após $timeoutSeconds segundos',
              type: DioExceptionType.connectionTimeout,
            ),
          );

      if (response.statusCode != 200) {
        return DownloadResult(
          error:
              'Erro ao baixar dados (${response.statusCode}): ${response.data?.toString() ?? 'Sem dados'}',
          data: null,
        );
      }

      List<Map<String, dynamic>> responseList;

      if (response.data is List) {
        responseList = (response.data as List).cast<Map<String, dynamic>>();
      } else if (response.data is Map<String, dynamic>) {
        responseList = [response.data as Map<String, dynamic>];
      } else {
        return DownloadResult(
          error:
              "Formato inválido. Esperado List ou Map, recebido: ${response.data.runtimeType}",
          data: null,
        );
      }

      final normalizedList =
          responseList.map((item) => Utils().normalizeKeys(item)).toList();

      final dados = normalizedList
          .where((item) => filter == null || filter(item))
          .map(fromMap)
          .toList();

      return DownloadResult(error: null, data: dados);
    } on DioException catch (e) {
      String errorMessage = 'Erro na requisição';

      // Caso 1: Temos resposta do servidor (status code + possível body)
      if (e.response != null) {
        errorMessage += ' (${e.response!.statusCode})';
        if (e.response!.data != null) {
          errorMessage += ': ${_extractErrorMessage(e.response!.data)}';
        }
      }
      // Caso 2: Temos apenas mensagem de erro (ex: conexão falhou)
      else if (e.message != null) {
        errorMessage += ': ${e.message}';

        // Adiciona contexto para erros de conexão
        if (e.message!.contains('SocketException') ||
            e.message!.contains('Failed host lookup')) {
          errorMessage += ' (Sem conexão com a internet)';
        }
      }
      // Caso 3: Erro totalmente vazio (raro)
      else {
        errorMessage += ': Erro desconhecido (${e.runtimeType})';
      }

      // Adiciona tipo do erro para diagnóstico
      errorMessage += '\n[Tipo: ${e.type}]';

      return DownloadResult(error: errorMessage, data: null);
    } on TimeoutException {
      return DownloadResult(error: 'Timeout na requisição', data: null);
    } catch (e) {
      return DownloadResult(error: '$e', data: null);
    }
  }

  Future<String> sincronizarTabela<T>({
    required List<T> dados,
    required String nomeTabela,
    required Map<String, dynamic> Function(T) toMap,
    required int? Function(T) getId,
    required Function() onSyncRecord,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
    bool Function(T)? filtro,
    int batchSize = 50,
    Function(int progress, int total)? onProgress,
  }) async {
    final db = await DatabaseService().database;
    final total = dados.length;
    int processados = 0;

    try {
      await db.transaction((txn) async {
        for (int i = 0; i < total; i++) {
          final item = dados[i];

          // Aplica filtro se existir
          if (filtro != null && !filtro(item)) continue;

          final id = getId(item);
          if (id != null) {
            await txn.insert(
              nomeTabela,
              toMap(item),
              conflictAlgorithm: conflictAlgorithm,
            );
          }

          onSyncRecord();
          processados++;

          // Notifica progresso a cada batch ou no final
          if (onProgress != null && (i % batchSize == 0 || i == total - 1)) {
            onProgress(processados, total);
          }
        }
      });
      return '';
    } catch (e) {
      return '$e';
    }
  }

  Future<String> sincronizarVendas({
    required List<Venda> vendas,
    required Function() onSyncRecord,
    ConflictAlgorithm conflictAlgorithmVendas = ConflictAlgorithm.replace,
    ConflictAlgorithm conflictAlgorithmItens = ConflictAlgorithm.replace,
    bool Function(Venda)? filtro,
    int batchSize = 50,
    Function(int progress, int total)? onProgress,
  }) async {
    final db = await DatabaseService().database;
    final total = vendas.length;
    int processados = 0;

    try {
      await db.transaction((txn) async {
        for (int i = 0; i < total; i++) {
          final venda = vendas[i];

          // Aplica filtro se existir
          if (filtro != null && !filtro(venda)) continue;

          // Insere/atualiza a venda
          var vendaSemItens = venda.toMap();
          vendaSemItens.remove('ITENS');
          await txn.insert(
            'VENDAS',
            vendaSemItens,
            conflictAlgorithm: conflictAlgorithmVendas,
          );

          // Processa os itens da venda
          for (final item in venda.itens) {
            await txn.insert(
              'VENDAS_ITENS',
              item.toMap(),
              conflictAlgorithm: conflictAlgorithmItens,
            );
          }

          onSyncRecord();
          processados++;

          // Notifica progresso
          if (onProgress != null && (i % batchSize == 0 || i == total - 1)) {
            onProgress(processados, total);
          }
        }
      });
      return '';
    } catch (e) {
      return '$e';
    }
  }

  Future<String> baixarRegistros(
      String url, int vendId, DateTime ultSincronia) async {
    var resultCliente = await baixarDados<Cliente>(
        baseUrl: url,
        endpoint: 'clientes',
        fromMap: Cliente.fromMap,
        queryParams: {
          'codigo': vendId,
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultCliente.success) {
      clientes = resultCliente.data!;
    } else {
      return 'Erro ao baixar clientes: ${resultCliente.error}';
    }

    var resultCtt = await baixarDados<ClienteContato>(
        baseUrl: url,
        endpoint: 'clientes_contato',
        fromMap: ClienteContato.fromMap,
        queryParams: {
          'codigo': vendId,
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultCtt.success) {
      contatos = resultCtt.data!;
    } else {
      return 'Erro ao baixar Contatos: ${resultCtt.error}';
    }

    var resultEnd = await baixarDados<ClienteEndereco>(
        baseUrl: url,
        endpoint: 'clientes_enderecos',
        fromMap: ClienteEndereco.fromMap,
        queryParams: {
          'codigo': vendId,
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultEnd.success) {
      enderecos = resultEnd.data!;
    } else {
      return 'Erro ao baixar Endereços: ${resultEnd.error}';
    }

    var resultProdutos = await baixarDados<Produto>(
        baseUrl: url,
        endpoint: 'produtos',
        fromMap: Produto.fromMap,
        filter: (item) => item['PROD_DESCRICAO'] != null,
        queryParams: {
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultProdutos.success) {
      produtos = resultProdutos.data!;
    } else {
      return 'Erro ao baixar Produtos: ${resultProdutos.error}';
    }

    var resultFormasPag = await baixarDados<FormaPagamento>(
        baseUrl: url,
        endpoint: 'formas_pagamento',
        fromMap: FormaPagamento.fromMap,
        queryParams: {
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultFormasPag.success) {
      formasPag = resultFormasPag.data!;
    } else {
      return 'Erro ao baixar Formas de Pagamento: ${resultFormasPag.error}';
    }

    var resultMeiosPag = await baixarDados<MeioPagamento>(
        baseUrl: url,
        endpoint: 'formas_pagamento',
        filter: (item) => item['MP_ID'] != null,
        fromMap: MeioPagamento.fromMap,
        queryParams: {
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultMeiosPag.success) {
      meiosPag = resultMeiosPag.data!;
    } else {
      return 'Erro ao baixar Meios de Pagamento: ${resultMeiosPag.error}';
    }

    var resultFormasMeio = await baixarDados<FormaMeio>(
        baseUrl: url,
        endpoint: 'formas_meio',
        fromMap: FormaMeio.fromMap,
        queryParams: {
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultFormasMeio.success) {
      formasMeio = resultFormasMeio.data!;
    } else {
      return 'Erro ao baixar Tipos de Pagamento: ${resultFormasMeio.error}';
    }

    var resultTiposEntrega = await baixarDados<TipoEntrega>(
        baseUrl: url,
        endpoint: 'tipo_entrega',
        fromMap: TipoEntrega.fromMap,
        queryParams: {
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultTiposEntrega.success) {
      tiposEntrega = resultTiposEntrega.data!;
    } else {
      return 'Erro ao baixar Entregas: ${resultTiposEntrega.error}';
    }

    var resultProdutosSt = await baixarDados<ProdutoSt>(
        baseUrl: url,
        endpoint: 'produtos_st',
        fromMap: ProdutoSt.fromMap,
        queryParams: {
          'codigo': vendId,
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultProdutosSt.success) {
      produtosST = resultProdutosSt.data!;
    } else {
      return 'Erro ao baixar Impostos: ${resultProdutosSt.error}';
    }

    var resultTabelaPreco = await baixarDados<TabelaPreco>(
        baseUrl: url,
        endpoint: 'tabela_preco',
        fromMap: TabelaPreco.fromMap,
        queryParams: {
          'codigo': vendId,
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultTabelaPreco.success) {
      tabelaPreco = resultTabelaPreco.data!;
    } else {
      return 'Erro ao baixar Tabela de Preços: ${resultTabelaPreco.error}';
    }

    var resultTabela = await baixarDados<TabelaPrecoCabecalho>(
        baseUrl: url,
        endpoint: 'tabela',
        fromMap: TabelaPrecoCabecalho.fromMap,
        queryParams: {
          'data': DateFormat('ddMMyyyyhhmmss').format(ultSincronia)
        });

    if (resultTabela.success) {
      tabelaPrecoCabecalhos = resultTabela.data!;
    } else {
      return 'Erro ao baixar Tabela: ${resultTabela.error}';
    }

    vendas = [];

    DateTime dataInicio = ultSincronia;
    DateTime dataLimite = DateTime.now();
    Duration intervalo = Duration(days: 183); // Aproximadamente 6 meses

    while (dataInicio.isBefore(dataLimite)) {
      DateTime dataFim = dataInicio.add(intervalo);
      if (dataFim.isAfter(dataLimite)) dataFim = dataLimite;

      var resultVendas = await baixarDados<Venda>(
        baseUrl: url,
        endpoint: 'pedidos',
        timeoutSeconds: 120,
        fromMap: Venda.fromMapAPI,
        headers: {'Connection': 'Keep-Alive'},
        queryParams: {
          'datainicial': DateFormat('ddMMyyyy').format(dataInicio),
          'datafinal': DateFormat('ddMMyyyy').format(dataFim),
          'codigo': vendId,
          'situacao': '',
          'entrega': 0
        },
      );

      if (resultVendas.success) {
        vendas.addAll(resultVendas.data!);
      } else {
        return 'Erro ao baixar Vendas (${DateFormat('ddMMyyyy').format(dataInicio)} - ${DateFormat('ddMMyyyy').format(dataFim)}): ${resultVendas.error}';
      }

      dataInicio = dataFim.add(Duration(days: 1)); // Avança para o próximo dia
    }

    return '';
  }
}

class DownloadResult<T> {
  final String? error;
  final List<T>? data;

  DownloadResult({this.error, this.data});

  bool get success => error == null;
}
