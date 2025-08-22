import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/vendas_itens_controllers.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/view/widgets/venda_item_card.dart';
import 'package:mobile_sales/view/widgets/venda_situacao_chip.dart';

class PedidoInfoPage extends StatefulWidget {
  final Venda venda;

  const PedidoInfoPage({
    super.key,
    required this.venda,
  });

  @override
  State<PedidoInfoPage> createState() => _PedidoInfoPageState();
}

class _PedidoInfoPageState extends State<PedidoInfoPage> {
  Venda? venda;
  final vendasItensController = VendasItensController();

  @override
  void initState() {
    super.initState();

    venda = widget.venda;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.venda.vndId.toString()),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: VendaSituacaoChip(situacao: widget.venda.vndEnviado),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.black,
            onPressed: () {},
          )
        ],
      ),
      body: venda == null
          ? const Center(
              child: Text('Erro ao buscar o pedido no banco de dados'),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      // color: AppColors.lightSecondaryBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cliente',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Código',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lighSecondaryText,
                                    ),
                                  ),
                                  Text(
                                    widget.venda.vndCliCod.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Razão',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lighSecondaryText,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.venda.vndCliNome.toString(),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CPF/CNPJ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.lighSecondaryText,
                                  ),
                                ),
                                Text(
                                  widget.venda.vndCliCnpj ?? 'Indefinido',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        appBar: const TabBar(
                          indicatorColor: AppColors.primary,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.lighSecondaryText,
                          tabs: [
                            Tab(text: 'Produtos'),
                            Tab(text: 'Principal'),
                            Tab(
                              text: 'Outros',
                            )
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  venda?.vndEnviado == 'N'
                                      ? Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: TextField(
                                            decoration: const InputDecoration(
                                                label: Text('Pesquisar'),
                                                suffixIcon: Icon(Icons.search)),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: venda?.itens.length,
                                      itemBuilder: (context, i) {
                                        final item = venda?.itens[i];
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 7),
                                          child: VendaItemCard(
                                            vdiProdId: item?.vdiProdCod ?? 0,
                                            vdiDescricao:
                                                item?.vdiDescricao ?? '',
                                            vdiQtd: item?.vdiQtd ?? 0,
                                            vdiUnit: item?.vdiUnit ?? 0,
                                            vdiTotal: item?.vdiTotal ?? 0,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text('Teste 2'),
                            Text('Teste 3'),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
