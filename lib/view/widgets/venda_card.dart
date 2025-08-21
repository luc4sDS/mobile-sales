import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sales/view/widgets/venda_situacao_chip.dart';

class VendaCard extends StatelessWidget {
  final int id;
  final String cliente;
  final String cidade;
  final String estado;
  final DateTime emissao;
  final double total;
  final String situacao;
  final void Function() handleTap;

  const VendaCard({
    super.key,
    required this.id,
    required this.cliente,
    required this.emissao,
    required this.total,
    required this.situacao,
    required this.handleTap,
    required this.estado,
    required this.cidade,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleTap,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border(
            bottom:
                BorderSide(width: 1, color: AppColors.lightSecondaryBackground),
          ),
          // color: AppColors.lightSecondaryBackground,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Row(children: [
                  Text(
                    id.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Text(' • '),
                  Expanded(
                    child: Text(
                      cliente,
                      style:
                          const TextStyle(color: AppColors.lighSecondaryText),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                ]),
                Text(
                  '${DateFormat('dd/MM/yyyy').format(emissao)} - $estado, $cidade',
                  style: const TextStyle(color: AppColors.lighSecondaryText),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VendaSituacaoChip(
                        situacao: situacao,
                      ),
                      Text('R\$ ${total.toStringAsFixed(2)}')
                    ])
              ]),
        ),
      ),
    );
  }
}
