import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/vendas_controller.dart';
import 'package:mobile_sales/controller/vendas_itens_controllers.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/view/pages/pedido_info_page.dart';
import 'package:mobile_sales/view/widgets/venda_card.dart';
import 'package:mobile_sales/view/widgets/venda_situacao_toggle.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final VendasController vendaCtr = VendasController();
  final vendaItensCtr = VendasItensController();
  late Future<List<Venda>> _vendasFuture;
  final _pesquisaCtr = TextEditingController();
  Timer? _pesquisaTimer;
  final List<String> _filtros = ['N'];

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

  void handleSituToggleTap(String situ) {
    setState(() {
      if (_filtros.contains(situ)) {
        _filtros.remove(situ);
      } else {
        _filtros.add(situ);
      }

      _vendasFuture =
          vendaCtr.getVendas(pesquisa: _pesquisaCtr.text, filtros: _filtros);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {},
        icon: const Icon(
          size: 30,
          Icons.add,
          color: Colors.white,
        ),
        style: IconButton.styleFrom(
            backgroundColor: AppColors.primary, padding: EdgeInsets.all(12)),
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
        automaticallyImplyLeading: false,
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
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      VendaSituacaoToggle(
                        situ: 'Aberto',
                        estado: _filtros.contains('N'),
                        onTap: () => handleSituToggleTap('N'),
                      ),
                      const SizedBox(width: 5),
                      VendaSituacaoToggle(
                        situ: 'Enviado',
                        estado: _filtros.contains('P'),
                        onTap: () => handleSituToggleTap('P'),
                      ),
                      const SizedBox(width: 5),
                      VendaSituacaoToggle(
                        situ: 'Cancelado',
                        estado: _filtros.contains('C'),
                        onTap: () => handleSituToggleTap('C'),
                      ),
                    ],
                  ),
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
                          estado: venda.vndUf ?? '',
                          cidade: venda.vndCidade ?? '',
                          handleTap: () async {
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
