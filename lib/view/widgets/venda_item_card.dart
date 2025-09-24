import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class VendaItemCard extends StatelessWidget {
  final int vdiProdId;
  final String vdiDescricao;
  final double vdiQtd;
  final double vdiUnit;
  final double vdiTotal;
  final bool vdiBonificado;
  final void Function() onTap;

  const VendaItemCard({
    super.key,
    required this.vdiProdId,
    required this.vdiDescricao,
    required this.vdiQtd,
    required this.vdiUnit,
    required this.vdiTotal,
    required this.onTap,
    required this.vdiBonificado,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: vdiBonificado ? AppColors.lightEnviadoBg : Colors.transparent,
          border: const Border(
            bottom: BorderSide(
              width: 1,
              color: AppColors.lightSecondaryBackground,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(children: [
                          TextSpan(
                            text: vdiProdId.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                          const TextSpan(
                            text: ' • ',
                            style: TextStyle(
                              color: AppColors.lightPrimaryText,
                            ),
                          ),
                          TextSpan(
                              text: vdiDescricao,
                              style: const TextStyle(
                                  color: AppColors.lightPrimaryText)),
                        ])),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Qtd: ',
                              style:
                                  TextStyle(color: AppColors.lighSecondaryText),
                            ),
                            Text(vdiQtd.toString()),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              ' Unit.: ',
                              style:
                                  TextStyle(color: AppColors.lighSecondaryText),
                            ),
                            Text('R\$ ${vdiUnit.toStringAsFixed(2)}'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              ' Total: ',
                              style:
                                  TextStyle(color: AppColors.lighSecondaryText),
                            ),
                            Text('R\$ ${vdiTotal.toStringAsFixed(2)}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
