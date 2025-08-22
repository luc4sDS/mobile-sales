import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/venda_item.dart';

class VendasItensController {
  List<VendaItem> _vendasItens = [];
  List<VendaItem> get vendaItens => _vendasItens;

  Future<List<VendaItem>> getVendaItens(int vndId) async {
    final db = await DatabaseService().database;

    final res = await db.query('VENDAS_ITENS',
        where: 'VDI_VND_ID = ?', whereArgs: [vndId], orderBy: 'VDI_ID ASC');

    _vendasItens = res.map((i) => VendaItem.fromMap(i)).toList();
    return _vendasItens;
  }
}
