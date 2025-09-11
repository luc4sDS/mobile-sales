import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/forma_pagamento_controller.dart';
import 'package:mobile_sales/controller/meio_pagamento_controller.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/tipo_entrega_controller.dart';
import 'package:mobile_sales/controller/vendas_controller.dart';
import 'package:mobile_sales/controller/vendas_itens_controllers.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/forma_pagamento.dart';
import 'package:mobile_sales/model/meio_pagamento.dart';
import 'package:mobile_sales/model/tipo_entrega.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/utils/utils.dart';
import 'package:mobile_sales/view/widgets/adicionar_produto_modal.dart';
import 'package:mobile_sales/view/widgets/custom_text_field.dart';
import 'package:mobile_sales/view/widgets/editar_item_modal.dart';
import 'package:mobile_sales/view/widgets/list_search_modal.dart';
import 'package:mobile_sales/view/widgets/valor_card.dart';
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
  late Venda venda;
  List<VendaItem> _itens = [];
  List<FormaPagamento> _formasPagamento = [];
  List<MeioPagamento> _meiosPagamento = [];
  List<TipoEntrega> _tiposEntrega = [];
  int _selectedFormaPagamento = -1;
  int _selectedMeioPagamento = -1;
  int _selectedTipoEntrega = 1;
  bool loading = true;
  Timer? _emailTimer;

  final _parametrosController = ParametrosController();
  final _vendasItensController = VendasItensController();
  final _formaPagamentoController = FormaPagamentoController();
  final _meioPagamentoController = MeioPagamentoController();
  final _tipoEntregaController = TipoEntregaController();
  final _vendaController = VendasController();

  final _emailCte = TextEditingController();

  int getIndexByFieldValue<T, A>(
      List<T> list, A Function(T) extractValue, A value) {
    for (var i = 0; i < list.length; i++) {
      if (extractValue(list[i]) == value) {
        return i;
      }
    }

    return -1;
  }

  void handleEmailChange() async {
    _emailTimer?.cancel();

    _emailTimer = Timer(const Duration(milliseconds: 300), () {
      venda = venda.copyWith(vndEmail: _emailCte.text);

      _vendaController.salvarVenda(venda);
    });
  }

  void handleItemDelete(int id) async {
    Utils().customShowDialog(
        'CONFIRMAR', 'Confirmar', 'Excluir este item?', context,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sim'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Não'),
          ),
        ]).then((result) async {
      if (!(result ?? false)) {
        return;
      }

      if (id > 0) {
        try {
          final res = await _vendasItensController.deleteById(id);

          if (res > 0) {
            _itens =
                await _vendasItensController.getVendaItens(widget.venda.vndId);
            venda = venda.copyWith(itens: _itens);
            venda = _vendaController.totalizar(venda);
            await _vendaController.salvarVenda(venda);

            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.lightSnackBarBg,
                  content: Text(
                    'Produto removido com sucesso!',
                    style: TextStyle(color: AppColors.lightSnackBarText),
                  ),
                ),
              );
            }

            setState(() {});
          } else {
            if (mounted) {
              Utils().customShowDialog('ERRO', 'Erro ao remover item',
                  'Erro desconhecido.', context);
            }
          }
        } catch (e) {
          Utils().customShowDialog(
              'ERRO', 'Erro ao remover item', 'Erro desconhecido.', context);
        }
      } else {
        if (mounted) {
          Utils().customShowDialog('ERRO', 'Erro ao remover item',
              'Este item não existe no banco de dados.', context);
        }
      }
    });
  }

  void handleEditarItem(VendaItem item, int index) async {
    try {
      venda.itens[index] = item;
      venda = _vendaController.totalizar(venda);
      await _vendaController.salvarVenda(venda);
      setState(() {});
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        Utils().customShowDialog('ERRO', 'Erro!', e, context);
      }
    }
  }

  void handleAddItem(VendaItem item) async {
    try {
      final List<String> erros = [];

      // Validar
      if (item.vdiQtd == 0) erros.add('Quantidade precisa ser maior que zero');
      if (item.vdiUnit < item.vdiPmin) {
        erros.add(
            'Preço unitário menor que o permitido: ${item.vdiPmin.toStringAsFixed(2)}');
      }

      if (erros.isNotEmpty) {
        if (mounted) {
          Utils().customShowDialog(
              'ERRO', 'Erro ao adicionar item', erros.join('\n\n'), context);
        }
        return;
      }

      final vendaAtualizada = await _vendaController.addItem(venda, item);
      // Adiciona o item e retorna a venda atualizada
      setState(() {
        venda = vendaAtualizada;
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.lightSnackBarBg,
            content: Text(
              'Produto adicionado com sucesso!',
              style: TextStyle(color: AppColors.lightSnackBarText),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Utils().customShowDialog(
          'ERRO',
          'Erro ao adicionar item',
          e.toString(),
          context,
        );
      }
    }
  }

  void handleInitState() async {
    setState(() {
      loading = true;
    });

    venda = widget.venda;
    _itens = await _vendasItensController.getVendaItens(widget.venda.vndId);
    venda = venda.copyWith(itens: _itens);

    print(_itens);

    _emailCte.text = venda.vndEmail ?? '';
    await _parametrosController.getParametros();
    _formasPagamento = await _formaPagamentoController.getAll();
    _meiosPagamento = await _meioPagamentoController.getAll();
    _tiposEntrega = await _tipoEntregaController.getAll();

    _selectedFormaPagamento = getIndexByFieldValue<FormaPagamento, int>(
        _formasPagamento, (e) => e.fpId, venda.vndFormaPagto ?? 0);
    _selectedMeioPagamento = getIndexByFieldValue<MeioPagamento, int>(
        _meiosPagamento, (e) => e.mpId, venda.vndMeio ?? -1);
    _selectedTipoEntrega = getIndexByFieldValue<TipoEntrega, int>(
        _tiposEntrega, (e) => e.tpId, venda.vndEntrega ?? 0);

    setState(() {
      loading = false;
    });
  }

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        title: Text(venda.vndId.toString()),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: VendaSituacaoChip(situacao: venda.vndEnviado),
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
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Wrap(
                          runSpacing: 10,
                          direction: Axis.horizontal,
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            ValorCard(
                                label: 'Total Pedido', valor: venda.vndTotal),
                            ValorCard(
                                label: 'Total Produtos', valor: venda.vndValor),
                            ValorCard(
                                label: 'Total ST', valor: venda.vndTotalSt)
                          ],
                        ),
                      ],
                    ),
                  ),
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
                                                      venda.vndCliCod
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
                                                              venda.vndCliNome
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
                                                    venda.vndCliCnpj ??
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
                                                CustomTextField(
                                                  enabled:
                                                      venda.vndEnviado == 'N',
                                                  onChanged: (_) =>
                                                      handleEmailChange(),
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
                                              enabled: venda.vndEnviado == 'N',
                                              label: 'Forma de Pagamento',
                                              data: _formasPagamento,
                                              extractName: (e) => e.fpDesc,
                                              selectedIndex:
                                                  _selectedFormaPagamento,
                                              onSelect: (index) {
                                                venda = venda.copyWith(
                                                  vndFormaNome:
                                                      _formasPagamento[index]
                                                          .fpDesc,
                                                  vndFormaPagto:
                                                      _formasPagamento[index]
                                                          .fpId,
                                                );

                                                _vendaController
                                                    .salvarVenda(venda);

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
                                              enabled: venda.vndEnviado == 'N',
                                              label: 'Meio de Pagamento',
                                              data: _meiosPagamento,
                                              extractName: (e) => e.mpDesc,
                                              selectedIndex:
                                                  _selectedMeioPagamento,
                                              onSelect: (index) {
                                                venda = venda.copyWith(
                                                  vndMeioNome:
                                                      _meiosPagamento[index]
                                                          .mpDesc,
                                                  vndMeio:
                                                      _meiosPagamento[index]
                                                          .mpId,
                                                );

                                                _vendaController
                                                    .salvarVenda(venda);

                                                setState(() {
                                                  _selectedMeioPagamento =
                                                      index;
                                                });
                                              },
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
                                              enabled: venda.vndEnviado == 'N',
                                              label: 'Tipo de Entrega',
                                              data: _tiposEntrega,
                                              extractName: (e) => e.tpDesc,
                                              selectedIndex:
                                                  _selectedTipoEntrega,
                                              onSelect: (index) {
                                                venda = venda.copyWith(
                                                  vndNEntrega:
                                                      _tiposEntrega[index]
                                                          .tpDesc,
                                                  vndEntrega:
                                                      _tiposEntrega[index].tpId,
                                                );

                                                _vendaController
                                                    .salvarVenda(venda);

                                                setState(() {
                                                  _selectedTipoEntrega = index;
                                                });
                                              },
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
                                  venda.vndEnviado == 'N'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  useSafeArea: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      AdicionarProdutoModal(
                                                    vendaChave:
                                                        venda.vndChave ?? '',
                                                    vendaEstado:
                                                        venda.vndUf ?? '',
                                                    vendaId: venda.vndId,
                                                    vendaPrAcrescimo:
                                                        venda.vndPrAcrescimo,
                                                    onSave: (item) {
                                                      handleAddItem(item);
                                                    },
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        14, 5, 14, 5),
                                                minimumSize: const Size(10, 10),
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'poppins'),
                                              ),
                                              child: const Text('Adicionar'),
                                            ),
                                          ],
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
                                            onTap: () {
                                              showModalBottomSheet(
                                                useSafeArea: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) =>
                                                    EditarItemModal(
                                                  onDelete: handleItemDelete,
                                                  estado: venda.vndUf ?? '',
                                                  readOnly:
                                                      venda.vndEnviado != 'N',
                                                  onSave: (item) {
                                                    handleEditarItem(item, i);
                                                  },
                                                  item: venda.itens[i],
                                                ),
                                              );
                                            },
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
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    _vendaController.totalizar(venda);
                                  },
                                  child: const Text('Test'),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
