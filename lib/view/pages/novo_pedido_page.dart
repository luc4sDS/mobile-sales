import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/cliente_controller.dart';
import 'package:mobile_sales/model/cliente.dart';
import 'package:mobile_sales/view/widgets/cliente_card.dart';

class NovoPedidoPage extends StatefulWidget {
  const NovoPedidoPage({super.key});

  @override
  State<NovoPedidoPage> createState() => _NovoPedidoPageState();
}

class _NovoPedidoPageState extends State<NovoPedidoPage> {
  final _pesquisaCte = TextEditingController();

  final _clienteController = ClienteController();

  late Future<List<Cliente>> _clientesFuture;

  @override
  void initState() {
    _clientesFuture =
        _clienteController.getClientes(pesquisa: _pesquisaCte.text);
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
                _clientesFuture =
                    _clienteController.getClientes(pesquisa: text);
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
                                    _clientesFuture =
                                        _clienteController.getClientes(
                                            pesquisa: _pesquisaCte.text);
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
                            onTap: () => print(clientes.length),
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
