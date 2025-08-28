import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/cliente_controller.dart';
import 'package:mobile_sales/controller/vendas_controller.dart';
import 'package:mobile_sales/model/cliente.dart';
import 'package:mobile_sales/utils/utils.dart';
import 'package:mobile_sales/view/pages/pedido_info_page.dart';
import 'package:mobile_sales/view/widgets/cliente_card.dart';

class NovoPedidoPage extends StatefulWidget {
  const NovoPedidoPage({super.key});

  @override
  State<NovoPedidoPage> createState() => _NovoPedidoPageState();
}

class _NovoPedidoPageState extends State<NovoPedidoPage> {
  final _pesquisaCte = TextEditingController();

  final _clienteController = ClienteController();
  final _vendaController = VendasController();

  late Future<List<Cliente>> _clientesFuture;

  void handleCriarPedido(cliId) async {
    if (!mounted) {
      return;
    }

    try {
      final novoPedido = await _vendaController.novoPedido(cliId);

      if (novoPedido == null) {
        Navigator.of(context).pop();
        Utils().customShowDialog(
            'ERRO', 'Erro!', 'Não foi possivel criar novo pedido', context);
        return;
      } else {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
              builder: (context) => PedidoInfoPage(venda: novoPedido)),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Não foi possivel criar novo pedido: $e', context);
    }
  }

  @override
  void initState() {
    _clientesFuture = _clienteController.getClientes(_pesquisaCte.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Selecione um cliente',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _pesquisaCte,
              onChanged: (text) => setState(() {
                _clientesFuture = _clienteController.getClientes(text);
              }),
              decoration: const InputDecoration(
                label: Text('Pesquisar'),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: FutureBuilder(
                  future: _clientesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 60),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text('Erro: ${snapshot.error}'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _clientesFuture = _clienteController
                                        .getClientes(_pesquisaCte.text);
                                  });
                                },
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Nenhum pedido encontrado'),
                      );
                    }

                    final clientes = snapshot.data!;

                    return ListView.builder(
                      itemCount: clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = clientes[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ClienteCard(
                            id: cliente.cliId ?? 0,
                            razao: cliente.cliRazao ?? '',
                            cidade: cliente.cliCidade ?? '',
                            uf: cliente.cliEstado ?? '',
                            cnpj: cliente.cliCnpj,
                            onTap: () {
                              Utils().customShowDialog(
                                'CONFIRMAR',
                                'Confirmar',
                                'Criar novo pedido para o cliente ${cliente.cliRazao}?',
                                context,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      handleCriarPedido(cliente.cliId);
                                    },
                                    child: Text('Sim'),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Não'))
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
