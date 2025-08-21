import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/vendas_controller.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sales/view/pages/pedido_info_page.dart';
import 'package:mobile_sales/view/widgets/venda_card.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final VendasController vendaCtr = VendasController();
  late Future<List<Venda>> _vendasFuture;
  final _pesquisaCtr = TextEditingController();
  Timer? _pesquisaTimer;
  final List<String> _filtros = [];
  double? _filtrosContainerHeight = 0;

  @override
  void initState() {
    super.initState();
    _vendasFuture =
        vendaCtr.getVendas(pesquisa: _pesquisaCtr.text, filtros: _filtros);
  }

  void handlePesquisaChanged(String vl) {
    _pesquisaTimer?.cancel();

    _pesquisaTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _vendasFuture =
            vendaCtr.getVendas(pesquisa: _pesquisaCtr.text, filtros: _filtros);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: handlePesquisaChanged,
                  controller: _pesquisaCtr,
                  decoration: const InputDecoration(
                      label: Text('Pesquisar'), suffixIcon: Icon(Icons.search)),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        minimumSize: Size(10, 10),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() {
                          _filtrosContainerHeight =
                              _filtrosContainerHeight == 0 ? 50 : 0;
                        });
                      },
                      child: Row(
                        children: [
                          const Text('Filtros'),
                          const SizedBox(width: 5),
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              color: AppColors.lightSecondaryBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(_filtros.length.toString()),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  child: Row(
                    children: [Text('aberto'), Text('enviado')],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  curve: Curves.ease,
                  height: _filtrosContainerHeight,
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Venda>>(
              future: _vendasFuture,
              builder: (context, snapshot) {
                // Verificando o estado do Future
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
                                _vendasFuture = vendaCtr.getVendas();
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

                // Dados carregados com sucesso
                final vendas = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                          situacao: venda.vndEnviado,
                          handleTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (context) =>
                                      PedidoInfoPage(venda: venda)),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
