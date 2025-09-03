import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/produto.dart';

class ProdutoController {
  Future<List<Produto>> getProdutos(String pesquisa) async {
    final db = await DatabaseService().database;

    final res = await db.query(
      'PRODUTOS',
      where: "PROD_ID = ? OR PROD_DESCRICAO LIKE ? AND PROD_ATIVO <> 'N'",
      whereArgs: [pesquisa, '%${pesquisa.replaceAll(' ', '%')}%'],
      orderBy: 'PROD_DESCRICAO ASC',
    );

    return res.map((e) => Produto.fromMap(e)).toList();
  }
}
