import 'package:flutter/foundation.dart';
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
  String? selectedGenre;
  String searchQuery = '';

  /// Source of truth: { genreName: [bookName, ...] }
  final Map<String, List<String>> genres = {};

  LibraryStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LibraryStatus.loading;

  // ---------------------------------------------------------------------------
  // Derived state
  // ---------------------------------------------------------------------------

  List<String> get booksInSelectedGenre => genres[selectedGenre] ?? const [];

  List<String> get filteredBooks {
    if (searchQuery.isEmpty) return booksInSelectedGenre;
    return booksInSelectedGenre
        .where((b) => b.toLowerCase().contains(searchQuery.toLowerCase()))
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

  void selectGenre(String? genre) {
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
    if (selectedGenre == null) return 'Select a genre before adding a book.';
    final normalized = _capitalize(name.trim());
    if (normalized.isEmpty) return 'The name cannot be empty.';
    if (_bookExists(normalized)) return 'A book with that name already exists.';

    final result = await _service.create(
      table: 'books',
      body: {'name': normalized, 'genre': selectedGenre},
    );

    if (!result.isSuccess) return result.error;

    genres[selectedGenre!]!.add(normalized);
    notifyListeners();
    return null;
  }

  /// Returns [null] on success or an error message.
  Future<String?> editBook(int index, String newName) async {
    final books = booksInSelectedGenre;
    if (index < 0 || index >= books.length) return 'The selected book is invalid.';

    final normalized = _capitalize(newName.trim());
    if (normalized.isEmpty) return 'The name cannot be empty.';

    final currentName = books[index];
    if (_bookExists(normalized) &&
        normalized.toLowerCase() != currentName.toLowerCase()) {
      return 'A book with that name already exists.';
    }

    final result = await _service.edit(
      table: 'books',
      currentName: currentName,
      body: {'update': normalized},
    );

    if (!result.isSuccess) return result.error;

    books[index] = normalized;
    notifyListeners();
    return null;
  }

  Future<String?> deleteBook(int index) async {
    final books = booksInSelectedGenre;
    final name = books[index];

    final result = await _service.delete(table: 'books', name: name);
    if (!result.isSuccess) return result.error;

    books.removeAt(index);
    notifyListeners();
    return null;
  }

  // ---------------------------------------------------------------------------
  // Genres
  // ---------------------------------------------------------------------------

  Future<String?> addGenre(String name) async {
    final normalized = _capitalize(name.trim());
    if (normalized.isEmpty) return 'The name cannot be empty.';
    if (genres.containsKey(normalized)) return 'A genre with that name already exists.';

    final result = await _service.create(
      table: 'genres',
      body: {'name': normalized},
    );

    if (!result.isSuccess) return result.error;

    genres[normalized] = [];
    selectedGenre = normalized;
    notifyListeners();
    return null;
  }

  Future<String?> editGenre(String currentName, String newName) async {
    if (!genres.containsKey(currentName)) return 'Genre not found.';

    final normalized = _capitalize(newName.trim());
    if (normalized.isEmpty) return 'The name cannot be empty.';
    if (genres.containsKey(normalized) &&
        normalized.toLowerCase() != currentName.toLowerCase()) {
      return 'A genre with that name already exists.';
    }

    final result = await _service.edit(
      table: 'genres',
      currentName: currentName,
      body: {'update': normalized},
    );

    if (!result.isSuccess) return result.error;

    final books = genres.remove(currentName)!;
    genres[normalized] = books;
    selectedGenre = normalized;
    notifyListeners();
    return null;
  }

  Future<String?> deleteGenre(String name) async {
    final result = await _service.delete(table: 'genres', name: name);
    if (!result.isSuccess) return result.error;

    genres.remove(name);
    selectedGenre = null;
    notifyListeners();
    return null;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  bool _bookExists(String name) => booksInSelectedGenre
      .any((b) => b.toLowerCase() == name.toLowerCase());

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
