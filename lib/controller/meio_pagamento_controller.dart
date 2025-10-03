import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/meio_pagamento.dart';

class MeioPagamentoController {
  Future<List<MeioPagamento>> getAll() async {
    final db = await DatabaseService().database;

    final res = await db.query('MEIOS_PAGAMENTO',
        orderBy: 'MP_DESC ASC', where: "MP_ATIVO <> 'N'");

    return res.map((e) => MeioPagamento.fromMap(e)).toList();
  }

  Future<List<MeioPagamento>> getMeios(int formaId) async {
    final db = await DatabaseService().database;

    final res = await db.rawQuery('''
      SELECT        
        FM.FM_MEIO MP_ID,
        M.MP_DESC,
        M.MP_ATIVO
      FROM FORMAS_MEIO FM
      LEFT JOIN MEIOS_PAGAMENTO M 
      ON FM.FM_MEIO=M.MP_ID
      WHERE FM.FM_FORMA=?
    ''', [formaId]);

    return res.map((e) => MeioPagamento.fromMap(e)).toList();
  }
}
