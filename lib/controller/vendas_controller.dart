import 'dart:math';

import 'package:dio/dio.dart';
import 'package:mobile_sales/controller/cliente_controller.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/produto_controller.dart';
import 'package:mobile_sales/controller/tabela_controller.dart';
import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/parametros.dart';
import 'package:mobile_sales/model/ultimas_vendas.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class VendasController {
  List<Venda> _vendas = [];
  List<Venda> get vendas => _vendas;

  Future<List<Venda>> getVendas({
    String orderBy =
        "(case vnd_enviado when 'N' then 1 when 'P' then 2 else 3 end) asc, vnd_id desc",
    List<String> filtros = const [],
    String pesquisa = '',
  }) async {
    final db = await DatabaseService().database;
    String where;
    final isNumeric = double.tryParse(pesquisa) != null;

    if (filtros.isEmpty) {
      filtros = ['N', 'C', 'P'];
    }

    List<String> quotedFiltros = [];
    for (var s in filtros) {
      quotedFiltros.add("'$s'");
    }

    final filtrosMacro = quotedFiltros.join(',');

    if (isNumeric) {
      where = 'vnd_id=? AND vnd_enviado in ($filtrosMacro)';
    } else {
      where =
          "(UPPER(vnd_cli_nome) LIKE UPPER(?) OR UPPER(vnd_cidade) like UPPER(?)) AND vnd_enviado in ($filtrosMacro)";
    }

    var dados = await db.query('VENDAS',
        orderBy: orderBy,
        where: where,
        whereArgs: isNumeric
            ? [double.tryParse(pesquisa)]
            : [
                "%${pesquisa.replaceAll(' ', '%')}%",
                "%${pesquisa.replaceAll(' ', '%')}%"
              ]);

    _vendas = dados.map((json) => Venda.fromMap(json)).toList();
    return _vendas;
  }

  Future<Venda> addItem(Venda venda, VendaItem vendaItem) async {
    Venda novaVenda = Venda.fromMap(venda.toMap());
    novaVenda.itens.add(vendaItem);

    novaVenda = totalizar(novaVenda);
    if (await salvarVenda(novaVenda) > 0) {
      return novaVenda;
    } else {
      return venda;
    }
  }

  Future<Venda?> getVendaById(int id) async {
    final db = await DatabaseService().database;

    final res = await db.query('VENDAS', where: 'VND_ID = ?', whereArgs: [id]);

    if (res.isEmpty) {
      return null;
    }

    return Venda.fromMap(res[0]);
  }

  Venda totalizar(Venda venda, [String prioridadeDesconto = 'PR']) {
    final itens = List<VendaItem>.from(venda.itens);

    //Valores da venda
    double vendaTotal = 0;
    double vendaTotalSt = 0;
    double vendaTotalIPI = 0;
    double vendaValor = 0;
    double vendaTotalBonificacao = 0;
    double vendaSaldoBonificacao = 0;
    double vendaDesconto = 0;
    double vendaPrDesconto = 0;

    for (var i = 0; i < itens.length; i++) {
      itens[i] =
          itens[i].copyWith(vdiTotal: itens[i].vdiUnit * itens[i].vdiQtd);

      if (itens[i].vdiBonificado) {
        vendaTotalBonificacao = vendaTotalBonificacao + itens[i].vdiTotal;
      }
      vendaValor = vendaValor + itens[i].vdiTotal;
      vendaTotalSt = vendaTotalSt + itens[i].vdiVlst;
      vendaTotalIPI = vendaTotalIPI + itens[i].vdiVlipi;
      vendaSaldoBonificacao = vendaSaldoBonificacao + itens[i].vdiVbonificacao;

      vendaTotal = vendaTotal + itens[i].vdiTotal;
    }

    if (prioridadeDesconto == 'PR') {
      vendaDesconto = (venda.vndPrDesconto / 100) * vendaValor;
      vendaPrDesconto = venda.vndPrDesconto;
    } else {
      if (venda.vndValor > 0) {
        vendaPrDesconto = (venda.vndDesconto / vendaValor) * 100;
        vendaDesconto = venda.vndDesconto;
      } else {
        vendaPrDesconto = 0;
        vendaDesconto = venda.vndDesconto;
      }
    }

    vendaTotal = max(vendaValor - vendaDesconto, 0);

    return venda.copyWith(
      vndTotal: vendaTotal,
      vndTotalSt: vendaTotalSt,
      vndTotalIpi: vendaTotalIPI,
      vndTotalBonificacao: vendaTotalBonificacao,
      vndSaldoBonificacao: vendaSaldoBonificacao,
      vndValor: vendaValor,
      vndDesconto: vendaDesconto,
      vndPrDesconto: vendaPrDesconto,
    );
  }

  Future<int> salvarVenda(Venda venda) async {
    final db = await DatabaseService().database;
    final itens = venda.itens;
    Map<String, dynamic> vendaMap = venda.toMap();
    vendaMap.remove('ITENS');

    for (var item in itens) {
      final res = await db.insert(
        'VENDAS_ITENS',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (res == 0) {
        throw Exception(
            'Erro ao salvar o item "${item.vdiProdCod} - ${item.vdiDescricao}" da venda ${venda.vndId}');
      }
    }

    return await db.update('VENDAS', vendaMap,
        where: 'VND_ID = ?', whereArgs: [venda.vndId]);
  }

  Future<Venda?> novoPedido(int cliId) async {
    final db = await DatabaseService().database;
    final clienteController = ClienteController();
    final parametrosController = ParametrosController();
    final tabelaController = TabelaController();

    await parametrosController.getParametros();

    final cliente = await clienteController.getClienteById(cliId);
    late Parametros parametros;
    late int tabela;

    if (cliente == null) {
      return null;
    }

    if (parametrosController.parametros == null) {
      throw Exception(
          'Erro ao criar novo pedido: Não foi possível buscar parametros');
    } else {
      parametros = parametrosController.parametros!;
    }

    if ((cliente.cliTabela ?? 0) > 0) {
      tabela = cliente.cliTabela ?? 0;
    } else {
      tabela = 0;
      if (parametros.parTabelaEstado == 'S') {
        tabela =
            await tabelaController.getTabelaIdByUF(cliente.cliEstado ?? '');
      }
    }

    final res = await db.insert('VENDAS', {
      'vnd_datahora': DateTime.now().toIso8601String(),
      'vnd_enviado': 'N',
      'vnd_desconto': 0,
      'vnd_cli_nome': cliente.cliRazao,
      'vnd_cli_cnpj': cliente.cliCnpj,
      'vnd_cli_cod': cliId,
      'vnd_uf': cliente.cliEstado,
      'vnd_cidade': cliente.cliCidade,
      'vnd_estadoent': cliente.cliEstado,
      'vnd_cidadeent': cliente.cliCidade,
      'vnd_enderecoent': cliente.cliEndereco,
      'vnd_bairroent': cliente.cliBairro,
      'vnd_numeroent': cliente.cliNumero,
      'vnd_cepent': cliente.cliCep,
      'vnd_complent': cliente.cliCompl,
      'vnd_pracrescimo': 0,
      'vnd_prdesconto': 0,
      'vnd_valor': 0,
      'vnd_total': 0,
      'vnd_totalbonificacao': 0,
      'vnd_saldobonificacao': 0,
      'vnd_parcelas': 0,
      'vnd_frete': 0,
      'vnd_peso': 0,
      'vnd_vend': parametrosController.parametros?.parCusu,
      'vnd_vendnome': parametrosController.parametros!.parVendNome!,
      'vnd_email': cliente.cliEmail,
      'vnd_tabela': tabela,
    });

    final novaVendaSemChave = await getVendaById(res);

    if (novaVendaSemChave != null) {
      final novaVenda = novaVendaSemChave.copyWith(
        vndChave: Utils().getVendaChave(
          parametros.parCusu ?? 0,
          novaVendaSemChave.vndId,
          parametros.parCnpj ?? '',
        ),
      );
      if (await salvarVenda(novaVenda) == 1) {
        return novaVenda;
      } else {
        throw Exception('Erro ao gerar chave da venda');
      }
    }

    return null;
  }

  Future<Venda> atualizarPrecos(Venda venda) async {
    final produtoCtr = ProdutoController();
    final vendaCtr = VendasController();

    final itens = venda.itens;

    for (var i = 0; i < itens.length; i++) {
      final produto = await produtoCtr.getProdutoById(
          itens[i].vdiProdCod, venda.vndTabela ?? 0);

      if (produto == null || produto.prodPreco <= itens[i].vdiPreco) {
        continue;
      }

      final unitario = (produto.prodPreco) - itens[i].vdiDesc;

      itens[i] = itens[i].copyWith(
        vdiPreco: produto.prodPreco,
        vdiUnit: unitario,
        vdiTotal: unitario * itens[i].vdiQtd,
        vdiPbonificacao: produto.prodPbonificacao,
        vdiVbonificacao: (produto.prodPbonificacao ?? 0) > 0
            ? itens[i].vdiTotal * ((produto.prodPbonificacao ?? 0) / 100)
            : 0,
      );
    }

    final novaVenda = vendaCtr.totalizar(venda.copyWith(itens: itens));

    if ((await vendaCtr.salvarVenda(novaVenda)) > 0) {
      return novaVenda;
    } else {
      return venda;
    }
  }

  Future<String> enviarVenda(Venda venda) async {
    final parametrosController = ParametrosController();
    await parametrosController.getParametros();

    if (venda.vndEnviado == 'S') {
      return '';
    }

    final dio = Dio();

    try {
      final res = await dio.put(
        'https://${parametrosController.parametros?.parEndIPProd ?? ''}/vendas',
        data: venda.toMapAPI('A'),
      );

      if ((res.statusCode ?? 0) >= 200 && (res.statusCode ?? 0) <= 210) {
        if (res.data is Map<String, dynamic>) {
          final result = res.data as Map<String, dynamic>;

          if (result['status'] == 100) {
            if (await buscarPedido(venda.vndChave ?? '')) {
              return '';
            } else {
              return 'Erro desconhecido';
            }
          } else {
            return result['motivo'];
          }
        } else {
          return 'Não foi possível converter a resposta do servidor';
        }
      } else {
        return 'Status Code: ${res.statusCode} \n\n ${res.data}';
      }
    } catch (e) {
      return '$e';
    }
  }

  Future<bool> buscarPedido(String chave) async {
    final dio = Dio();
    final parCtr = ParametrosController();
    await parCtr.getParametros();

    final res = await dio.get(
      'https://${parCtr.parametros?.parEndIPProd ?? ''}/vendas',
      queryParameters: {'chave': chave},
    );

    if ((res.statusCode ?? 0) >= 200 && (res.statusCode ?? 0) <= 210) {
      if (res.data is Map<String, dynamic>) {
        final result = res.data as Map<String, dynamic>;

        if (chave == result['VND_CHAVE']) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<List<UltimasVendas>> getUltimasVendas(int prodId, String cliCnpj,
      [int? vndIdExcluir]) async {
    try {
      final db = await DatabaseService().database;

      final res = await db.rawQuery('''
        SELECT 
          VDI_PROD_COD UV_PROD_COD,
          VDI_DESCRICAO UV_PROD_NOME,
          VDI_UNIT UV_UNITARIO,
          VDI_QTD UV_QTD,
          VND_DATAHORA UV_EMISSAO,
          VDI_VND_ID UV_VND_ID,
          VDI_TOTALG UV_TOTALG
        FROM VENDAS_ITENS
        LEFT JOIN VENDAS ON
          VND_CHAVE = VDI_VND_CHAVE
        WHERE
          VDI_PROD_COD = ?
        AND
          VND_CLI_CNPJ = ?
        ${vndIdExcluir != null ? 'AND VND_ID <> $vndIdExcluir' : ''}
        AND
          VND_ENVIADO IN ('S', 'P')
        ORDER BY
          VDI_ID DESC
        LIMIT 5
      ''', [prodId, cliCnpj]);

      return res.map((e) => UltimasVendas.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
