import 'package:flutter/material.dart';
import 'package:mobile_sales/model/produto.dart';

class ProdutosInfoPage extends StatelessWidget {
  final Produto produto;

  const ProdutosInfoPage({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(produto.prodId.toString()),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
