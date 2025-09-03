import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class ClienteCard extends StatelessWidget {
  final int id;
  final String razao;
  final String cidade;
  final String uf;
  final String cnpj;
  final void Function() onTap;
  final bool? hideTextOverflow;

  const ClienteCard({
    super.key,
    required this.id,
    required this.razao,
    required this.cidade,
    required this.uf,
    required this.cnpj,
    required this.onTap,
    this.hideTextOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightSecondaryBackground),
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
                    id.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: AppColors.primary),
                  ),
                  const Text(' • '),
                  Expanded(
                    child: Text(
                      razao,
                      overflow: hideTextOverflow ?? true
                          ? TextOverflow.ellipsis
                          : TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'CNPJ: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    cnpj,
                    style: const TextStyle(color: AppColors.lighSecondaryText),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    '$cidade, $uf',
                    style: const TextStyle(
                      color: AppColors.lighSecondaryText,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
