import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class CustomAlertDialog extends AlertDialog {
  final String tipo;
  final Widget titulo;

  const CustomAlertDialog(
      {super.key,
      this.tipo = 'INFO',
      required this.titulo,
      required Widget content,
      required List<Widget> actions})
      : super(actions: actions, content: content);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.lightBackground,
      titleTextStyle: const TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
          color: AppColors.lightPrimaryText),
      contentTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.lighSecondaryText,
      ),
      title: Row(children: [
        Container(
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
                        : tipo == 'CONFIRMAR'
                            ? Icons.question_mark
                            : Icons.info,
            size: 30,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 20),
        titulo
      ]),
      content: tipo == 'OK'
          ? null
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: SingleChildScrollView(child: super.content)),
      actions: super.actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
