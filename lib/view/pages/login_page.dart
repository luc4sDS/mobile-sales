import 'package:flutter/material.dart';
import 'package:mobile_sales/controller/parametros_controller.dart';
import 'package:mobile_sales/controller/tabela_controller.dart';
import 'package:mobile_sales/core/assets/app_images.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool manterConec = false;

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;

  final tecUsuario = TextEditingController();
  final tecSenha = TextEditingController();

  bool escondeSenha = true;

  final databaseService = DatabaseService();

  void login() async {
    setState(() {
      isLoading = true;
    });

    final parametrosCtrl = ParametrosController();

    final resultLogin =
        await parametrosCtrl.login(tecUsuario.text, tecSenha.text);

    if (!mounted) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (resultLogin.isNotEmpty) {
      Utils().customShowDialog('ERRO', 'Erro!', resultLogin, context);

      setState(() {
        isLoading = false;
      });

      return;
    }

    var dataSinc = parametrosCtrl.parametros!.ultsincroniaAsDateTime!
        .add(Duration(hours: parametrosCtrl.parametros!.parSincronia!));

    if (dataSinc.isBefore(DateTime.now()) && await Utils.internet()) {
      if (mounted) Navigator.pushNamed(context, '/sincronizar');
    } else {
      if (mounted) Navigator.pushNamed(context, '/main');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: double.infinity,
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logo),
                  const SizedBox(
                    height: 70,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: tecUsuario,
                          decoration: const InputDecoration(
                            label: Text('Usuário'),
                            suffixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: tecSenha,
                          obscureText: escondeSenha,
                          decoration: InputDecoration(
                            label: const Text('Senha'),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    escondeSenha = !escondeSenha;
                                  });
                                },
                                icon: Icon(
                                  escondeSenha
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onLongPress: () async {
                          final db = DatabaseService();

                          await db.deleteAllAppData();
                        },
                        onPressed: isLoading ? null : login,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.2,
                                ),
                              )
                            : const Text('Entrar'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/primeiro_acesso');
                        },
                        child: const Text('Primeiro acesso'),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
