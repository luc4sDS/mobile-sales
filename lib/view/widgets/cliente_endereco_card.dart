import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';

class ClienteEnderecoCard extends StatelessWidget {
  final ClienteEndereco endereco;
  final Function()? onTap;

  const ClienteEnderecoCard({
    super.key,
    required this.endereco,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
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
                  children: [
                    Expanded(
                      child: Text(
                        '${endereco.clieEndereco ?? '---'}${(endereco.clieNumero ?? '').isNotEmpty ? ', ${endereco.clieNumero}' : ''}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${endereco.clieCidade ?? '---'} - ${endereco.clieEstado ?? ''}${(endereco.clieCep ?? '').isNotEmpty ? ', ${endereco.clieCep}' : ''}',
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: AppColors.lighSecondaryText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
