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
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add Genre'),
        ),
        if (selectedGenre != null) ...[
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Genre'),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            label: const Text('Delete Genre'),
          ),
        ],
      ],
    );
  }
}
