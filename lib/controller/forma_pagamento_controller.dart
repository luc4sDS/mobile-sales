import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/forma_pagamento.dart';

class FormaPagamentoController {
  Future<List<FormaPagamento>> getAll() async {
    final db = await DatabaseService().database;

    final res = await db.query('FORMAS_PAGAMENTO',
        orderBy: 'FP_DESC ASC', where: "FP_ATV <> 'N'");

    return res.map((e) => FormaPagamento.fromMap(e)).toList();
  }

  Future<List<FormaPagamento>> getFormasPagamento(String query) async {
    final db = await DatabaseService().database;

    final res = await db.query('FORMAS_PAGAMENTO',
        orderBy: 'FP_DESC ASC',
        where: "UPPER(FP_DESC) LIKE UPPER(?) AND FP_ATV<>'N'",
        whereArgs: ['%${query.replaceAll(' ', '%')}%']);

    return res.map((e) => FormaPagamento.fromMap(e)).toList();
  }
}
