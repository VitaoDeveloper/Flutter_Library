import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../models/genre.dart';
import '../services/library_service.dart';

enum LibraryStatus { idle, loading, success, error }

/// Manages state and business logic for the library app.
///
/// On [initialize], fetches all genres and books from the API.
/// Every CRUD operation calls the API and updates local state on success.
class LibraryController extends ChangeNotifier {
  final LibraryService _service;

  LibraryController({LibraryService? service})
      : _service = service ?? LibraryService();

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  LibraryStatus _status = LibraryStatus.idle;
  String? _errorMessage;
  Genre? selectedGenre;
  String searchQuery = '';

  /// Source of truth: list of genres, each containing its books.
  final List<Genre> genres = [];

  LibraryStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LibraryStatus.loading;

  // ---------------------------------------------------------------------------
  // Derived state
  // ---------------------------------------------------------------------------

  List<Book> get booksInSelectedGenre => selectedGenre?.books ?? const [];

  List<Book> get filteredBooks {
    if (searchQuery.isEmpty) return booksInSelectedGenre;
    return booksInSelectedGenre
        .where((b) => b.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Call this in [initState] of the home screen.
  /// Fetches all genres and books from the API.
  Future<void> initialize() async {
    _setLoading();

    final result = await _service.getAll();

    if (result.isSuccess) {
      genres
        ..clear()
        ..addAll(result.data!);
      _setSuccess();
    } else {
      _setError(result.error!);
    }
  }

  // ---------------------------------------------------------------------------
  // Selection / search
  // ---------------------------------------------------------------------------

  void selectGenre(Genre? genre) {
    selectedGenre = genre;
    searchQuery = '';
    notifyListeners();
  }

  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Books
  // ---------------------------------------------------------------------------

  /// Returns [null] on success or an error message.
  Future<String?> addBook(String name) async {
    if (selectedGenre == null) {
      return 'Selecione um gênero antes de adicionar um livro.';
    }
    final normalized = _capitalize(name.trim());
    if (normalized.isEmpty) return 'O nome não pode ficar vazio.';
    if (_bookExists(normalized)) return 'Já existe um livro com esse nome.';

    final result = await _service.create(
      table: 'books',
      body: {'name': normalized, 'genre_id': selectedGenre!.id},
    );

    if (!result.isSuccess) return result.error;

    selectedGenre!.books.add(Book(
      id: result.data!['id'] as String,
      name: normalized,
    ));
    notifyListeners();
    return null;
  }

  /// Returns [null] on success or an error message.
  Future<String?> editBook(int index, String newName) async {
    final book = booksInSelectedGenre[index];
    final normalized = _capitalize(newName.trim());
    if (normalized.isEmpty) return 'O nome não pode ficar vazio.';
    if (_bookExists(normalized) &&
        normalized.toLowerCase() != book.name.toLowerCase()) {
      return 'Já existe um livro com esse nome.';
    }

    final result = await _service.edit(
      table: 'books',
      id: book.id,
      body: {'update': normalized},
    );

    if (!result.isSuccess) return result.error;

    selectedGenre!.books[index] = Book(id: book.id, name: normalized);
    notifyListeners();
    return null;
  }

  Future<String?> deleteBook(int index) async {
    final book = booksInSelectedGenre[index];

    final result = await _service.delete(table: 'books', id: book.id);
    if (!result.isSuccess) return result.error;

    selectedGenre!.books.removeAt(index);
    notifyListeners();
    return null;
  }

  // ---------------------------------------------------------------------------
  // Genres
  // ---------------------------------------------------------------------------

  Future<String?> addGenre(String name) async {
    final normalized = _capitalize(name.trim());
    if (normalized.isEmpty) return 'O nome não pode ficar vazio.';
    if (_genreExists(normalized)) return 'Esse gênero já existe.';

    final result = await _service.create(
      table: 'genres',
      body: {'name': normalized},
    );

    if (!result.isSuccess) return result.error;

    final newGenre = Genre(
      id: result.data!['id'] as String,
      name: normalized,
      books: [],
    );
    genres.add(newGenre);
    selectedGenre = newGenre;
    notifyListeners();
    return null;
  }

  Future<String?> editGenre(String newName) async {
    final normalized = _capitalize(newName.trim());
    if (normalized.isEmpty) return 'O nome não pode ficar vazio.';
    if (_genreExists(normalized) &&
        normalized.toLowerCase() != selectedGenre!.name.toLowerCase()) {
      return 'Esse gênero já existe.';
    }

    final result = await _service.edit(
      table: 'genres',
      id: selectedGenre!.id,
      body: {'update': normalized},
    );

    if (!result.isSuccess) return result.error;

    final index = genres.indexOf(selectedGenre!);
    final updated = Genre(
      id: selectedGenre!.id,
      name: normalized,
      books: selectedGenre!.books,
    );
    genres[index] = updated;
    selectedGenre = updated;
    notifyListeners();
    return null;
  }

  Future<String?> deleteGenre() async {
    final result = await _service.delete(
      table: 'genres',
      id: selectedGenre!.id,
    );
    if (!result.isSuccess) return result.error;

    genres.remove(selectedGenre!);
    selectedGenre = null;
    notifyListeners();
    return null;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  bool _bookExists(String name) => booksInSelectedGenre
      .any((b) => b.name.toLowerCase() == name.toLowerCase());

  bool _genreExists(String name) =>
      genres.any((g) => g.name.toLowerCase() == name.toLowerCase());

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  void _setLoading() {
    _status = LibraryStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = LibraryStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = LibraryStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}