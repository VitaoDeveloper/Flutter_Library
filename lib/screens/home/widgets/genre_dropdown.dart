import 'package:flutter/material.dart';
import '../../../models/genre.dart';

/// Dropdown for selecting a literary genre.
class GenreDropdown extends StatelessWidget {
  const GenreDropdown({
    super.key,
    required this.genres,
    required this.selectedGenre,
    required this.onChanged,
  });

  final List<Genre> genres;
  final Genre? selectedGenre;
  final ValueChanged<Genre?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Genre>(
      hint: const Row(
        children: [
          Icon(Icons.bookmark),
          SizedBox(width: 8),
          Text('Select a genre'),
        ],
      ),
      initialValue: selectedGenre,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      icon: const Icon(Icons.arrow_drop_down),
      items: genres.map((genre) {
        return DropdownMenuItem<Genre>(
          value: genre,
          child: Row(
            children: [
              const Icon(Icons.bookmark),
              const SizedBox(width: 8),
              Text(genre.name),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}