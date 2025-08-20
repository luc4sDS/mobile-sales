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
}
