import 'package:flutter/material.dart';

/// Action buttons for managing genres (add, edit, delete).
class GenreActions extends StatelessWidget {
  const GenreActions({
    super.key,
    required this.selectedGenre,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final String? selectedGenre;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar gênero'),
          ),
        ),
        if (selectedGenre != null) ...[
          const SizedBox(width: 8),
          FilledButton.tonalIcon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: const Text('Editar'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            label: const Text('Excluir'),
          ),
        ],
      ],
    );
  }
}
