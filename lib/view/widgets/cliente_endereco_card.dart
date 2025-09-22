import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';

class ClienteEnderecoCard extends StatelessWidget {
  final ClienteEndereco endereco;
  final Function()? onTap;
  final bool? showDescricao;
  final bool? hideTextOverflow;

  const ClienteEnderecoCard({
    super.key,
    required this.endereco,
    this.onTap,
    this.showDescricao,
    this.hideTextOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: (showDescricao ?? true)
                    ? AppColors.lightSecondaryBackground
                    : Colors.transparent,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                (showDescricao ?? true)
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              overflow: (hideTextOverflow ?? true)
                                  ? TextOverflow.ellipsis
                                  : TextOverflow.clip,
                              endereco.clieDescricao ?? '',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${endereco.clieEndereco ?? '---'}${(endereco.clieNumero ?? '').isNotEmpty ? ', ${endereco.clieNumero}' : ''}',
                        overflow: (hideTextOverflow ?? true)
                            ? TextOverflow.ellipsis
                            : TextOverflow.clip,
                        style: TextStyle(
                            // fontWeight: FontWeight.w500,
                            color: (showDescricao ?? true)
                                ? AppColors.lighSecondaryText
                                : AppColors.lightPrimaryText),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${endereco.clieCidade ?? '---'} - ${endereco.clieEstado ?? ''}${(endereco.clieCep ?? '').isNotEmpty ? ', ${endereco.clieCep}' : ''}',
                        overflow: (hideTextOverflow ?? true)
                            ? TextOverflow.ellipsis
                            : TextOverflow.clip,
                        style: TextStyle(
                          color: (showDescricao ?? true)
                              ? AppColors.lighSecondaryText
                              : AppColors.lightPrimaryText,
                        ),
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
