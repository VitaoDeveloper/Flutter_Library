import 'package:flutter/material.dart';

/// Item de livro exibido na lista, com ações de editar e excluir.
class LivroListTile extends StatelessWidget {
  const LivroListTile({
    super.key,
    required this.livro,
    required this.onTap,
    required this.onEditar,
    required this.onExcluir,
  });

  final String livro;
  final VoidCallback onTap;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book),
      title: Text(livro),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEditar,
          ),
          IconButton(
            tooltip: 'Excluir',
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onExcluir,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
