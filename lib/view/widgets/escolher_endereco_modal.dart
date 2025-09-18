import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/cliente_controller.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';
import 'package:mobile_sales/view/widgets/cliente_endereco_card.dart';
import 'package:mobile_sales/view/widgets/loading_error.dart';

class EscolherEnderecoModal extends StatefulWidget {
  final String cliCnpj;

  const EscolherEnderecoModal({
    super.key,
    required this.cliCnpj,
  });

  @override
  State<EscolherEnderecoModal> createState() => _EscolherEnderecoModalState();
}

class _EscolherEnderecoModalState extends State<EscolherEnderecoModal> {
  late Future<List<ClienteEndereco>> _futureEnderecos;
  final _cliCtr = ClienteController();

  @override
  void initState() {
    super.initState();

    _futureEnderecos = _cliCtr.getClienteEnderecos(widget.cliCnpj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
              ],
            ),
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
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text(
                      'Escolher endereço',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: _futureEnderecos,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return SingleChildScrollView(
                              child: LoadingError(
                                  title: 'Erro ao buscar endereços',
                                  error: '${snapshot.error}'),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('Não foi encontrado nenhum endereço'),
                            );
                          }

                          final enderecos = snapshot.data!;

                          return ListView.builder(
                            itemCount: enderecos.length,
                            itemBuilder: (context, index) {
                              final endereco = enderecos[index];

                              return ClienteEnderecoCard(
                                onTap: () {
                                  Navigator.of(context).pop(endereco);
                                },
                                endereco: endereco,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
