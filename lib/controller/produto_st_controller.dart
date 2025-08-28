import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/produto_st.dart';

class ProdutoStController {
  Future<ProdutoSt?> getProdutoSt(int prodId, String estado) async {
    if (estado.trim() == '') return null;

    final db = await DatabaseService().database;

    final res = await db.query('PRODUTOS_ST',
        where: 'PST_PROD = ? AND PST_ESTADO = ?', whereArgs: [prodId, estado]);

    if (res.isEmpty) {
      return null;
    }

    return ProdutoSt.fromMap(res[0]);
  }
}
