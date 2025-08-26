import 'package:mobile_sales/controller/cliente_controller.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/vendas_itens_controllers.dart';
import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/venda.dart';

class VendasController {
  List<Venda> _vendas = [];
  List<Venda> get vendas => _vendas;

  Future<List<Venda>> getVendas(
      {String orderBy =
          "(case vnd_enviado when 'N' then 1 when 'P' then 2 else 3 end) asc, vnd_datahora desc",
      List<String> filtros = const [],
      String pesquisa = ''}) async {
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

  Future<Venda?> getVendaById(int id) async {
    final db = await DatabaseService().database;

    final res = await db.query('VENDAS', where: 'VND_ID = ?', whereArgs: [id]);

    if (res.isEmpty) {
      return null;
    }

    return Venda.fromMap(res[0]);
  }

  Future<Venda?> novoPedido(int cliId) async {
    try {
      final clienteController = ClienteController();
      final parametrosController = ParametrosController();
      final cliente = await clienteController.getClienteById(cliId);
      await parametrosController.getParametros();

      if (cliente == null) {
        return null;
      }

      final db = await DatabaseService().database;

      final res = db.insert('VENDAS', {
        'vnd_datahora': DateTime.now().toIso8601String(),
        'vnd_enviado': 'N',
        'vnd_desconto': 0,
        'vnd_cli_id': cliente.cliId,
        'vnd_cli_nome': cliente.cliRazao,
        'vnd_cli_cnpj': cliente.cliCnpj,
        'vnd_pracrescimo': 0,
        'vnd_prdesconto': 0,
        'vnd_valor': 0,
        'vnd_total': 0,
        'vnd_totalbonificado': 0,
        'vnd_saldobonificacao': 0,
        'vnd_parcelas': 0,
        'vnd_frete': 0,
        'vnd_peso': 0,
        'vnd_vend': parametrosController.parametros?.parCusu
      });
    } catch (e) {
      rethrow;
      return null;
    }
  }
}
