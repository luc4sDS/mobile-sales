import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/view/widgets/valor_card.dart';

class UltimasVendas {
  final String emissao;
  final int codigo;
  final String nomepro;
  final double qtd;
  final double unit;
  final int sequen;

  const UltimasVendas({
    required this.emissao,
    required this.codigo,
    required this.nomepro,
    required this.qtd,
    required this.unit,
    required this.sequen,
  });
}

class EditarItemModal extends StatefulWidget {
  final VendaItem item;
  final void Function(VendaItem) onSave;
  final bool readOnly;

  const EditarItemModal({
    super.key,
    required this.item,
    required this.onSave,
    required this.readOnly,
  });

  @override
  State<EditarItemModal> createState() => _EditarItemModalState();
}

class _EditarItemModalState extends State<EditarItemModal> {
  final _qtdCte = TextEditingController();
  final _unitarioCte = TextEditingController();
  final _descontoCte = TextEditingController();
  final _obsCte = TextEditingController();
  late Future<List<UltimasVendas>> _futureUltimasVendas;

  // Future<List<UltimasVendas>> getUltimasVendas() async {
  //   final dio = Dio();
  // }

  @override
  void initState() {
    super.initState();

    _qtdCte.text = widget.item.vdiQtd.toStringAsFixed(2);
    _unitarioCte.text = widget.item.vdiUnit.toStringAsFixed(2);
    _descontoCte.text =
        ((widget.item.vdiDesc / widget.item.vdiPreco) * 100).toStringAsFixed(2);
    _obsCte.text = widget.item.vdiObs ?? '';
  }

  @override
  Widget build(BuildContext context) {
    VendaItem item = widget.item;

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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          child: Text(
                                            item.vdiDescricao,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            overflow: TextOverflow.visible,
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
                                          color: AppColors.lighSecondaryText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextField(
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
                                          color: AppColors.lighSecondaryText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextField(
                                        controller: _unitarioCte,
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
                                        'Desc. (%)',
                                        style: TextStyle(
                                          color: AppColors.lighSecondaryText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextField(
                                        controller: _descontoCte,
                                        textAlign: TextAlign.end,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ValorCard(label: 'Valor ST', valor: item.vdiVlst),
                              ValorCard(label: 'Total', valor: item.vdiTotal),
                            ],
                          ),
                          Column(
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
                                child: TextField(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => widget.onSave(item),
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
