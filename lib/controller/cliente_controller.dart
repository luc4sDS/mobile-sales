import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/cliente.dart';

class ClienteController {
  List<Cliente> clientes = [];

  Future<String> getClientes() async {
    final db = await DatabaseService().database;

    try {
      final List<Map<String, dynamic>> maps = await db.query('CLIENTES');

      clientes = List.generate(
        maps.length,
        (index) => Cliente.fromMap(maps[index]),
      );

      return '';
    } catch (e) {
      return 'Erro ao buscar Clientes no banco de dados: $e';
    }
  }
}
