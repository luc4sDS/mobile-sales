import 'package:flutter/material.dart';

class LoadingError extends StatelessWidget {
  final String title;
  final String error;
  final Function()? retry;

  const LoadingError({
    super.key,
    required this.title,
    required this.error,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Erro: $error'),
            ),
            retry != null
                ? ElevatedButton(
                    onPressed: () => retry!(),
                    child: const Text('Tentar novamente'),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
