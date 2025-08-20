import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/vendas_controller.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sales/view/widgets/venda_card.dart';

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
            child: ListView.builder(
              itemCount: vendas.length,
              itemBuilder: (context, index) {
                final venda = vendas[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: VendaCard(
                      id: venda.vndId,
                      cliente: venda.vndCliNome,
                      emissao: venda.vndDataHora,
                      total: venda.vndTotal,
                      situacao: venda.vndEnviado),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
