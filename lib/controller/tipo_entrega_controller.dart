import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/tipo_entrega.dart';

class TipoEntregaController {
  Future<List<TipoEntrega>> getAll() async {
    final db = await DatabaseService().database;

    final res = await db.query('TIPO_ENTREGA',
        orderBy: 'TP_DESC', where: "TP_ATIVO <> 'N'");

    return res.map((e) => TipoEntrega.fromMap(e)).toList();
  }
}
