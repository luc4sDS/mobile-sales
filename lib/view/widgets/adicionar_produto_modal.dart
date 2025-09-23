import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/produto_controller.dart';
import 'package:mobile_sales/controller/produto_st_controller.dart';
import 'package:mobile_sales/controller/tabela_controller.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/produto.dart';
import 'package:mobile_sales/model/venda_item.dart';
import 'package:mobile_sales/view/widgets/editar_item_modal.dart';
import 'package:mobile_sales/view/widgets/loading_error.dart';
import 'package:mobile_sales/view/widgets/produto_card.dart';

class AdicionarProdutoModal extends StatefulWidget {
  final Function(VendaItem) onSave;
  final int vendaId;
  final String vendaChave;
  final double vendaPrAcrescimo;
  final String vendaEstado;
  final String cliCnpj;
  final Function(VendaItem) onBonifica;

  const AdicionarProdutoModal({
    super.key,
    required this.onSave,
    required this.vendaId,
    required this.vendaChave,
    required this.vendaPrAcrescimo,
    required this.vendaEstado,
    required this.cliCnpj,
    required this.onBonifica,
  });

  @override
  State<AdicionarProdutoModal> createState() => _AdicionarProdutoModalState();
}

class _AdicionarProdutoModalState extends State<AdicionarProdutoModal> {
  final _pesquisaCte = TextEditingController();
  final _pesquisaFocusNode = FocusNode();
  final _produtoController = ProdutoController();
  final _stController = ProdutoStController();
  final _tabelaController = TabelaController();

  late Future<List<Produto>> _produtosFuture;
  late int tabela;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    handleInitState();
  }

  void handleInitState() async {
    loading = true;

    tabela = await _tabelaController.getTabelaIdByUF(widget.vendaEstado);
    _produtosFuture =
        _produtoController.getProdutos(_pesquisaCte.text, tabela: tabela);

    setState(() {
      loading = false;
    });
  }

  void handleAvulsoTap() async {
    _pesquisaFocusNode.unfocus();

    final item = VendaItem(
      vdiVndId: widget.vendaId,
      vdiVndChave: widget.vendaChave,
      vdiProdCod: 0,
      vdiEan: '',
      vdiDescricao: '',
      vdiQtd: 0,
      vdiAlinter: 0,
      vdiAlintra: 0,
      vdiRedbase: 0,
      vdiAlipi: 0,
      vdiMva: 0,
      vdiPeso: 0,
      vdiUnit: 0,
      vdiTotal: 0,
      vdiDesc: 0,
      vdiTotalg: 0,
      vdiPreco: 0,
      vdiPmin: 0,
      vdiCusto: 0,
      vdiPbonificacao: 0,
      vdiVbonificacao: 0,
    );

    if (mounted) {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return EditarItemModal(
            onBonifica: widget.onBonifica,
            onDelete: (_) {},
            cliCnpj: widget.cliCnpj,
            estado: widget.vendaEstado,
            item: item,
            onSave: widget.onSave,
            readOnly: false,
          );
        },
      );
    }
  }

  void handleTap(Produto produto) async {
    _pesquisaFocusNode.unfocus();

    final st =
        await _stController.getProdutoSt(produto.prodId, widget.vendaEstado);

    final item = VendaItem(
      vdiVndId: widget.vendaId,
      vdiVndChave: widget.vendaChave,
      vdiProdCod: produto.prodId,
      vdiEan: produto.prodCbarra,
      vdiDescricao: produto.prodDescricao,
      vdiQtd: 0,
      vdiAlinter: st?.pstIcmsinter ?? 0,
      vdiAlintra: st?.pstIcmsintra ?? 0,
      vdiRedbase: st?.pstReducao ?? 0,
      vdiAlipi: 0,
      vdiMva: st?.pstMargem ?? 0,
      vdiPeso: 0,
      vdiUnit: produto.prodPreco * (1 + widget.vendaPrAcrescimo),
      vdiTotal: 0,
      vdiDesc: 0,
      vdiTotalg: 0,
      vdiPreco: produto.prodPreco,
      vdiPmin: produto.prodPmin == null || produto.prodPmin == 0
          ? 0
          : produto.prodPmin!,
      vdiCusto: 0,
      vdiPbonificacao: produto.prodPbonificacao ?? 0,
    );

    if (mounted) {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return EditarItemModal(
            onBonifica: widget.onBonifica,
            onDelete: (_) {},
            cliCnpj: widget.cliCnpj,
            estado: widget.vendaEstado,
            item: item,
            onSave: widget.onSave,
            readOnly: false,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                color: AppColors.primary,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith(
                      (state) => AppColors.erro),
                ),
              )
            ]),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 10,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Adicionar Produto',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: _pesquisaFocusNode,
                            onChanged: (_) => {
                              setState(() {
                                _produtosFuture = _produtoController
                                    .getProdutos(_pesquisaCte.text,
                                        tabela: tabela);
                              })
                            },
                            controller: _pesquisaCte,
                            decoration: const InputDecoration(
                              label: Text('Pesquisa'),
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        IconButton(
                            style: const ButtonStyle(
                                backgroundColor: WidgetStateProperty.fromMap(
                                    {WidgetState.any: AppColors.primary})),
                            onPressed: handleAvulsoTap,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: FutureBuilder(
                              future: _produtosFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return SingleChildScrollView(
                                    child: LoadingError(
                                      title: 'Erro ao buscar produtos',
                                      error: snapshot.error.toString(),
                                      retry: () => setState(() {
                                        _produtosFuture = _produtoController
                                            .getProdutos(_pesquisaCte.text,
                                                tabela: tabela);
                                      }),
                                    ),
                                  );
                                }

                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: Text('Nenhum produto encontrado'));
                                }

                                final produtos = snapshot.data!;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: produtos.length,
                                  itemBuilder: (context, i) {
                                    final produto = produtos[i];

                                    return ProdutoCard(
                                      codigo: produto.prodId,
                                      valorBon:
                                          ((produto.prodPbonificacao ?? 0) *
                                                  produto.prodPreco) /
                                              100,
                                      descricao: produto.prodDescricao,
                                      embalagem: produto.prodEmbalagem,
                                      pmin: produto.prodPmin ?? 0,
                                      preco: produto.prodPreco,
                                      onTap: () => handleTap(produto),
                                      bonifica: produto.prodBonifica == 'S',
                                    );
                                  },
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
