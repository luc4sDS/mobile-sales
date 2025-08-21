import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:intl/intl.dart';

class VendaCard extends StatelessWidget {
  final int id;
  final String cliente;
  final DateTime emissao;
  final double total;
  final String situacao;
  final void Function() handleTap;

  const VendaCard(
      {super.key,
      required this.id,
      required this.cliente,
      required this.emissao,
      required this.total,
      required this.situacao,
      required this.handleTap});

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
                  DateFormat('dd/MM/yyyy').format(emissao),
                  style: const TextStyle(color: AppColors.lighSecondaryText),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: situacao == 'N'
                              ? AppColors.lightAbertoBg
                              : situacao == 'P'
                                  ? AppColors.lightEnviadoBg
                                  : AppColors.lightCanceladoBg,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                          child: Text(
                            situacao == 'N'
                                ? 'ABERTO'
                                : situacao == 'P'
                                    ? 'ENVIADO'
                                    : 'CANCELADO',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: situacao == 'N'
                                    ? AppColors.lightAbertoText
                                    : situacao == 'P'
                                        ? AppColors.lightEnviadoText
                                        : AppColors.lightCanceladoText),
                          ),
                        ),
                      ),
                      Text('R\$ ${total.toStringAsFixed(2)}')
                    ])
              ]),
        ),
      ),
    );
  }
}
