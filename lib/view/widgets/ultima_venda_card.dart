import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/ultimas_vendas.dart';

class UltimaVendaCard extends StatelessWidget {
  final UltimasVendas ultimaVenda;
  const UltimaVendaCard({
    super.key,
    required this.ultimaVenda,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom:
              BorderSide(width: 1, color: AppColors.lightSecondaryBackground),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: 'Qtd.: ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.lighSecondaryText)),
                    TextSpan(
                        text: '${ultimaVenda.uvQtd}  ',
                        style: const TextStyle(
                            color: AppColors.lightPrimaryText,
                            fontFamily: 'Poppins')),
                    const TextSpan(
                        text: 'Unit.: ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.lighSecondaryText)),
                    TextSpan(
                        text: '${ultimaVenda.uvUnitario.toStringAsFixed(2)}  ',
                        style: const TextStyle(
                            color: AppColors.lightPrimaryText,
                            fontFamily: 'Poppins')),
                    const TextSpan(
                        text: 'Total: ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.lighSecondaryText)),
                    TextSpan(
                        text: '${ultimaVenda.uvTotalG.toStringAsFixed(2)}  ',
                        style: const TextStyle(
                            color: AppColors.lightPrimaryText,
                            fontFamily: 'Poppins')),
                  ]),
                  overflow: TextOverflow.clip,
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: 'Venda.: ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.lighSecondaryText,
                      ),
                    ),
                    TextSpan(
                      text: '${ultimaVenda.uvVndId}  ',
                      style: const TextStyle(
                        color: AppColors.lightPrimaryText,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const TextSpan(
                      text: 'Emissão: ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.lighSecondaryText,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${DateFormat('dd/MM/yyyy').format(ultimaVenda.uvEmissao)}  ',
                      style: const TextStyle(
                          color: AppColors.lightPrimaryText,
                          fontFamily: 'Poppins'),
                    ),
                  ]),
                  overflow: TextOverflow.clip,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
