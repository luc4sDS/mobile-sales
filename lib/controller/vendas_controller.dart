import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/venda.dart';

class VendasController {
  List<Venda> _vendas = [];
  List<Venda> get vendas => _vendas;

  Future<List<Venda>> getVendas(
      {String orderBy = '',
      List<String> filtros = const [],
      String pesquisa = ''}) async {
    var where = "";
    where = double.tryParse(pesquisa) != null
        ? "VND_ID=?"
        : "UPPER(VND_CLI_NOME) LIKE UPPER(?)";

    final db = await DatabaseService().database;
    var dados =
        await db.query('VENDAS', orderBy: orderBy, where: where, whereArgs: [
      double.tryParse(pesquisa) == null
          ? pesquisa
          : '%${pesquisa.replaceAll(" ", "%")}%'
    ]);
    _vendas = dados.map((json) => Venda.fromMap(json)).toList();
    return _vendas;
  }
}
