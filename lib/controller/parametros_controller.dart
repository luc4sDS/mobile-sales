import 'dart:convert';
import 'package:mobile_sales/constants/api_constants.dart';
import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/parametros.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sql.dart';

class ParametrosController {
  Parametros? parametros;

  Future<String> getParametros() async {
    final db = await DatabaseService().database;

    try {
      final List<Map<String, dynamic>> maps = await db.query('PARAMETROS');

      final parametrosList = List.generate(
        maps.length,
        (index) => Parametros.fromMap(maps[index]),
      );

      if (parametrosList.isNotEmpty) {
        parametros = parametrosList[0];
      } else {
        parametros = null;
      }

      return '';
    } catch (e) {
      return 'Erro ao buscar parametros no banco de dados: $e';
    }
  }

  void teste() async {
    final db = await DatabaseService().database;

    List<dynamic> result = await db.query('PARAMETROS');
    print(result);
  }

  Future<String> cadastrarUsuario(String usuario, senha) async {
    try {
      final db = await DatabaseService().database;

      final usuarioMap = {'par_usuario': usuario, 'par_senha': senha};

      await db.update('PARAMETROS', usuarioMap);

      return '';
    } catch (e) {
      return 'Erro ao cadastrar usuário: $e';
    }
  }

  Future<String> salvarParametros(Parametros novosParametros) async {
    final db = await DatabaseService().database;

    try {
      var par = await db.query('PARAMETROS');

      if (par.isEmpty) {
        await db.insert('PARAMETROS', novosParametros.toMap());
      } else {
        await db.update('PARAMETROS', novosParametros.toMap());
      }

      parametros = novosParametros;
      return '';
    } catch (e) {
      return 'Erro ao salvar parametros no banco de dados: $e';
    }
  }

  Future<String> atualizarDadosVendedor() async {
    if (parametros == null || parametros!.parCusu == null)
      return 'Erro ao atualizar dados do vendedor.';

    var url = Uri.https(parametros!.parEndIPProd!, '/vendedores',
        {'codigo': parametros!.parCusu.toString(), 'chave': ''});
    var response = await http.get(url);

    var resJson = json.decode(response.body);

    if (parametros!.parVendNome!.isEmpty)
      return 'Vendedor inválido: nome não encontrado.';

    parametros!.parBloqueado = resJson[0]['VR_BLOQUEADO'];
    parametros!.parBonificacao = resJson[0]['VR_BONIFICACAO'];
    parametros!.parCadastraCliente = resJson[0]['VR_CADASTRACLIENTE'];
    parametros!.parPedidoClienteNovo = resJson[0]['VR_PEDIDOCLIENTENOVO'];
    parametros!.parDesconto = resJson[0]['VR_DESCONTO'];
    parametros!.parBloqueado = resJson[0]['VR_BLOQUEADO'];
    parametros!.parProdutosDesativados = resJson[0]['VR_PRODUTOSDESATIVADOS'];
    parametros!.parClientesDesativados = resJson[0]['VR_CLIENTESDESATIVADOS'];
    parametros!.parSincronia = resJson[0]['VR_SINCRONIA'];
    parametros!.parLimiteDesconto = resJson[0]['VR_LIMITEDESCONTO'];
    parametros!.parValidadePedido = resJson[0]['VR_VALIDADEPEDIDO'];
    parametros!.parDescontoGeral = resJson[0]['VR_DESCONTOGERAL'];
    parametros!.parTabelaEstado = resJson[0]['VR_TABELAESTADO'];
    parametros!.parSaldo = resJson[0]['VR_SALDO'];

    var resultSalvar = await salvarParametros(parametros!);

    if (resultSalvar.isNotEmpty) return resultSalvar;

    return '';
  }

  Future<String> login(String usuario, senha) async {
    try {
      await getParametros();

      if (parametros == null) {
        return 'Nenhum usuário cadastrado.';
      }

      if (usuario == parametros!.parUsuario) {
        if (senha == parametros!.parSenha) {
          await atualizarDadosVendedor();
          return '';
        }
      }

      return 'Usuário ou Senha estão incorretos.';
    } catch (e) {
      return 'Erro ao fazer login: $e';
    }
  }

  Future<String> vincular(String cnpj, chave) async {
    try {
      parametros = Parametros();

      var url =
          Uri.https(ApiConstants.tropusBaseUrl, '/clientes', {'cnpj': cnpj});

      var response = await http.get(url);

      if (response.statusCode != 200)
        return 'Erro ao buscar parametros: (${response.statusCode}) ${response.body}';

      List<dynamic> resJson = json.decode(response.body);

      if (resJson.isEmpty)
        return 'Não foi encontrada nenhuma empresa com este CNPJ.';

      parametros!.parCnpj = resJson[0]['cli_cnpj'];
      parametros!.parEndIPProd = resJson[0]['cli_mobilesaleshost'];

      url = Uri.https(parametros!.parEndIPProd!, '/vendedores',
          {'codigo': '0', 'chave': chave});

      response = await http.get(url);

      if (response.statusCode != 200)
        return 'Erro ao buscar dados do vendedor: (${response.statusCode}) ${response.body}';

      resJson = json.decode(response.body);

      if (resJson.isEmpty) return 'Não foi encontrado vendedor com esta chave.';

      if (resJson[0]['VR_BLOQUEADO'] == 'S')
        return 'Código de vendedor bloqueado.';

      parametros!.parChave = resJson[0]['VR_CHAVE'];
      parametros!.parCusu = resJson[0]['VR_ID'];
      parametros!.parVendNome = resJson[0]['VR_NOME'];
      parametros!.parVersao = 22;
      parametros!.parLimiteDesconto = 0;
      parametros!.ultsincroniaAsDateTime = DateTime(2020, 1, 1, 0, 0, 0);

      var result = await atualizarDadosVendedor();
      if (result.isNotEmpty) return result;

      result = await getParametros();
      if (result.isNotEmpty) return result;

      return '';
    } catch (e) {
      return 'Erro ao buscar parametros: $e';
    }
  }
}
