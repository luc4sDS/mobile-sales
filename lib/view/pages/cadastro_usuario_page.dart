import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/view/widgets/alert_dialog.dart';

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({super.key});

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  bool _escondeSenha = true;
  bool _escondeRepetirSenha = true;

  bool isLoading = false;

  final cteUsuario = TextEditingController();
  final cteSenha = TextEditingController();
  final cteConfirmarSenha = TextEditingController();

  void cadastrarUsuario() async {
    setState(() {
      isLoading = true;
    });

    if (cteSenha.text != cteConfirmarSenha.text) {
      showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
            tipo: 'ERRO',
            titulo: const Flexible(child: Text('Erro!')),
            content: const Text('Senhas diferem.'),
            actions: [
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
      setState(() {
        isLoading = false;
      });
      return;
    }

    final parametrosCtrl = ParametrosController();
    final resultCadastro =
        await parametrosCtrl.cadastrarUsuario(cteUsuario.text, cteSenha.text);
    setState(() {
      isLoading = false;
    });

    if (!mounted) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (resultCadastro.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
            tipo: 'ERRO',
            titulo: const Flexible(child: Text('Erro!')),
            content: Text(resultCadastro),
            actions: [
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

      setState(() {
        isLoading = false;
      });

      return;
    }

    Navigator.popUntil(context, (route) => route.settings.name == '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: cteUsuario,
              decoration: const InputDecoration(
                label: Text('Usuário'),
                suffixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: cteSenha,
              obscureText: _escondeRepetirSenha,
              decoration: InputDecoration(
                label: const Text('Senha'),
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _escondeRepetirSenha = !_escondeRepetirSenha;
                      });
                    },
                    icon: Icon(_escondeRepetirSenha
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: cteConfirmarSenha,
              obscureText: _escondeSenha,
              decoration: InputDecoration(
                label: const Text('Confirmar Senha'),
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _escondeSenha = !_escondeSenha;
                      });
                    },
                    icon: Icon(_escondeSenha
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: isLoading ? null : cadastrarUsuario,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
