import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/view/widgets/editar_item_modal.dart';

class ProdutoCard extends StatelessWidget {
  final int codigo;
  final String descricao;
  final double preco;
  final String embalagem;
  final double pmin;
  final void Function() onTap;

  const ProdutoCard({
    super.key,
    required this.descricao,
    required this.codigo,
    required this.preco,
    required this.embalagem,
    required this.pmin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: AppColors.lightSecondaryBackground, width: 1),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      overflow: TextOverflow.visible,
                      text: TextSpan(
                        style:
                            const TextStyle(color: AppColors.lightPrimaryText),
                        children: <TextSpan>[
                          TextSpan(
                            text: codigo.toString(),
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(text: ' • ${descricao.trim()}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Preco: ',
                        style: TextStyle(
                            color: AppColors.lighSecondaryText,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(preco.toStringAsFixed(2)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Emb.: ',
                        style: TextStyle(
                            color: AppColors.lighSecondaryText,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(embalagem),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Min.: ',
                        style: TextStyle(
                            color: AppColors.lighSecondaryText,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(pmin.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
