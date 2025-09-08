import 'package:br_validators/br_validators.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/cliente_controller.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/cliente.dart';
import 'package:mobile_sales/model/cliente_contato.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';
import 'package:mobile_sales/utils/utils.dart';
import 'package:mobile_sales/view/widgets/cliente_contato_card.dart';
import 'package:mobile_sales/view/widgets/cliente_endereco_card.dart';
import 'package:mobile_sales/view/widgets/list_search_modal.dart';

class ClienteInfoPage extends StatefulWidget {
  final Cliente cliente;

  const ClienteInfoPage({
    super.key,
    required this.cliente,
  });

  @override
  State<ClienteInfoPage> createState() => _ClienteInfoPageState();
}

class _ClienteInfoPageState extends State<ClienteInfoPage> {
  //Constantes
  static const List<String> estados = [
    'AC', // Acre
    'AL', // Alagoas
    'AP', // Amapá
    'AM', // Amazonas
    'BA', // Bahia
    'CE', // Ceará
    'DF', // Distrito Federal
    'ES', // Espírito Santo
    'GO', // Goiás
    'MA', // Maranhão
    'MT', // Mato Grosso
    'MS', // Mato Grosso do Sul
    'MG', // Minas Gerais
    'PA', // Pará
    'PB', // Paraíba
    'PR', // Paraná
    'PE', // Pernambuco
    'PI', // Piauí
    'RJ', // Rio de Janeiro
    'RN', // Rio Grande do Norte
    'RS', // Rio Grande do Sul
    'RO', // Rondônia
    'RR', // Roraima
    'SC', // Santa Catarina
    'SP', // São Paulo
    'SE', // Sergipe
    'TO', // Tocantins
  ];

  //Variaveis
  late Cliente cliente;
  int selectedEstado = -1;
  bool saving = false;
  bool clienteNovo = false;

  //Controllers
  final _cliController = ClienteController();

  //TextEditingControllers
  final _cnpjCte = TextEditingController();
  final _razaoCte = TextEditingController();
  final _fantasiaCte = TextEditingController();
  final _inscCte = TextEditingController();
  final _enderecoCte = TextEditingController();
  final _numeroCte = TextEditingController();
  final _cidadeCte = TextEditingController();
  final _complCte = TextEditingController();
  final _cepCte = TextEditingController();
  final _bairroCte = TextEditingController();
  final _emailCte = TextEditingController();
  final _telefoneCte = TextEditingController();

  late Future<List<ClienteContato>> _futureContatos;
  late Future<List<ClienteEndereco>> _futureEnderecos;

  Future<List<String>> validaCliente() async {
    final List<String> erros = [];

    if (cliente.cliId == 0) {
      if (_cnpjCte.text.trim().isEmpty ||
          (!BRValidators.validateCNPJ(_cnpjCte.text) &&
              !BRValidators.validateCPF(_cnpjCte.text))) {
        erros.add('CPF/CNPJ inválido;');
      }
    }

    if (_razaoCte.text.trim().isEmpty) {
      erros.add('O campo "Razão" é obrigatório;');
    }

    if (_telefoneCte.text.trim().isEmpty) {
      erros.add('Contato inválido;');
    }

    if (_cidadeCte.text.trim().isEmpty || selectedEstado == -1) {
      erros.add('Campos "Cidade" e "Estado" são obrigatórios;');
    }

    return erros;
  }

  void consultarCnpj() async {
    final result = await _cliController.consultaCnpj(cliente.cliCnpj);

    _razaoCte.text = result.nome ?? '';
    _fantasiaCte.text = result.fantasia ?? '';
    _telefoneCte.text = result.telefone ?? '';
    _emailCte.text = result.email ?? '';
    _enderecoCte.text = result.logradouro ?? '';
    _numeroCte.text = result.numero ?? '';
    _bairroCte.text = result.bairro ?? '';
    _cepCte.text = result.cep ?? '';
    _cidadeCte.text = result.municipio ?? '';
    _complCte.text = result.complemento ?? '';

    for (var i = 0; i < estados.length; i++) {
      if (estados[i] == (result.uf ?? '')) {
        selectedEstado = i;
        break;
      }
    }
  }

  void handleSave() async {
    setState(() {
      saving = true;
    });

    final erros = await validaCliente();

    if (erros.isNotEmpty) {
      if (mounted) {
        Utils().customShowDialog('ERRO', 'Erro!', erros.join('\n\n'), context);
      }

      setState(() {
        saving = false;
      });

      return;
    }

    final novoCliente = Cliente(
      cliId: clienteNovo ? 0 : cliente.cliId,
      cliCnpj: Utils().removeSpecialChars(_cnpjCte.text.trim()).toUpperCase(),
      cliRazao: Utils().removeSpecialChars(_razaoCte.text.trim()).toUpperCase(),
      cliFantasia: _fantasiaCte.text.trim().isNotEmpty
          ? Utils().removeSpecialChars(_fantasiaCte.text.trim()).toUpperCase()
          : Utils().removeSpecialChars(_razaoCte.text.trim()).toUpperCase(),
      cliInsc: _inscCte.text.trim().toUpperCase(),
      cliEndereco: _enderecoCte.text.trim().toUpperCase(),
      cliNumero: _numeroCte.text.trim().toUpperCase(),
      cliCidade:
          Utils().removeSpecialChars(_cidadeCte.text.trim()).toUpperCase(),
      cliEstado: estados[selectedEstado],
      cliCompl: _complCte.text.trim().toUpperCase(),
      cliCep: _cepCte.text.trim().toUpperCase(),
      cliBairro: _bairroCte.text.trim().toUpperCase(),
      cliEmail: _emailCte.text.trim(),
      cliTelefone: _telefoneCte.text.trim(),
      cliEnvia: 'N',
      cliTabela: 0,
    );

    try {
      if (clienteNovo) {
        final novoClienteId = await _cliController.insertCliente(novoCliente);

        if (novoClienteId > 0) {
          setState(() {
            cliente = novoCliente.copyWith(cliId: novoClienteId);
          });

          if (mounted) {
            Utils().customShowDialog(
                'OK', 'Cliente cadastrado com sucesso!', '', context);
          }
        } else {
          if (mounted) {
            Utils().customShowDialog('ERRO', 'Erro!',
                'Não foi possível cadastrar o cliente.', context);
          }
        }

        setState(() {
          clienteNovo = false;
        });
      } else {
        final res = await _cliController.updateCliente(novoCliente);

        if (res == 1) {
          if (mounted) {
            Utils().customShowDialog(
                'OK', 'Cliente salvo com sucesso!', '', context);
          }
        }
      }

      setState(() {
        saving = false;
      });
    } catch (e) {
      if (mounted) {
        Utils().customShowDialog('ERRO', 'Erro!',
            'Não foi possível salvar as alterações: $e', context);
      }

      setState(() {
        saving = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    cliente = widget.cliente;

    clienteNovo = cliente.cliCnpj.isEmpty;

    _futureContatos = _cliController.getClienteContatos(cliente.cliCnpj);
    _futureEnderecos = _cliController.getClienteEnderecos(cliente.cliCnpj);

    _cnpjCte.text = cliente.cliCnpj;
    _razaoCte.text = cliente.cliRazao ?? '';
    _fantasiaCte.text = cliente.cliFantasia ?? '';
    _inscCte.text = cliente.cliInsc ?? '';
    _telefoneCte.text = cliente.cliTelefone ?? '';
    _emailCte.text = cliente.cliEmail ?? '';
    _enderecoCte.text = cliente.cliEndereco ?? '';
    _numeroCte.text = cliente.cliNumero ?? '';
    _bairroCte.text = cliente.cliBairro ?? '';
    _cepCte.text = cliente.cliCep ?? '';
    _cidadeCte.text = cliente.cliCidade ?? '';
    _complCte.text = cliente.cliCompl ?? '';

    for (var i = 0; i < estados.length; i++) {
      if (cliente.cliEstado == estados[i]) {
        selectedEstado = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: ElevatedButton(
                onPressed: saving ? null : handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                  minimumSize: const Size(10, 10),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'poppins',
                  ),
                ),
                child: saving
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ))
                    : const Text('Salvar'),
              ),
            ),
          ],
          centerTitle: false,
          title: Text('${clienteNovo ? 'Novo cliente' : cliente.cliId}'),
        ),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: const TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.lighSecondaryText,
              tabs: [
                Tab(text: 'Cliente'),
                Tab(text: 'Endereços'),
                Tab(text: 'Contatos')
              ],
            ),
            body: TabBarView(children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 10,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.lighSecondaryText
                                .withValues(alpha: 0.4),
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Informações',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'CPF/CNPJ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.lighSecondaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          // decoration:
                                          //     const InputDecoration(label: Text('CPF/CNPJ')),
                                          controller: _cnpjCte,
                                          readOnly: !clienteNovo,
                                          style: const TextStyle(
                                              color:
                                                  AppColors.lightPrimaryText),
                                        ),
                                      ),
                                      IconButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.resolveWith(
                                                  (_) => AppColors.primary),
                                        ),
                                        onPressed: consultarCnpj,
                                        icon: const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Razão',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.lighSecondaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextField(
                                    // decoration: const InputDecoration(label: Text('Razão')),
                                    controller: _razaoCte,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Fantasia',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.lighSecondaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextField(
                                    // decoration:
                                    //     const InputDecoration(label: Text('Fantasia')),
                                    controller: _fantasiaCte,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Inscrição estadual',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.lighSecondaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextField(
                                    // decoration: const InputDecoration(
                                    //     label: Text('Inscrição estadual')),
                                    controller: _inscCte,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.lighSecondaryText
                                .withValues(alpha: 0.4),
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Contato',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Telefone',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextField(
                                          controller: _telefoneCte,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Email',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextField(
                                          controller: _emailCte,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.lighSecondaryText
                                .withValues(alpha: 0.4),
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              const Text(
                                'Endereço',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Endereço',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextField(
                                          controller: _enderecoCte,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Número',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextField(
                                          controller: _numeroCte,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Bairro',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextField(
                                          controller: _bairroCte,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'CEP',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextField(
                                          controller: _cepCte,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Cidade',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextField(
                                          controller: _cidadeCte,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Estado',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.lighSecondaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        ListSearchModal(
                                          enableSearch: false,
                                          data: estados,
                                          extractName: (e) => e,
                                          selectedIndex: selectedEstado,
                                          onSelect: (i) {
                                            setState(() {
                                              selectedEstado = i;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          label: 'Estado',
                                          enabled: true,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Complemento',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.lighSecondaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextField(
                                    controller: _complCte,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                            minimumSize: const Size(10, 10),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'poppins',
                            ),
                          ),
                          child: const Text('Adicionar'),
                        ),
                      ],
                    ),
                    FutureBuilder(
                        future: _futureEnderecos,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Erro ao carregar endereços: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text(
                                    'Nenhum endereço cadastrado para este cliente'));
                          }

                          final enderecos = snapshot.data!;

                          return ListView.builder(
                              itemCount: enderecos.length,
                              itemBuilder: (context, i) {
                                return ClienteEnderecoCard(
                                    endereco: enderecos[i]);
                              });
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                            minimumSize: const Size(10, 10),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'poppins',
                            ),
                          ),
                          child: const Text('Adicionar'),
                        ),
                      ],
                    ),
                    FutureBuilder(
                        future: _futureContatos,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Erro ao carregar contatos: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text(
                                    'Nenhum contato cadastrado para este cliente'));
                          }

                          final contatos = snapshot.data!;

                          return ListView.builder(
                              itemCount: contatos.length,
                              itemBuilder: (context, i) {
                                return ClienteContatoCard(contato: contatos[i]);
                              });
                        }),
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
