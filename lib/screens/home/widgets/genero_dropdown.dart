import 'package:flutter/material.dart';

/// Dropdown para seleção de gênero literário.
class GeneroDropdown extends StatelessWidget {
  const GeneroDropdown({
    super.key,
    required this.generos,
    required this.generoSelecionado,
    required this.onChanged,
  });

  final Map<String, List<String>> generos;
  final String? generoSelecionado;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: const Row(
        children: [
          Icon(Icons.bookmark),
          SizedBox(width: 8),
          Text('Selecione um gênero'),
        ],
      ),
      initialValue: generoSelecionado,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      icon: const Icon(Icons.arrow_drop_down),
      items: generos.keys.map((genero) {
        return DropdownMenuItem<String>(
          value: genero,
          child: Row(
            children: [
              const Icon(Icons.bookmark),
              const SizedBox(width: 8),
              Text(genero),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
