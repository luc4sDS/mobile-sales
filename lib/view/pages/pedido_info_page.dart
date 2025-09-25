import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sales/controller/forma_pagamento_controller.dart';
import 'package:mobile_sales/controller/meio_pagamento_controller.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/tipo_entrega_controller.dart';
import 'package:mobile_sales/controller/vendas_controller.dart';
import 'package:mobile_sales/controller/vendas_itens_controllers.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';
import 'package:mobile_sales/model/forma_pagamento.dart';
import 'package:mobile_sales/model/meio_pagamento.dart';
import 'package:mobile_sales/model/tipo_entrega.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/utils/utils.dart';
import 'package:mobile_sales/view/widgets/adicionar_produto_modal.dart';
import 'package:mobile_sales/view/widgets/cliente_endereco_card.dart';
import 'package:mobile_sales/view/widgets/custom_text_field.dart';
import 'package:mobile_sales/view/widgets/editar_item_modal.dart';
import 'package:mobile_sales/view/widgets/escolher_endereco_modal.dart';
import 'package:mobile_sales/view/widgets/list_search_modal.dart';
import 'package:mobile_sales/view/widgets/pedido_options_button.dart';
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
  Timer? _timer;

  final _parametrosController = ParametrosController();
  final _vendasItensController = VendasItensController();
  final _formaPagamentoController = FormaPagamentoController();
  final _meioPagamentoController = MeioPagamentoController();
  final _tipoEntregaController = TipoEntregaController();
  final _vendaController = VendasController();

  final _emailCte = TextEditingController();
  final _prDescontoCte = TextEditingController();
  final _vlDescontoCte = TextEditingController();
  final _tabelaCte = TextEditingController();
  final _obsCte = TextEditingController();

  int getIndexByFieldValue<T, A>(
      List<T> list, A Function(T) extractValue, A value) {
    for (var i = 0; i < list.length; i++) {
      if (extractValue(list[i]) == value) {
        return i;
      }
    }

    return -1;
  }

  void handleObsChange(String value) async {
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 300), () {
      venda = venda.copyWith(vndObs: value);

      _vendaController.salvarVenda(venda);
    });
  }

  void handleEmailChange() async {
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 300), () {
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
            await _vendaController.salvarVenda(venda).then((_) => setState(() {
                  _prDescontoCte.text = venda.vndPrDesconto.toStringAsFixed(2);
                  _vlDescontoCte.text = venda.vndDesconto.toStringAsFixed(2);
                }));

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
          if (mounted) {
            Utils().customShowDialog(
                'ERRO', 'Erro ao remover item', 'Erro desconhecido.', context);
          }
        }
      } else {
        if (mounted) {
          Utils().customShowDialog('ERRO', 'Erro ao remover item',
              'Este item não existe no banco de dados.', context);
        }
      }
    });
  }

  void handleBonificarItem(VendaItem item) async {
    if (item.vdiTotal >
        (venda.vndSaldoBonificacao - venda.vndTotalBonificacao)) {
      Utils().customShowDialog('ERRO', 'Erro ao bonificar',
          'Valor de bonificação maior que o saldo disponivel', context);
      return;
    }

    handleAddItem(item);
  }

  void handleEnderecoChange(ClienteEndereco endereco) async {
    venda = venda.copyWith(
      vndEnderecoEnt: endereco.clieEndereco,
      vndNumeroEnt: endereco.clieNumero,
      vndBairroEnt: endereco.clieBairro,
      vndCidadeEnt: endereco.clieCidade,
      vndEstadoEnt: endereco.clieEstado,
      vndComplEnt: endereco.clieCompl,
      vndCepEnt: endereco.clieCep,
    );

    _vendaController.salvarVenda(venda);

    setState(() {});
  }

  void handleEditarItem(VendaItem item, int index) async {
    try {
      final erros = validaItem(item);

      if (erros.isNotEmpty) {
        Utils().customShowDialog(
            'ERRO', 'Erro ao salvar item', erros.join('\n\n'), context);
        return;
      }

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

  List<String> validaItem(VendaItem item) {
    List<String> erros = [];

    if (item.vdiPmin == 0 &&
        num.parse(item.vdiUnit.toStringAsFixed(2)) <
            num.parse(item.vdiPreco.toStringAsFixed(2))) {
      erros.add('Descontos neste produto não são permitidos.');
    }

    if (item.vdiQtd <= 0) erros.add('Quantidade precisa ser maior que zero');
    if (num.parse(item.vdiUnit.toStringAsFixed(2)) <
        num.parse(item.vdiPmin.toStringAsFixed(2))) {
      erros.add(
          'Preço unitário menor que o permitido: ${item.vdiPmin.toStringAsFixed(2)}');
    }

    if (item.vdiProdCod == 0) {
      if (item.vdiDescricao.trim().isEmpty) {
        erros.add('Forneça uma descrição para o produto.');
      }

      if (item.vdiUnit <= 0) {
        erros.add('Valor unitário inválido');
      }
    }

    return erros;
  }

  void handleAddItem(VendaItem item) async {
    try {
      final erros = validaItem(item);

      if (erros.isNotEmpty) {
        if (mounted) {
          Utils().customShowDialog(
              'ERRO', 'Erro ao adicionar item', erros.join('\n\n'), context);
        }
        return;
      }

      final vendaAtualizada = await _vendaController.addItem(venda, item);
      _vendasItensController.getVendaItens(venda.vndId).then(
        (value) {
          setState(() {
            venda = vendaAtualizada.copyWith(itens: value);
            _vlDescontoCte.text = venda.vndDesconto.toStringAsFixed(2);
            _prDescontoCte.text = venda.vndPrDesconto.toStringAsFixed(2);
          });
        },
      );

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

    _emailCte.text = venda.vndEmail ?? '';
    _prDescontoCte.text = venda.vndPrDesconto.toStringAsFixed(2);
    _vlDescontoCte.text = venda.vndDesconto.toStringAsFixed(2);
    _tabelaCte.text = venda.vndPrAcrescimo.toStringAsFixed(2);
    _obsCte.text = venda.vndObs ?? '';

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

  void handlePrDescontoChange(String text) {
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 400), () async {
      final prDesc = double.tryParse(text);

      if (prDesc != null) {
        venda =
            _vendaController.totalizar(venda.copyWith(vndPrDesconto: prDesc));
        await _vendaController.salvarVenda(venda).then(
              (_) => setState(
                () {
                  _vlDescontoCte.text = venda.vndDesconto.toStringAsFixed(2);
                },
              ),
            );
      }
    });
  }

  void handleVlDescontoChange(String text) {
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 400), () async {
      final vlDesc = double.tryParse(text);

      if (vlDesc != null) {
        venda = _vendaController.totalizar(
            venda.copyWith(vndDesconto: vlDesc), 'VL');
        await _vendaController.salvarVenda(venda).then(
              (_) => setState(
                () {
                  _prDescontoCte.text = venda.vndPrDesconto.toStringAsFixed(2);
                },
              ),
            );
      }
    });
  }

  void handleEnviar() {
    Utils().customShowDialog(
      'CONFIRMAR',
      'Confirmar',
      'Deseja enviar o pedido?',
      context,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Sim'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Não'),
        ),
      ],
    ).then((value) async {
      if (value ?? false) return;

      if (mounted) Utils().showLoadingDialog(context, 'Enviando Pedido');

      final result = await _vendaController.enviarVenda(venda).then((_) {
        if (mounted) Navigator.of(context).pop();
      });

      if (result.isNotEmpty) {
        if (mounted) {
          Utils().customShowDialog(
              'ERRO', 'Erro ao enviar pedido', result, context);
        }
        return;
      }

      venda = venda.copyWith(vndEnviado: 'P');

      _vendaController.salvarVenda(venda).then((_) {
        setState(() {});
        if (mounted) {
          Navigator.of(context).pop();
          Utils().customShowDialog(
              'OK', 'Pedido enviado com sucesso!', '', context);
        }
      });
    });
  }

  void handleCancelar() {
    Utils().customShowDialog(
      'ALERTA',
      'Confirmar',
      'Deseja cancelar o pedido?',
      context,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Sim'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Não'),
        ),
      ],
    ).then((value) {
      final result = value ?? false;

      if (result) {
        venda = venda.copyWith(vndEnviado: 'C');
        _vendaController.salvarVenda(venda).then((_) {
          setState(() {});
        });
      }
    });
  }

  void handleTabelaChange(String text) {
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 400), () async {
      final prAcresc = double.tryParse(text);

      if (prAcresc != null) {
        venda = _vendaController
            .totalizar(venda.copyWith(vndPrAcrescimo: prAcresc / 100));
        await _vendaController.salvarVenda(venda).then((_) => setState(() {}));
      }
    });
  }

  void handleOptionsSelect(PedidoMenuOption option) async {
    switch (option) {
      case PedidoMenuOption.enviar:
        handleEnviar();

        break;

      case PedidoMenuOption.atualizarPrecos:
        print('atualizarPrecos');
        break;

      case PedidoMenuOption.email:
        print('email');
        break;

      case PedidoMenuOption.pdf:
        print('pdf');
        break;

      case PedidoMenuOption.cancelar:
        handleCancelar();

        break;
    }
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
          PedidoOptionsButton(
            vndEnviado: venda.vndEnviado,
            onSelect: (item) => handleOptionsSelect(item),
          ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Emissão',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lighSecondaryText,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(venda.vndDataHora),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          runSpacing: 10,
                          direction: Axis.horizontal,
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            ValorCard(
                              label: 'Total Pedido',
                              valor: venda.vndTotal,
                            ),
                            ValorCard(
                              label: 'Total Produtos',
                              valor: venda.vndValor,
                            ),
                            _parametrosController.parametros?.parCnpj ==
                                    '06145442000102'
                                ? ValorCard(
                                    label: 'Saldo Bon.',
                                    valor: venda.vndSaldoBonificacao -
                                        venda.vndTotalBonificacao,
                                  )
                                : ValorCard(
                                    label: 'Total ST',
                                    valor: venda.vndTotalSt,
                                  )
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
                                  spacing: 8,
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
                                                          fontSize: 16),
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
                                                                          16),
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
                                                  onTapOutside: (_) {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  },
                                                  readOnly:
                                                      venda.vndEnviado != 'N',
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
                                              'Endereço',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primary),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ClienteEnderecoCard(
                                                    hideTextOverflow: false,
                                                    showDescricao: false,
                                                    endereco: ClienteEndereco(
                                                        clieSeq: 0,
                                                        clieEndereco: venda
                                                            .vndEnderecoEnt,
                                                        clieNumero:
                                                            venda.vndNumeroEnt,
                                                        clieBairro:
                                                            venda.vndBairroEnt,
                                                        clieCidade:
                                                            venda.vndCidadeEnt,
                                                        clieEstado:
                                                            venda.vndEstadoEnt,
                                                        clieCep:
                                                            venda.vndCepEnt,
                                                        clieCompl:
                                                            venda.vndComplEnt),
                                                  ),
                                                ),
                                                if (venda.vndEnviado == 'N')
                                                  IconButton(
                                                    onPressed: () async {
                                                      final selectedEndereco =
                                                          await showModalBottomSheet<
                                                              ClienteEndereco?>(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        useSafeArea: true,
                                                        context: context,
                                                        builder: (_) =>
                                                            EscolherEnderecoModal(
                                                                cliCnpj: venda
                                                                        .vndCliCnpj ??
                                                                    ''),
                                                      );

                                                      if (selectedEndereco ==
                                                          null) {
                                                        return;
                                                      }

                                                      handleEnderecoChange(
                                                          selectedEndereco);
                                                    },
                                                    icon: const Icon(
                                                      Icons.search,
                                                      color: Colors.white,
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateColor
                                                              .resolveWith(
                                                        (_) {
                                                          return AppColors
                                                              .primary;
                                                        },
                                                      ),
                                                    ),
                                                  )
                                              ],
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
                                                    onBonifica:
                                                        handleBonificarItem,
                                                    cliCnpj:
                                                        venda.vndCliCnpj ?? '',
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
                                                  onBonifica:
                                                      handleBonificarItem,
                                                  cliCnpj:
                                                      venda.vndCliCnpj ?? '',
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
                                            vdiBonificado: item.vdiBonificado,
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
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _parametrosController
                                                .parametros?.parDesconto ==
                                            'N'
                                        ? const SizedBox.shrink()
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.spaceAround,
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Desconto (%)',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .lighSecondaryText,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                          child:
                                                              CustomTextField(
                                                            onChanged:
                                                                handlePrDescontoChange,
                                                            enabled: venda
                                                                    .vndEnviado ==
                                                                'N',
                                                            controller:
                                                                _prDescontoCte,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Desconto (R\$)',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .lighSecondaryText,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                          child:
                                                              CustomTextField(
                                                            onChanged:
                                                                handleVlDescontoChange,
                                                            enabled: venda
                                                                    .vndEnviado ==
                                                                'N',
                                                            controller:
                                                                _vlDescontoCte,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Column(
                                                    //   crossAxisAlignment:
                                                    //       CrossAxisAlignment
                                                    //           .start,
                                                    //   children: [
                                                    //     const Text(
                                                    //       'Tabela (%)',
                                                    //       style:
                                                    //           TextStyle(
                                                    //         fontSize:
                                                    //             12,
                                                    //         fontWeight:
                                                    //             FontWeight
                                                    //                 .w500,
                                                    //         color: AppColors
                                                    //             .lighSecondaryText,
                                                    //       ),
                                                    //     ),
                                                    //     SizedBox(
                                                    //       width: 100,
                                                    //       child:
                                                    //           CustomTextField(
                                                    //         onChanged:
                                                    //             handleTabelaChange,
                                                    //         enabled:
                                                    //             venda.vndEnviado ==
                                                    //                 'N',
                                                    //         controller:
                                                    //             _tabelaCte,
                                                    //         keyboardType:
                                                    //             TextInputType
                                                    //                 .number,
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Observações',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.lighSecondaryText,
                                          ),
                                        ),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxHeight: 150, maxWidth: 600),
                                          child: CustomTextField(
                                            onChanged: handleObsChange,
                                            enabled: venda.vndEnviado == 'N',
                                            maxLines: null,
                                            minLines: 10,
                                            controller: _obsCte,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
