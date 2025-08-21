import 'package:flutter/material.dart';
import 'package:mobile_sales/model/venda.dart';
import 'package:mobile_sales/view/widgets/venda_situacao_chip.dart';

class PedidoInfoPage extends StatelessWidget {
  final Venda venda;

  const PedidoInfoPage({
    super.key,
    required this.venda,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(venda.vndId.toString()),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: VendaSituacaoChip(situacao: venda.vndEnviado),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.black,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
