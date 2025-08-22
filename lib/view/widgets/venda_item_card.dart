import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class VendaItemCard extends StatelessWidget {
  final int vdiProdId;
  final String vdiDescricao;
  final double vdiQtd;
  final double vdiUnit;
  final double vdiTotal;

  const VendaItemCard(
      {super.key,
      required this.vdiProdId,
      required this.vdiDescricao,
      required this.vdiQtd,
      required this.vdiUnit,
      required this.vdiTotal});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
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
                Text(
                  vdiProdId.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Text(' • '),
                Expanded(
                  child: Text(
                    vdiDescricao,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'Qtd: ',
                  style: TextStyle(color: AppColors.lighSecondaryText),
                ),
                Text(vdiQtd.toString()),
                const Text(
                  ' Unit.: ',
                  style: TextStyle(color: AppColors.lighSecondaryText),
                ),
                Text('R\$ ${vdiUnit.toStringAsFixed(2)}'),
                const Text(
                  ' Total: ',
                  style: TextStyle(color: AppColors.lighSecondaryText),
                ),
                Text('R\$ ${vdiTotal.toStringAsFixed(2)}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
