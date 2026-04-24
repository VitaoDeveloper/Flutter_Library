import 'package:flutter/material.dart';

/// Coleta um texto do usuário via [AlertDialog].
///
/// Retorna o texto digitado ou [null] se cancelado.
Future<String?> mostrarDialogTexto(
  BuildContext context, {
  required String titulo,
  required String labelCampo,
  required String textoBotaoConfirmar,
  String textoInicial = '',
}) async {
  final controller = TextEditingController(text: textoInicial);

  return showDialog<String?>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: labelCampo,
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => Navigator.of(ctx).pop(controller.text.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(null),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
          child: Text(textoBotaoConfirmar),
        ),
      ],
    ),
  );
}

/// Pede confirmação do usuário antes de uma ação destrutiva.
///
/// Retorna [true] se o usuário confirmou, [false] caso contrário.
Future<bool> mostrarDialogConfirmacao(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  String textoBotaoConfirmar = 'Confirmar',
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(textoBotaoConfirmar),
        ),
      ],
    ),
  );
  return resultado ?? false;
}
