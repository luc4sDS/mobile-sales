import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/meio_pagamento.dart';

class MeioPagamentoController {
  Future<List<MeioPagamento>> getAll() async {
    final db = await DatabaseService().database;

    final res = await db.query('MEIOS_PAGAMENTO',
        orderBy: 'MP_DESC ASC', where: "MP_ATIVO <> 'N'");

    return res.map((e) => MeioPagamento.fromMap(e)).toList();
  }
}
