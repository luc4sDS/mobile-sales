import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/forma_pagamento_controller.dart';
import 'package:mobile_sales/controller/meio_pagamento_controller.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/sincronia_controller.dart';
import 'package:mobile_sales/controller/tipo_entrega_controller.dart';
import 'package:mobile_sales/controller/vendas_itens_controllers.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/forma_pagamento.dart';
import 'package:mobile_sales/model/meio_pagamento.dart';
import 'package:mobile_sales/model/tipo_entrega.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/view/widgets/list_search_modal.dart';
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
  List<VendaItem> _itens = [];
  List<FormaPagamento> _formasPagamento = [];
  List<MeioPagamento> _meiosPagamento = [];
  List<TipoEntrega> _tiposEntrega = [];
  int _selectedFormaPagamento = -1;
  int _selectedMeioPagamento = -1;
  int _selectedTipoEntrega = 1;
  bool loading = true;

  final _parametrosController = ParametrosController();
  final _vendasItensController = VendasItensController();
  final _formaPagamentoController = FormaPagamentoController();
  final _meioPagamentoController = MeioPagamentoController();
  final _tipoEntregaController = TipoEntregaController();

  final _pesquisaProdutosCte = TextEditingController();
  final _emailCte = TextEditingController();

  int getIndexByFieldValue<T, A>(
      List<T> list, A Function(T) extractValue, A value) {
    for (var i = 0; i < list.length - 1; i++) {
      if (extractValue(list[i]) == value) {
        return i;
      }
    }

    return -1;
  }

  void handleInitState() async {
    _emailCte.text = widget.venda.vndEmail ?? '';
    _itens = await _vendasItensController.getVendaItens(widget.venda.vndId);
    _formasPagamento = await _formaPagamentoController.getAll();
    _meiosPagamento = await _meioPagamentoController.getAll();
    _tiposEntrega = await _tipoEntregaController.getAll();

    _selectedFormaPagamento = getIndexByFieldValue<FormaPagamento, int>(
        _formasPagamento, (e) => e.fpId, widget.venda.vndFormaPagto ?? 0);
    _selectedMeioPagamento = getIndexByFieldValue<MeioPagamento, int>(
        _meiosPagamento, (e) => e.mpId, widget.venda.vndMeio ?? 0);
    _selectedTipoEntrega = getIndexByFieldValue<TipoEntrega, int>(
        _tiposEntrega, (e) => e.tpId, widget.venda.vndEntrega ?? 0);

    setState(() {
      loading = false;
    });
  }

  // Future

  void handleFormasPagamentoSearch(String text) async {
    _formasPagamento = await _formaPagamentoController.getFormasPagamento(text);
  }

  @override
  void initState() {
    handleInitState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Venda venda = widget.venda.copyWith(itens: _itens);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DefaultTabController(
                      // animationDuration: Duration(milliseconds: 0),
                      length: 3,
                      child: Scaffold(
                        appBar: const TabBar(
                          indicatorColor: AppColors.primary,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.lighSecondaryText,
                          tabs: [
                            Tab(text: 'Pedido'),
                            Tab(text: 'Produtos'),
                            Tab(text: 'Outros')
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        // color:
                                        //     AppColors.lightSecondaryBackground,
                                        border: Border.all(
                                            color: AppColors.lighSecondaryText
                                                .withValues(alpha: 0.4),
                                            width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Cliente',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primary),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Código',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .lighSecondaryText,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.venda.vndCliCod
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Razão',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .lighSecondaryText,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              widget.venda
                                                                  .vndCliNome
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'CPF/CNPJ',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .lighSecondaryText,
                                                    ),
                                                  ),
                                                  Text(
                                                    widget.venda.vndCliCnpj ??
                                                        'Indefinido',
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                            const SizedBox(height: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Email',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .lighSecondaryText,
                                                  ),
                                                ),
                                                TextField(
                                                  onChanged: (_) =>
                                                      print('teste'),
                                                  controller: _emailCte,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  decoration:
                                                      const InputDecoration(
                                                    suffixIcon:
                                                        Icon(Icons.mail),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        // color:
                                        //     AppColors.lightSecondaryBackground,
                                        border: Border.all(
                                            color: AppColors.lighSecondaryText
                                                .withValues(alpha: 0.4),
                                            width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Informações',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primary),
                                            ),
                                            const Text(
                                              'Forma de Pagamento',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    AppColors.lighSecondaryText,
                                              ),
                                            ),
                                            ListSearchModal(
                                              label: 'Forma de Pagamento',
                                              data: _formasPagamento,
                                              extractName: (e) => e.fpDesc,
                                              selectedIndex:
                                                  _selectedFormaPagamento,
                                              onSelect: (index) {
                                                setState(() {
                                                  _selectedFormaPagamento =
                                                      index;
                                                });
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Meio de Pagamento',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    AppColors.lighSecondaryText,
                                              ),
                                            ),
                                            ListSearchModal(
                                              label: 'Meio de Pagamento',
                                              data: _meiosPagamento,
                                              extractName: (e) => e.mpDesc,
                                              selectedIndex:
                                                  _selectedMeioPagamento,
                                              onSelect: (index) => setState(() {
                                                _selectedMeioPagamento = index;
                                              }),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Tipo de Entrega',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    AppColors.lighSecondaryText,
                                              ),
                                            ),
                                            ListSearchModal(
                                              label: 'Tipo de Entrega',
                                              data: _tiposEntrega,
                                              extractName: (e) => e.tpDesc,
                                              selectedIndex:
                                                  _selectedTipoEntrega,
                                              onSelect: (index) => setState(() {
                                                _selectedTipoEntrega = index;
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  venda.vndEnviado == 'P'
                                      ? Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: TextField(
                                            controller: _pesquisaProdutosCte,
                                            decoration: const InputDecoration(
                                                label: Text('Pesquisar'),
                                                suffixIcon: Icon(Icons.search)),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: venda.itens.length,
                                      itemBuilder: (context, i) {
                                        final item = venda.itens[i];
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 7),
                                          child: VendaItemCard(
                                            vdiProdId: item.vdiProdCod,
                                            vdiDescricao: item.vdiDescricao,
                                            vdiQtd: item.vdiQtd,
                                            vdiUnit: item.vdiUnit,
                                            vdiTotal: item.vdiTotal,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text('Teste 2'),
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
