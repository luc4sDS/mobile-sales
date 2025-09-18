import 'package:dio/dio.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
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
      if ((res.data['status'] as bool) && res.data['result'] != null) {
        return ConsultaCnpjResult.fromMap(
            res.data['result'] as Map<String, dynamic>);
      } else {
        return ConsultaCnpjResult();
      }
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

  Future<bool> cnpjExiste(String cnpj) async {
    final db = await DatabaseService().database;

    final res = await db
        .rawQuery('SELECT CLI_CNPJ FROM CLIENTES WHERE CLI_CNPJ=?', [cnpj]);

    return res.isNotEmpty;
  }

  Future<List<ClienteContato>> getClienteContatos(String cliCnpj) async {
    final db = await DatabaseService().database;

    final res = await db.query('CLIENTES_CONTATOS',
        where: 'CLIC_CLI = ?', whereArgs: [cliCnpj]);

    return res.map((e) => ClienteContato.fromMap(e)).toList();
  }

  Future<List<ClienteEndereco>> getClienteEnderecos(String cliCnpj,
      {bool incluirPadrao = true}) async {
    final db = await DatabaseService().database;

    late List<Map<String, Object?>> res;

    if (incluirPadrao) {
      res = await db.rawQuery('''
      SELECT 
        0 CLIE_SEQ, 
        0 CLIE_ID,
        ?1 CLIE_CLI,        
        'ENDEREÇO PRINCIPAL' CLIE_DESCRICAO,
        CLI_ENDERECO CLIE_ENDERECO,
        CLI_NUMERO CLIE_NUMERO,
        CLI_CEP CLIE_CEP,
        CLI_BAIRRO CLIE_BAIRRO,
        CLI_CIDADE CLIE_CIDADE,
        CLI_ESTADO CLIE_ESTADO,
        CLI_COMPL CLIE_COMPL,
        'N' CLIE_ENVIA,
        'N' CLIE_DELETADO,
        'S' CLIE_ATIVO
      FROM CLIENTES
      WHERE CLI_CNPJ=?1
      UNION ALL
      SELECT 
        CLIE_SEQ,
        CLIE_ID,
        CLIE_CLI,
        CLIE_DESCRICAO,
        CLIE_ENDERECO,
        CLIE_NUMERO,
        CLIE_CEP,
        CLIE_BAIRRO,
        CLIE_CIDADE,
        CLIE_ESTADO,
        CLIE_COMPL,
        CLIE_ENVIA,
        CLIE_DELETADO,
        CLIE_ATIVO
      FROM CLIENTES_ENDERECOS
      WHERE CLIE_CLI=?1
    ''', [cliCnpj]);
    } else {
      res = await db.query('CLIENTES_ENDERECOS',
          where: 'CLIE_CLI = ?', whereArgs: [cliCnpj]);
    }

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

  Future<int> insertEndereco(ClienteEndereco endereco) async {
    final db = await DatabaseService().database;

    final enderecoMap = endereco.toMap();
    enderecoMap.remove('CLIE_SEQ');

    return await db.insert('CLIENTES_ENDERECOS', enderecoMap);
  }

  Future<String> enviar(Cliente cliente) async {
    final parametrosCtr = ParametrosController();
    await parametrosCtr.getParametros();

    final dio = Dio();

    if (parametrosCtr.parametros == null ||
        (parametrosCtr.parametros?.parCusu ?? 0) == 0) {
      return 'Parametros não encontrados';
    }

    final res = await dio.put(
      'https://${parametrosCtr.parametros?.parEndIPProd ?? ''}/cliente_novo',
      data: cliente.toMapApi(parametrosCtr.parametros!.parCusu!),
    );

    final resMap = res.data as Map<String, dynamic>;

    if (resMap['status'] == 100 || resMap['status'] == -1) {
      return '';
    } else {
      return resMap['motivo'];
    }
  }

  Future<int> deleteEnderecoBySeq(int seq) async {
    final db = await DatabaseService().database;

    return await db.delete(
      'CLIENTES_ENDERECOS',
      where: 'CLIE_SEQ = ?',
      whereArgs: [seq],
    );
  }

  Future<int> updateEndereco(ClienteEndereco endereco) async {
    final db = await DatabaseService().database;

    return await db.update('CLIENTES_ENDERECOS', endereco.toMap(),
        where: 'CLIE_SEQ=?', whereArgs: [endereco.clieSeq]);
  }
}
