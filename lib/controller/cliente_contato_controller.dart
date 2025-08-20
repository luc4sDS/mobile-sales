import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/cliente_contato.dart';

class ClienteContatoController {
  List<ClienteContato> clientesContatos = [];

  Future<String> getContatos() async {
    final db = await DatabaseService().database;

    try {
      final List<Map<String, dynamic>> maps =
          await db.query('CLIENTES_CONTATOS');

      clientesContatos = List.generate(
        maps.length,
        (index) => ClienteContato.fromMap(maps[index]),
      );

      return '';
    } catch (e) {
      return 'Erro ao buscar Contatos no banco de dados: $e';
    }
  }
}
