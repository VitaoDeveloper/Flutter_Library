import 'book.dart';

class Genre {
  final String id;
  final String name;
  final List<Book> books;

  const Genre({required this.id, required this.name, required this.books});

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    id: json['id'] as String,
    name: json['genre'] as String,
    books: (json['books'] as List)
        .map((b) => Book.fromJson(b as Map<String, dynamic>))
        .toList(),
  );
}