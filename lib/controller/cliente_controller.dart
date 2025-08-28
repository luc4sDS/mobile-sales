import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/cliente.dart';

class ClienteController {
  List<Cliente> clientes = [];

  Future<List<Cliente>> getClientes(String? pesquisa) async {
    pesquisa ??= '';

    final db = await DatabaseService().database;
    final pesquisaIsNumeric = double.tryParse(pesquisa) != null;

    String where = '';

    if (pesquisaIsNumeric) {
      where = 'CLI_CNPJ = ?1 or CLI_ID= ?1';
    } else {
      where =
          'UPPER(CLI_RAZAO) LIKE UPPER(?1) OR UPPER(CLI_CIDADE) LIKE UPPER(?1)';
    }

    final List<Map<String, dynamic>> maps = await db.query('CLIENTES',
        where: where,
        whereArgs: ['%${pesquisa.replaceAll(' ', '%')}%'],
        orderBy: 'CLI_RAZAO ASC');

    clientes = List.generate(
      maps.length,
      (index) => Cliente.fromMap(maps[index]),
    );

    return clientes;
  }

  Future<Cliente?> getClienteById(int id) async {
    final db = await DatabaseService().database;

    final res =
        await db.query('CLIENTES', where: 'CLI_ID = ?', whereArgs: [id]);

    if (res.isEmpty) {
      return null;
    }

    return Cliente.fromMap(res[0]);
  }
}
