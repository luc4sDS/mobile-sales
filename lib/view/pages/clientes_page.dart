import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/cliente_controller.dart';
import 'package:mobile_sales/model/cliente.dart';
import 'package:mobile_sales/view/widgets/cliente_card.dart';
import 'package:mobile_sales/view/widgets/loading_error.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _clienteController = ClienteController();
  final _clienteCte = TextEditingController();

  late Future<List<Cliente>> _clientesFuture;

  @override
  void initState() {
    super.initState();
    _clientesFuture = _clienteController.getClientes(_clienteCte.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/novo_pedido').then(
              //   (_) => setState(
              //     () {
              //       _vendasFuture = vendaCtr.getVendas(
              //           pesquisa: _pesquisaCtr.text, filtros: _filtros);
              //     },
              //   ),
              // );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
              minimumSize: const Size(10, 10),
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'poppins'),
            ),
            child: const Text('Adicionar'),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        automaticallyImplyLeading: false,
        title: const Text('Clientes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _clienteCte,
                    decoration: const InputDecoration(
                      label: Text('Pesquisar'),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _clientesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('Não foi encontrado nenhum cliente'),
                    );
                  }

                  if (snapshot.hasError) {
                    return LoadingError(
                      title: 'Erro ao carregar clientes',
                      error: snapshot.error.toString(),
                      retry: () => {
                        setState(() {
                          _clientesFuture =
                              _clienteController.getClientes(_clienteCte.text);
                        })
                      },
                    );
                  }

                  final clientes = snapshot.data!;

                  return ListView.builder(
                    itemCount: clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clientes[index];
                      return ClienteCard(
                        id: cliente.cliId ?? 0,
                        razao: cliente.cliRazao ?? '',
                        cidade: cliente.cliCidade ?? '',
                        uf: cliente.cliEstado ?? '',
                        cnpj: cliente.cliCnpj,
                        onTap: () {},
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
