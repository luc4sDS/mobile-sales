import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/produto_controller.dart';
import 'package:mobile_sales/controller/vendas_controller.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/parametros.dart';
import 'package:mobile_sales/model/produto.dart';
import 'package:mobile_sales/model/ultimas_vendas.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/utils/utils.dart';
import 'package:mobile_sales/view/widgets/CustomCheckBox.dart';
import 'package:mobile_sales/view/widgets/custom_text_field.dart';
import 'package:mobile_sales/view/widgets/ultima_venda_card.dart';
import 'package:mobile_sales/view/widgets/valor_card.dart';

class EditarItemModal extends StatefulWidget {
  final VendaItem item;
  final String estado;
  final String cliCnpj;
  final void Function(VendaItem) onSave;
  final void Function(int itemId)? onDelete;
  final bool? readOnly;
  final Function(VendaItem) onBonifica;

  const EditarItemModal({
    super.key,
    required this.item,
    required this.onSave,
    this.readOnly,
    required this.estado,
    required this.onDelete,
    required this.cliCnpj,
    required this.onBonifica,
  });

  @override
  State<EditarItemModal> createState() => _EditarItemModalState();
}

class _EditarItemModalState extends State<EditarItemModal> {
  //Controllers
  final _prodController = ProdutoController();
  final _vendasController = VendasController();
  final _parametrosController = ParametrosController();

  //TextEditingControllers
  final _qtdCte = TextEditingController();
  final _unitarioCte = TextEditingController();
  final _descontoCte = TextEditingController();
  final _obsCte = TextEditingController();
  final _descricaoCte = TextEditingController();

  //Variables
  late VendaItem item;
  late Produto? produto;
  bool loading = false;
  late Parametros? parametros;
  late Future<List<UltimasVendas>> _ultimasVendasFuture;
  bool lanceCheckBoxValue = false;

  Future<void> handleInitState() async {
    item = widget.item;
    produto = await _prodController.getProdutoById(item.vdiProdCod);
    final res = await _parametrosController.getParametros();
    _ultimasVendasFuture = _vendasController.getUltimasVendas(
        item.vdiProdCod, widget.cliCnpj, item.vdiVndId);

    if (res.isEmpty) {
      parametros = _parametrosController.parametros;
    } else {
      parametros = null;
    }

    _qtdCte.text =
        widget.item.vdiQtd == 0 ? '' : widget.item.vdiQtd.toStringAsFixed(2);
    _unitarioCte.text = widget.item.vdiUnit.toStringAsFixed(2);
    _descricaoCte.text = widget.item.vdiDescricao;

    if (widget.item.vdiProdCod == 0) {
      _descontoCte.text = '0.0';
    } else {
      _descontoCte.text = ((widget.item.vdiDesc / widget.item.vdiPreco) * 100)
          .toStringAsFixed(2);
    }
    _obsCte.text = widget.item.vdiObs ?? '';
    lanceCheckBoxValue = widget.item.vdiLance == 'S';
  }

  @override
  void initState() {
    super.initState();

    loading = true;
    handleInitState().then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  void handleSave(VendaItem item) {
    final qtd = double.tryParse(_qtdCte.text) ?? 0;
    final unit = double.tryParse(_unitarioCte.text) ?? 0;
    final desc = max<double>(0, item.vdiPreco - unit);
    final total = qtd * unit;
    final vlSt = Utils().calculaST(
        total, item.vdiAlintra, item.vdiAlinter, item.vdiMva, widget.estado);

    item = item.copyWith(
      vdiDescricao: _descricaoCte.text.trim().toUpperCase(),
      vdiQtd: qtd,
      vdiUnit: unit,
      vdiDesc: desc,
      vdiObs: _obsCte.text,
      vdiVlst: vlSt,
      vdiTotal: total,
      vdiTotalg: total,
      vdiLance: lanceCheckBoxValue ? 'S' : 'N',
      vdiVbonificacao: (item.vdiPbonificacao / 100) * item.vdiTotal,
    );

    widget.onSave(item);
  }

  void handleBonifica(VendaItem item) {
    final qtd = double.tryParse(_qtdCte.text) ?? 0;
    final unit = double.tryParse(_unitarioCte.text) ?? 0;
    final desc = max<double>(0, item.vdiPreco - unit);
    final total = qtd * unit;
    final vlSt = Utils().calculaST(
        total, item.vdiAlintra, item.vdiAlinter, item.vdiMva, widget.estado);

    item = item.copyWith(
      vdiDescricao: _descricaoCte.text.trim().toUpperCase(),
      vdiQtd: qtd,
      vdiUnit: unit,
      vdiDesc: desc,
      vdiObs: _obsCte.text,
      vdiVlst: vlSt,
      vdiTotal: total,
      vdiTotalg: total,
      vdiLance: lanceCheckBoxValue ? 'S' : 'N',
      vdiVbonificacao: (item.vdiPbonificacao / 100) * item.vdiTotal,
      vdiBonificado: true,
    );

    widget.onBonifica(item);
  }

  void handleDescChanged(String value) {
    final desc = double.tryParse(_descontoCte.text) ?? 0;
    final qtd = double.tryParse(_qtdCte.text) ?? 0.0;

    double unitario;

    unitario = max(item.vdiPreco * (1 - (max<double>(desc, 0) / 100)), 0);

    final total = max<double>((unitario * (1 - (desc / 100))) * qtd, 0);
    final valorSt = max<double>(
      Utils().calculaST(
          total, item.vdiAlintra, item.vdiAlinter, item.vdiMva, widget.estado),
      0,
    );

    setState(() {
      item = item.copyWith(
        vdiTotal: total,
        vdiTotalg: total,
        vdiVlst: valorSt,
        vdiUnit: unitario,
      );
      _unitarioCte.text = item.vdiUnit.toStringAsFixed(2);
    });
  }

  void handleQtdChanged(String value) {
    double qtd = double.tryParse(_qtdCte.text) ?? 0;

    double total = item.vdiUnit * qtd;
    final valorSt = max<double>(
        Utils().calculaST(total, item.vdiAlintra, item.vdiAlinter, item.vdiMva,
            widget.estado),
        0);

    setState(() {
      item = item.copyWith(
        vdiTotal: total,
        vdiTotalg: total,
        vdiVlst: valorSt,
        vdiQtd: qtd,
      );
    });
  }

  void handleUnitChanged(String value) {
    double desc;
    final unitario = double.tryParse(_unitarioCte.text) ?? 0.0;
    final qtd = double.tryParse(_qtdCte.text) ?? 0.0;

    if (item.vdiPreco > 0) {
      desc = max<double>(
          ((item.vdiPreco - max<double>(unitario, 0)) / item.vdiPreco) * 100,
          0);
    } else {
      desc = 0.0;
    }

    final total = max<double>((unitario * (1 - (desc / 100))) * qtd, 0);
    final valorSt = max<double>(
        Utils().calculaST(total, item.vdiAlintra, item.vdiAlinter, item.vdiMva,
            widget.estado),
        0);

    setState(() {
      item = item.copyWith(
          vdiTotal: total,
          vdiTotalg: total,
          vdiVlst: valorSt,
          vdiDesc: desc,
          vdiUnit: unitario);
      _descontoCte.text = item.vdiDesc.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = widget.readOnly ?? false;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              color: AppColors.primary,
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.resolveWith((state) => AppColors.erro),
              ),
            )
          ]),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Código',
                                        style: TextStyle(
                                          color: AppColors.lighSecondaryText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        item.vdiProdCod.toString(),
                                        style: const TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Descrição',
                                          style: TextStyle(
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: item.vdiProdCod == 0
                                                  ? CustomTextField(
                                                      controller: _descricaoCte,
                                                    )
                                                  : Text(
                                                      item.vdiDescricao,
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 120),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Qtd.',
                                            style: TextStyle(
                                              color:
                                                  AppColors.lighSecondaryText,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          CustomTextField(
                                            onChanged: handleQtdChanged,
                                            enabled: !readOnly,
                                            controller: _qtdCte,
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 120),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Unitário',
                                            style: TextStyle(
                                              color:
                                                  AppColors.lighSecondaryText,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          CustomTextField(
                                            onChanged: handleUnitChanged,
                                            enabled: !readOnly &&
                                                (parametros?.parDesconto ==
                                                        'S' ||
                                                    item.vdiProdCod == 0),
                                            controller: _unitarioCte,
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  parametros?.parDesconto == 'S'
                                      ? Flexible(
                                          flex: 1,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 120),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Desc. (%)',
                                                  style: TextStyle(
                                                    color: AppColors
                                                        .lighSecondaryText,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                CustomTextField(
                                                  onChanged: handleDescChanged,
                                                  enabled: !readOnly &&
                                                      item.vdiProdCod != 0,
                                                  controller: _descontoCte,
                                                  textAlign: TextAlign.end,
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  produto?.prodCorte == 'S'
                                      ? CustomCheckBox(
                                          value: lanceCheckBoxValue,
                                          onTap: () {
                                            lanceCheckBoxValue =
                                                !lanceCheckBoxValue;
                                            setState(() {});
                                          },
                                          onChanged: (value) {
                                            lanceCheckBoxValue = value ?? false;
                                            setState(() {});
                                          },
                                          label: 'Lance',
                                        )
                                      : const SizedBox.shrink(),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      alignment: WrapAlignment.end,
                                      children: [
                                        ValorCard(
                                          label: 'Valor ST',
                                          valor: item.vdiVlst,
                                        ),
                                        ValorCard(
                                          label: 'Total',
                                          valor: item.vdiTotal,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Observações',
                                    style: TextStyle(
                                      color: AppColors.lighSecondaryText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: CustomTextField(
                                      enabled: !readOnly,
                                      maxLines: null,
                                      minLines: 10,
                                      controller: _obsCte,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: FutureBuilder(
                                    future: _ultimasVendasFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      }

                                      if (snapshot.hasError) {
                                        Text(
                                            'Erro ao carregar ultimas Vendas: ${snapshot.error}');
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      final ultimasVendas = snapshot.data!;

                                      return Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                'Últimas vendas',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors
                                                      .lighSecondaryText,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: ultimasVendas.length,
                                              itemBuilder: (context, index) {
                                                final item =
                                                    ultimasVendas[index];
                                                return UltimaVendaCard(
                                                  ultimaVenda: item,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                        if (!readOnly)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.spaceAround,
                                    children: [
                                      if ((item.vdiId ?? 0) != 0)
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateColor.resolveWith(
                                                    (_) => AppColors.erro),
                                          ),
                                          onPressed: () => widget.onDelete !=
                                                  null
                                              ? widget
                                                  .onDelete!(item.vdiId ?? 0)
                                              : {},
                                          child: const Text('Excluir'),
                                        ),
                                      ElevatedButton(
                                        onPressed: () {
                                          handleSave(item);
                                        },
                                        child: const Text('Salvar'),
                                      ),
                                      if ((produto?.prodBonifica == 'S' &&
                                          (item.vdiId ?? 0) == 0))
                                        TextButton(
                                          onPressed: () => handleBonifica(item),
                                          child: const Text('Bonificar'),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
