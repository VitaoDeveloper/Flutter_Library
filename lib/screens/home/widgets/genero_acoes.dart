import 'package:flutter/material.dart';

/// Botões de ação para gerenciar gêneros (adicionar, editar, excluir).
class GeneroAcoes extends StatelessWidget {
  const GeneroAcoes({
    super.key,
    required this.generoSelecionado,
    required this.onAdicionar,
    required this.onEditar,
    required this.onExcluir,
  });

  final String? generoSelecionado;
  final VoidCallback onAdicionar;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onAdicionar,
          icon: const Icon(Icons.add),
          label: const Text('Adicionar Gênero'),
        ),
        if (generoSelecionado != null) ...[
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onEditar,
            icon: const Icon(Icons.edit),
            label: const Text('Editar Gênero'),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: onExcluir,
            icon: const Icon(Icons.delete),
            label: const Text('Excluir Gênero'),
          ),
        ],
      ],
    );
  }
}
