import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/vendas_controller.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:intl/intl.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final VendasController vendaCtr = VendasController();
  late Future<List<Venda>> _vendasFuture;

  @override
  void initState() {
    super.initState();
    _vendasFuture = vendaCtr.getVendas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: FutureBuilder<List<Venda>>(
        future: _vendasFuture,
        builder: (context, snapshot) {
          // Verificando o estado do Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Erro: ${snapshot.error}'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _vendasFuture = vendaCtr.getVendas();
                      });
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum pedido encontrado'),
            );
          }

          // Dados carregados com sucesso
          final vendas = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _vendasFuture = vendaCtr.getVendas();
                });
                await _vendasFuture;
              },
              child: ListView.builder(
                itemCount: vendas.length,
                itemBuilder: (context, index) {
                  final venda = vendas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(13, 7, 10, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pedido #${venda.vndId}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Cliente: ${venda.vndCliNome}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Data: ${DateFormat('dd/MM/yyyy - HH:mm').format(venda.vndDataHora)}',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: R\$ ${venda.vndTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
