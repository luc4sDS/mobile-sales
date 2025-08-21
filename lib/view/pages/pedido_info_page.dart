import 'package:flutter/material.dart';
import 'package:mobile_sales/model/venda.dart';

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
      ),
    );
  }
}
