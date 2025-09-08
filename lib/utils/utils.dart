import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sales/view/widgets/alert_dialog.dart';

class Utils {
  static Future<bool> internet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  void customShowDialog(String tipo, titulo, content, BuildContext context,
      {List<Widget>? actions}) {
    showDialog(
      context: context,
      builder: (_) {
        return CustomAlertDialog(
          tipo: tipo,
          titulo: Flexible(child: Text(titulo)),
          content: Text(content),
          actions: actions ??
              [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
        );
      },
    );
  }

  String removeSpecialChars(String texto) {
    if (texto.isEmpty) return texto;

    var comAcentos =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var semAcentos =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < comAcentos.length; i++) {
      texto = texto.replaceAll(comAcentos[i], semAcentos[i]);
    }

    texto = texto.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');

    return texto;
  }

  double calculaST(
    double valor,
    double aliqintra,
    double aliqinter,
    double mva,
    String estado,
  ) {
    if (estado.trim() == '') estado = 'SP';

    if (estado != 'SP') {
      final baseST = valor * (1 + (mva / 100));
      final icmsIntra = valor * (aliqintra / 100);
      final icmsInter = baseST * (aliqinter / 100);
      final valorST = icmsInter - icmsIntra;
      return valorST;
    } else {
      return 0;
    }
  }

  Map<String, dynamic> normalizeKeys(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key.toUpperCase(), value));
  }

  DateTime parseDateFlexivel(String dateString) {
    try {
      // Tenta primeiro o formato ISO (padrão do SQLite)
      return DateTime.parse(dateString);
    } catch (e) {
      // Se falhar, tenta o formato 'dd-MM-yy hh:mm:ss'
      final formatoCustomizado = DateFormat('dd-MM-yy HH:mm:ss');
      return formatoCustomizado.parse(dateString);
    }
  }

  String getVendaChave(int vendedor, int venda, String cnpj) {
    return NumberFormat('00000').format(vendedor) +
        DateFormat('ddMMyyyyhhmmss').format(DateTime.now()) +
        NumberFormat('000000000').format(venda) +
        cnpj;
  }
}
