import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';

class ClienteEnderecoController {
  List<ClienteEndereco> enderecos = [];

  Future<String> getEnderecos() async {
    final db = await DatabaseService().database;

    try {
      final List<Map<String, dynamic>> maps =
          await db.query('CLIENTES_ENDERECOS');

      enderecos = List.generate(
        maps.length,
        (index) => ClienteEndereco.fromMap(maps[index]),
      );

      return '';
    } catch (e) {
      return 'Erro ao buscar Enderecos no banco de dados: $e';
    }
  }
}
