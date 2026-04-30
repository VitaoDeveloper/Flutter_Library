import 'book.dart';

class Genre {
  final String name;
  final List<Book> books;

  Genre({
    required this.name, 
    this.books = const []
  });
}
