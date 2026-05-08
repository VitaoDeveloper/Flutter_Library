import 'package:flutter/material.dart';

/// Prompts the user for a text input via [AlertDialog].
///
/// Returns the typed text or [null] if cancelled.
Future<String?> showTextDialog(
  BuildContext context, {
  required String title,
  required String fieldLabel,
  required String confirmButtonText,
  String initialText = '',
}) async {
  final controller = TextEditingController(text: initialText);

  return showDialog<String?>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: fieldLabel,
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
          child: Text(confirmButtonText),
        ),
      ],
    ),
  );
}

/// Asks for user confirmation before a destructive action.
///
/// Returns [true] if confirmed, [false] otherwise.
Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmButtonText = 'Confirmar',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmButtonText),
        ),
      ],
    ),
  );
  return result ?? false;
}
