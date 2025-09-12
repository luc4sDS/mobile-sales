import 'package:mobile_sales/controller/cliente_controller.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/produto_st_controller.dart';
import 'package:mobile_sales/controller/vendas_itens_controllers.dart';
import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/parametros.dart';
import 'package:mobile_sales/model/produto_st.dart';
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

  Venda totalizar(Venda venda) {
    final itens = List<VendaItem>.from(venda.itens);

    //Valores da venda
    double vendaTotal = 0;
    double vendaTotalSt = 0;
    double vendaTotalIPI = 0;
    double vendaValor = 0;
    double vendaTotalBonificacao = 0;
    double vendaSaldoBonificacao = 0;
    double vendaDesconto = 0;

    for (var i = 0; i < itens.length; i++) {
      itens[i] =
          itens[i].copyWith(vdiTotal: itens[i].vdiUnit * itens[i].vdiQtd);

      if (itens[i].vdiBonificado)
        vendaTotalBonificacao = vendaTotalBonificacao + itens[i].vdiTotal;
      vendaValor = vendaValor + itens[i].vdiTotal;
      vendaTotalSt = vendaTotalSt + itens[i].vdiVlst;
      vendaTotalIPI = vendaTotalIPI + itens[i].vdiVlipi;
      vendaSaldoBonificacao = vendaSaldoBonificacao + itens[i].vdiVbonificacao;

      vendaTotal = vendaTotal + itens[i].vdiTotal;
    }

    if (vendaValor > 0) {
      if (venda.vndPrDesconto > 0) {
        vendaDesconto = ((venda.vndPrDesconto / 100) * vendaValor);
      } else {
        vendaDesconto = 0;
      }
    } else {
      vendaDesconto = 0;
    }

    vendaTotal = vendaValor - vendaDesconto;

    return venda.copyWith(
      vndTotal: vendaTotal,
      vndTotalSt: vendaTotalSt,
      vndTotalIpi: vendaTotalIPI,
      vndTotalBonificacao: vendaTotalBonificacao,
      vndSaldoBonificacao: vendaSaldoBonificacao,
      vndValor: vendaValor,
      vndDesconto: vendaDesconto,
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
    final clienteController = ClienteController();
    final parametrosController = ParametrosController();
    final cliente = await clienteController.getClienteById(cliId);
    await parametrosController.getParametros();
    late Parametros parametros;

    if (cliente == null) {
      return null;
    }

    if (parametrosController.parametros == null) {
      throw Exception(
          'Erro ao criar novo pedido: Não foi possível buscar parametros');
    } else {
      parametros = parametrosController.parametros!;
    }

    final db = await DatabaseService().database;

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
  }

  Future<List<UltimasVendas>> getUltimasVendas(
      int prodId, String cliCnpj) async {
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
          VND_CLI_CNPJ= ?        
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
