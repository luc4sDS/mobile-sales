import 'package:dio/dio.dart';
import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/cliente.dart';
import 'package:mobile_sales/model/cliente_contato.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';
import 'package:mobile_sales/model/consulta_cnpj_result.dart';

class ClienteController {
  List<Cliente> clientes = [];

  Future<ConsultaCnpjResult> consultaCnpj(String cnpj) async {
    final dio = Dio();
    final url =
        'http://ws.hubdodesenvolvedor.com.br/v2/cnpj/?cnpj=$cnpj&token=30217130aEIieobpmH54556112';

    final res = await dio.get(url);
    int statusCode = res.statusCode ?? 0;

    if (statusCode >= 200 && statusCode <= 210) {
      return ConsultaCnpjResult.fromMap(
          res.data['result'] as Map<String, dynamic>);
    } else {
      return ConsultaCnpjResult();
    }
  }

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

  Future<List<ClienteContato>> getClienteContatos(String cliCnpj) async {
    final db = await DatabaseService().database;

    final res = await db.query('CLIENTES_CONTATOS',
        where: 'CLIC_CLI = ?', whereArgs: [cliCnpj]);

    return res.map((e) => ClienteContato.fromMap(e)).toList();
  }

  Future<List<ClienteEndereco>> getClienteEnderecos(String cliCnpj) async {
    final db = await DatabaseService().database;

    final res = await db.query('CLIENTES_ENDERECOS',
        where: 'CLIE_CLI = ?', whereArgs: [cliCnpj]);

    return res.map((e) => ClienteEndereco.fromMap(e)).toList();
  }

  Future<int> insertCliente(Cliente cliente) async {
    try {
      final db = await DatabaseService().database;

      return await db.insert('CLIENTES', cliente.toMap());
    } catch (e) {
      throw Exception('Erro ao inserir cliente: $e');
    }
  }

  Future<int> updateCliente(Cliente cliente) async {
    final db = await DatabaseService().database;

    final res = await db.update('CLIENTES', cliente.toMap(),
        where: 'CLI_CNPJ = ?', whereArgs: [cliente.cliCnpj]);

    return res;
  }
}
