import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class ProdutoCard extends StatelessWidget {
  final int codigo;
  final String descricao;
  final double preco;
  final String? embalagem;
  final double pmin;
  final void Function() onTap;
  final double valorBon;
  final bool bonifica;

  const ProdutoCard({
    super.key,
    required this.descricao,
    required this.codigo,
    required this.preco,
    required this.embalagem,
    required this.pmin,
    required this.onTap,
    required this.valorBon,
    required this.bonifica,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: AppColors.lightSecondaryBackground, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
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
              Wrap(
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
                  const SizedBox(
                    width: 10,
                  ),
                  embalagem != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Emb.: ',
                              style: TextStyle(
                                  color: AppColors.lighSecondaryText,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(embalagem ?? '-'),
                          ],
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                    width: embalagem != null ? 10 : 0,
                  ),
                  pmin > 0
                      ? Row(
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
                        )
                      : const SizedBox.shrink(),
                  SizedBox(width: pmin > 0 ? 10 : 0),
                  bonifica
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Vlr. Bon.: ',
                              style: TextStyle(
                                  color: AppColors.lighSecondaryText,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(valorBon.toStringAsFixed(2)),
                          ],
                        )
                      : const SizedBox.shrink(),
                  SizedBox(width: bonifica ? 10 : 0)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
