import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/view/widgets/editar_item_modal.dart';

class AdicionarProdutoModal extends StatefulWidget {
  const AdicionarProdutoModal({super.key});

  @override
  State<AdicionarProdutoModal> createState() => _AdicionarProdutoModalState();
}

class _AdicionarProdutoModalState extends State<AdicionarProdutoModal> {
  @override
  Widget build(BuildContext context) {
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
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.lightSecondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            final item = VendaItem(
                              vdiVndId: 0,
                              vdiProdCod: 0,
                              vdiDescricao: '',
                              vdiQtd: 10,
                              vdiUnit: 10,
                              vdiTotal: 10,
                              vdiTotalg: 10,
                              vdiPreco: 10,
                            );

                            Navigator.of(context).pop();

                            showModalBottomSheet(
                              context: context,
                              builder: (context) => EditarItemModal(
                                item: item,
                                onSave: (item) {},
                                readOnly: false,
                              ),
                            );
                          },
                          child: Text('teste'))
                    ],
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
