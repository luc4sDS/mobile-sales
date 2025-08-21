import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/venda.dart';

class VendasController {
  List<Venda> _vendas = [];
  List<Venda> get vendas => _vendas;

  Future<List<Venda>> getVendas(
      {String orderBy = 'vnd_datahora desc',
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
}
