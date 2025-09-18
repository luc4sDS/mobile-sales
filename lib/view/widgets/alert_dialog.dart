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
      actionsAlignment: MainAxisAlignment.spaceAround,
      backgroundColor: AppColors.lightBackground,
      titleTextStyle: const TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
          color: AppColors.lightPrimaryText),
      contentTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.lighSecondaryText,
      ),
      title: Column(children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: tipo == 'ERRO'
                ? AppColors.lightCanceladoBg
                : tipo == 'ALERTA'
                    ? AppColors.lightAlertaBg
                    : tipo == 'OK'
                        ? AppColors.lightEnviadoBg
                        : AppColors.lightAbertoBg,
          ),
          child: Icon(
            tipo == 'ERRO'
                ? Icons.cancel_outlined
                : tipo == 'ALERTA'
                    ? Icons.warning_outlined
                    : tipo == 'OK'
                        ? Icons.check_outlined
                        : tipo == 'CONFIRMAR'
                            ? Icons.question_mark
                            : Icons.info_outline,
            size: 30,
            color: tipo == 'ERRO'
                ? AppColors.lightCanceladoText
                : tipo == 'ALERTA'
                    ? AppColors.lightAlertaText
                    : tipo == 'OK'
                        ? AppColors.lightEnviadoText
                        : AppColors.lightAbertoText,
          ),
        ),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [titulo])
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
