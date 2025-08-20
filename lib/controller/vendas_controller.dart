import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/venda.dart';

class VendasController {
  List<Venda> _vendas = [];
  List<Venda> get vendas => _vendas;

  Future<List<Venda>> getVendas() async {
    final db = await DatabaseService().database;
    var dados = await db.query('VENDAS');
    _vendas = dados.map((json) => Venda.fromMap(json)).toList();
    return _vendas; // Retorna a lista também
  }
}
