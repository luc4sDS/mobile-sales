import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/model/cliente_endereco.dart';
import 'package:mobile_sales/utils/consts.dart';
import 'package:mobile_sales/view/widgets/custom_text_field.dart';
import 'package:mobile_sales/view/widgets/list_search_modal.dart';

class EditarEnderecoModal extends StatefulWidget {
  final ClienteEndereco endereco;
  final void Function(ClienteEndereco) onSave;
  final void Function(int)? onDelete;

  const EditarEnderecoModal({
    super.key,
    required this.endereco,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<EditarEnderecoModal> createState() => _EditarEnderecoModalState();
}

class _EditarEnderecoModalState extends State<EditarEnderecoModal> {
  //Consts
  static const estados = Consts.estados;

  //Variaveis
  int selectedEstadoIndex = -1;

  //Controllers
  final _enderecoCte = TextEditingController();
  final _numeroCte = TextEditingController();
  final _bairroCte = TextEditingController();
  final _cepCte = TextEditingController();
  final _cidadeCte = TextEditingController();
  final _complCte = TextEditingController();
  final _descCte = TextEditingController();

  @override
  void initState() {
    super.initState();
    final endereco = widget.endereco;

    _enderecoCte.text = endereco.clieEndereco ?? '';
    _numeroCte.text = endereco.clieNumero ?? '';
    _bairroCte.text = endereco.clieBairro ?? '';
    _cepCte.text = endereco.clieCep ?? '';
    _cidadeCte.text = endereco.clieCidade ?? '';
    _complCte.text = endereco.clieCompl ?? '';
    _descCte.text = endereco.clieDescricao ?? '';

    selectedEstadoIndex = estados.indexOf(endereco.clieEstado ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      final novoEndereco = widget.endereco.copyWith(
                        clieAtivo: 'S',
                        clieEndereco: _enderecoCte.text.trim().toUpperCase(),
                        clieNumero: _numeroCte.text.trim().toUpperCase(),
                        clieBairro: _bairroCte.text.trim().toUpperCase(),
                        clieCep: _cepCte.text.trim().toUpperCase(),
                        clieCidade: _cidadeCte.text.trim().toUpperCase(),
                        clieCompl: _complCte.text.trim().toUpperCase(),
                        clieDescricao: _descCte.text.trim().toUpperCase(),
                        clieEstado: selectedEstadoIndex == -1
                            ? ''
                            : estados[selectedEstadoIndex],
                      );

                      widget.onSave(novoEndereco);
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    style: const ButtonStyle(
                        backgroundColor: WidgetStateColor.fromMap(
                            {WidgetState.any: AppColors.ok})),
                  ),
                  if (widget.onDelete != null)
                    IconButton(
                      onPressed: () =>
                          widget.onDelete!(widget.endereco.clieSeq),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                          (_) => AppColors.erro,
                        ),
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith(
                      (state) => AppColors.lightBackground),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        spacing: 10,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Descrição',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.lighSecondaryText,
                                ),
                              ),
                              CustomTextField(
                                controller: _descCte,
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Endereço',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lighSecondaryText,
                                      ),
                                    ),
                                    TextField(
                                      controller: _enderecoCte,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Número',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lighSecondaryText,
                                      ),
                                    ),
                                    TextField(
                                      controller: _numeroCte,
                                    ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Bairro',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lighSecondaryText,
                                      ),
                                    ),
                                    TextField(
                                      controller: _bairroCte,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'CEP',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lighSecondaryText,
                                      ),
                                    ),
                                    TextField(
                                      controller: _cepCte,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Cidade',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lighSecondaryText,
                                      ),
                                    ),
                                    TextField(
                                      controller: _cidadeCte,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Estado',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lighSecondaryText,
                                      ),
                                    ),
                                    ListSearchModal(
                                      enableSearch: false,
                                      data: estados,
                                      extractName: (e) => e,
                                      selectedIndex: selectedEstadoIndex,
                                      onSelect: (i) {
                                        setState(() {
                                          selectedEstadoIndex = i;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      label: 'Estado',
                                      enabled: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Complemento',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lighSecondaryText,
                                      ),
                                    ),
                                    TextField(
                                      controller: _complCte,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
