import 'package:mobile_sales/database/database_services.dart';

class TabelaController {
  Future<int> getTabelaIdByUF(String uf) async {
    final db = await DatabaseService().database;

    final res = await db.query(
      'TABELA',
      columns: ['TB_ID'],
      where: 'TB_DESC = ?',
      whereArgs: [uf],
    );

    if (res.length == 1) {
      return res[0]['TB_ID'] as int;
    } else {
      return 0;
    }
  }
}
