import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class CustomAlertDialog extends AlertDialog {
  final String tipo;
  final Widget titulo;

  CustomAlertDialog(
      {super.key,
      this.tipo = 'INFO',
      required this.titulo,
      required Widget content,
      required List<Widget> actions})
      : super(actions: actions, content: content);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkSecondaryBackground,
      titleTextStyle: TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
          color: AppColors.darkPrimaryText),
      contentTextStyle: TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.darkSecondaryText,
      ),
      title: Row(children: [
        tipo == 'CONFIRMAR'
            ? const SizedBox(width: 0)
            : Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: tipo == 'ERRO'
                      ? AppColors.erro
                      : tipo == 'ALERTA'
                          ? AppColors.alert
                          : tipo == 'OK'
                              ? AppColors.ok
                              : AppColors.info,
                ),
                child: Icon(
                  tipo == 'ERRO'
                      ? Icons.cancel
                      : tipo == 'ALERTA'
                          ? Icons.warning
                          : tipo == 'OK'
                              ? Icons.check
                              : Icons.info,
                  size: 30,
                  color: Colors.white,
                ),
              ),
        SizedBox(width: 20),
        titulo
      ]),
      content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250),
          child: SingleChildScrollView(child: super.content)),
      actions: super.actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
