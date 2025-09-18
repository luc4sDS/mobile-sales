import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/produto_controller.dart';
import 'package:mobile_sales/model/produto.dart';
import 'package:mobile_sales/view/widgets/loading_error.dart';
import 'package:mobile_sales/view/widgets/main_options_button.dart';
import 'package:mobile_sales/view/widgets/produto_card.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final _pesquisaCte = TextEditingController();
  final _produtoController = ProdutoController();
  late Future<List<Produto>> _produtosFuture;

  @override
  void initState() {
    super.initState();

    _produtosFuture = _produtoController.getProdutos(_pesquisaCte.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: const [
          MainOptionsButton(),
        ],
        automaticallyImplyLeading: false,
        title: const Text('Produtos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (_) {
                      setState(() {
                        _produtosFuture =
                            _produtoController.getProdutos(_pesquisaCte.text);
                      });
                    },
                    controller: _pesquisaCte,
                    decoration: const InputDecoration(
                      label: Text('Pesquisar'),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _produtosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return LoadingError(
                      title: 'Erro ao buscar Produtos',
                      error: '${snapshot.error}',
                      retry: () => setState(() {
                        _produtosFuture =
                            _produtoController.getProdutos(_pesquisaCte.text);
                      }),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Não foi encontrado nenhum produto'),
                    );
                  }

                  final produtos = snapshot.data!;

                  return ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        final produto = produtos[index];

                        return ProdutoCard(
                          descricao: produto.prodDescricao,
                          codigo: produto.prodId,
                          preco: produto.prodPreco,
                          embalagem: produto.prodEmbalagem,
                          pmin: produto.prodPmin ?? 0,
                          onTap: () {},
                          valorBon: ((produto.prodPbonificacao ?? 0) *
                                  produto.prodPreco) /
                              100,
                          bonifica: produto.prodBonifica == 'S',
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
