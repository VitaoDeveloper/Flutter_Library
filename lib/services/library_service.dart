import '../api/api_client.dart';
import '../models/book.dart';
import '../models/genre.dart';

class LibraryService {
  Future<List<Genre>> fetchLibraryData() async {
    final response = await ApiClient.client.get('/getall');

    final Map<String, dynamic> raw = response.data;

    return raw.entries.map((entry) {
      final livros = (entry.value as List)
          .map((e) => Book.fromJson(e))
          .toList();

      return Genre(
        name: entry.key,
        books: livros,
      );
    }).toList();
  }
}