import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';

class ClienteEnderecoCard extends StatelessWidget {
  final ClienteEndereco endereco;
  const ClienteEnderecoCard({
    super.key,
    required this.endereco,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${endereco.clieEndereco ?? '---'}${endereco.clieNumero != null ? ', ${endereco.clieNumero}' : ''}',
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
                '${endereco.clieCidade ?? '---'}${endereco.clieEstado != null ? ' - ${endereco.clieEstado}' : ''}${endereco.clieCep != null ? ', ${endereco.clieCep}' : ''}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.lighSecondaryText),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
