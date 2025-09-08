import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/sincronia_controller.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/cliente.dart';
import 'package:mobile_sales/model/cliente_contato.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';
import 'package:mobile_sales/model/forma_meio.dart';
import 'package:mobile_sales/model/forma_pagamento.dart';
import 'package:mobile_sales/model/meio_pagamento.dart';
import 'package:mobile_sales/model/produto.dart';
import 'package:mobile_sales/model/produto_st.dart';
import 'package:mobile_sales/model/tabela.dart';
import 'package:mobile_sales/model/tabela_preco.dart';
import 'package:mobile_sales/model/tipo_entrega.dart';
import 'package:mobile_sales/utils/utils.dart';
import 'package:mobile_sales/view/widgets/CustomCheckBox.dart';

class SincronizarPage extends StatefulWidget {
  const SincronizarPage({super.key});

  @override
  State<SincronizarPage> createState() => _SincronizarPageState();
}

class _SincronizarPageState extends State<SincronizarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool sincCompleta = false;
  bool sincronizando = false;
  int progressCount = 0;
  int totalRegistros = 0;
  bool primeiraSincronia = false;
  bool baixandoRegistros = false;
  final params = ParametrosController();

  String progressoText = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
    );

    setUpState();
  }

  void setUpState() async {
    await params.getParametros();

    if (params.parametros!.ultsincroniaAsDateTime == DateTime(2000, 1, 1)) {
      setState(() {
        primeiraSincronia = true;
        sincCompleta = true;
      });
    }
  }

  void sincronizar() async {
    if (params.parametros == null) {
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Não foi possível buscar os parametros.', context);
      setState(() {
        progressoText = 'Não foi possível buscar os parametros.';
      });
      return;
    }

    if (!mounted) return;

    final sinc = SincroniaController();

    if (params.parametros == null) {
      Utils().customShowDialog('ERRO', 'Erro!',
          'Não foram encontrados parametros registrados.', context);
      return;
    }

    setState(() {
      progressoText = 'Baixando registros.';
      baixandoRegistros = true;
      sincronizando = true;
    });

    final resultDownload = await sinc.baixarRegistros(
      params.parametros!.parEndIPProd!,
      params.parametros!.parCusu!,
      params.parametros!.ultsincroniaAsDateTime!,
    );

    if (resultDownload != '') {
      Utils().customShowDialog('ERRO', 'Erro!', resultDownload, context);

      setState(() {
        progressoText = 'Erro';
        baixandoRegistros = false;
      });

      return;
    }

    totalRegistros = sinc.totalRegistros;

    setState(() {
      baixandoRegistros = false;
      progressCount = 0;
      progressoText = 'Sincronizando Clientes';
    });

    var result = await sinc.sincronizarTabela<Cliente>(
      dados: sinc.clientes,
      nomeTabela: 'CLIENTES',
      toMap: (cliente) => cliente.toMap(),
      getId: (cliente) => cliente.cliId,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Erro ao sincronizar Clientes: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Clientes: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Contatos';
    });

    result = await sinc.sincronizarTabela<ClienteContato>(
      dados: sinc.contatos,
      nomeTabela: 'CLIENTES_CONTATOS',
      toMap: (contato) => contato.toMap(),
      getId: (contato) => contato.clicId,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Erro ao sincronizar Contatos: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Conatos: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Endereços';
    });

    result = await sinc.sincronizarTabela<ClienteEndereco>(
      dados: sinc.enderecos,
      nomeTabela: 'CLIENTES_ENDERECOS',
      toMap: (end) => end.toMap(),
      getId: (end) => end.clieId,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Erro ao sincronizar Endereços: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Endereços: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Formas de Pagamento';
    });

    result = await sinc.sincronizarTabela<FormaPagamento>(
      dados: sinc.formasPag,
      nomeTabela: 'FORMAS_PAGAMENTO',
      toMap: (formapag) => formapag.toMap(),
      getId: (formapag) => formapag.fpId,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog('ERRO', 'Erro!',
          'Erro ao sincronizar Formas de Pagamento: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Formas de Pagamento: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Meios de Pagamento';
    });

    result = await sinc.sincronizarTabela<MeioPagamento>(
      dados: sinc.meiosPag,
      nomeTabela: 'MEIOS_PAGAMENTO',
      toMap: (meios) => meios.toMap(),
      getId: (meios) => meios.mpId,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog('ERRO', 'Erro!',
          'Erro ao sincronizar Meios de Pagamento: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Meios de Pagamento: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Tipos de Pagamento';
    });

    result = await sinc.sincronizarTabela<FormaMeio>(
      dados: sinc.formasMeio,
      nomeTabela: 'FORMAS_MEIO',
      toMap: (fm) => fm.toMap(),
      getId: (fm) => fm.fmForma,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog('ERRO', 'Erro!',
          'Erro ao sincronizar Tipos de Pagamento: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Tipos de Pagamento: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Impostos';
    });

    result = await sinc.sincronizarTabela<ProdutoSt>(
      dados: sinc.produtosST,
      nomeTabela: 'PRODUTOS_ST',
      toMap: (st) => st.toMap(),
      getId: (st) => st.pstProd,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Erro ao sincronizar Impostos: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Impostos: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Produtos';
    });

    result = await sinc.sincronizarTabela<Produto>(
      dados: sinc.produtos,
      nomeTabela: 'PRODUTOS',
      toMap: (prod) => prod.toMap(),
      getId: (prod) => prod.prodId,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Erro ao sincronizar Produtos: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Produtos: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Tabela de Preços';
    });

    result = await sinc.sincronizarTabela<TabelaPreco>(
      dados: sinc.tabelaPreco,
      nomeTabela: 'TABELA_PRECO',
      toMap: (tabPr) => tabPr.toMap(),
      getId: (tabPr) => tabPr.tbProd,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog('ERRO', 'Erro!',
          'Erro ao sincronizar Tabela de Preços: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Tabela de Preços: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Tabelas';
    });

    result = await sinc.sincronizarTabela<TabelaPrecoCabecalho>(
      dados: sinc.tabelaPrecoCabecalhos,
      nomeTabela: 'TABELA',
      toMap: (tab) => tab.toMap(),
      getId: (tab) => tab.tbpId,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Erro ao sincronizar Tabelas: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Tabelas: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Tipos de Entrega';
    });

    result = await sinc.sincronizarTabela<TipoEntrega>(
      dados: sinc.tiposEntrega,
      nomeTabela: 'TIPO_ENTREGA',
      toMap: (entrega) => entrega.toMap(),
      getId: (entrega) => entrega.tpId,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog('ERRO', 'Erro!',
          'Erro ao sincronizar Tipos de Entrega: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Tipos de Entrega: $result';
      });
      return;
    }

    setState(() {
      progressoText = 'Sincronizando Pedidos';
    });

    result = await sinc.sincronizarVendas(
      vendas: sinc.vendas,
      onSyncRecord: () => {setState(() => progressCount++)},
    );

    if (result != '') {
      Utils().customShowDialog(
          'ERRO', 'Erro!', 'Erro ao sincronizar Vendas: $result', context);
      setState(() {
        progressoText = 'Erro ao sincronizar Vendas: $result';
      });
      return;
    }

    setState(() {
      progressCount = totalRegistros;
      progressoText = 'Sincronização concluída';
    });

    params.parametros!.ultsincroniaAsDateTime = DateTime.now();
    params.salvarParametros(params.parametros!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sincronizar'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        'Atenção! Este é um processo demorado, aguarde até o final para sair.'),
                    const SizedBox(
                      height: 55,
                    ),
                    Text(
                      '${NumberFormat('###', 'pt-BR').format((totalRegistros == 0 ? 0 : progressCount / totalRegistros) * 100)}%',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: const Alignment(0, 0),
                      children: [
                        const Icon(
                          Icons.cloud_sync,
                          color: AppColors.lightHighlight,
                          size: 100,
                        ),
                        AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) => SizedBox(
                                  height: 220,
                                  width: 220,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    value: baixandoRegistros
                                        ? null
                                        : totalRegistros == 0
                                            ? 0
                                            : progressCount / totalRegistros,
                                  ),
                                )),
                      ],
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      progressoText,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                    ElevatedButton(
                      onPressed: sincronizando
                          ? null
                          : () {
                              sincronizar();
                            },
                      child: const Text('Sincronizar'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomCheckBox(
                      value: sincCompleta,
                      onChanged: (value) => setState(() {
                        sincCompleta = value!;
                      }),
                      onTap: () => setState(() {
                        sincCompleta = !sincCompleta;
                      }),
                      enabled: !(primeiraSincronia || sincronizando),
                      label: 'Sincronia Completa',
                    )
                    // GestureDetector(
                    //   onTap: primeiraSincronia || sincronizando
                    //       ? null
                    //       : () => {
                    //             setState(() {
                    //               sincCompleta = !sincCompleta;
                    //             })
                    //           },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Checkbox(
                    //         fillColor: WidgetStateProperty.resolveWith(
                    //           (states) {
                    //             if (!states.contains(WidgetState.selected)) {
                    //               return null;
                    //             } else {
                    //               return primeiraSincronia || sincronizando
                    //                   ? AppColors.darkDisabled
                    //                   : AppColors.primary;
                    //             }
                    //           },
                    //         ),
                    //         value: sincCompleta,
                    //         onChanged: primeiraSincronia || sincronizando
                    //             ? null
                    //             : (value) => {
                    //                   setState(() {
                    //                     sincCompleta = value!;
                    //                   })
                    //                 },
                    //       ),
                    //       Text(
                    //         style: TextStyle(
                    //             color: primeiraSincronia || sincronizando
                    //                 ? AppColors.lightDisabledText
                    //                 : AppColors.lightPrimaryText),
                    //         'Sincronia Completa',
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
