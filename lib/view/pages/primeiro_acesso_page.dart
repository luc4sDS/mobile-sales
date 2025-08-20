import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/utils/utils.dart';

class PrimeiroAcessoPage extends StatefulWidget {
  const PrimeiroAcessoPage({super.key});

  @override
  State<PrimeiroAcessoPage> createState() => _PrimeiroAcessoPageState();
}

class _PrimeiroAcessoPageState extends State<PrimeiroAcessoPage> {
  final GlobalKey<_PrimeiroAcessoPageState> myWidgetKey = GlobalKey();

  bool isLoading = false;

  final db = DatabaseService();

  final cteCNPJ = TextEditingController();
  final cteChave = TextEditingController();

  void vincular() async {
    setState(() {
      isLoading = true;
    });

    ParametrosController parametrosCtrl = ParametrosController();

    final resultVincular =
        await parametrosCtrl.vincular(cteCNPJ.text, cteChave.text);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (resultVincular.isNotEmpty) {
      // Show error dialog if something went wrong
      Utils().customShowDialog('ERRO', 'Erro!', resultVincular, context);
      return; // Avoid navigating if there was an error
    }

    // Navigate only if there was no error
    Navigator.pushNamed(context, '/cadastro_usuario');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primeiro Acesso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: cteCNPJ,
                decoration: const InputDecoration(
                  label: Text('CNPJ da empresa'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: cteChave,
                decoration: const InputDecoration(
                  label: Text('Chave do vendedor'),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: isLoading ? null : vincular,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.2,
                        ),
                      )
                    : const Text('Vincular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
