import 'package:flutter/material.dart';
import '../../controllers/library_controller.dart';
import 'widgets/genre_dropdown.dart';
import 'widgets/genre_actions.dart';
import 'widgets/book_list_tile.dart';
import 'widgets/dialogs.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = LibraryController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch all genres and books from the API on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initialize().then((_) => setState(() {}));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Snackbar
  // ---------------------------------------------------------------------------

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ---------------------------------------------------------------------------
  // Book actions
  // ---------------------------------------------------------------------------

  Future<void> _addBook() async {
    final name = await showTextDialog(
      context,
      title: 'Add Book',
      fieldLabel: 'Book name',
      confirmButtonText: 'Add',
    );
    if (name == null) return;

    _showSnackBar('Saving...');
    final error = await _controller.addBook(name);
    _showSnackBar(error ?? 'Book added.');
    if (error == null) setState(() {});
  }

  Future<void> _editBook(int index) async {
    final currentName = _controller.booksInSelectedGenre[index];
    final newName = await showTextDialog(
      context,
      title: 'Edit Book',
      fieldLabel: 'Book name',
      confirmButtonText: 'Save',
      initialText: currentName,
    );
    if (newName == null) return;

    _showSnackBar('Saving...');
    final error = await _controller.editBook(index, newName);
    _showSnackBar(error ?? 'Book updated.');
    if (error == null) setState(() {});
  }

  Future<void> _deleteBook(int index) async {
    final name = _controller.booksInSelectedGenre[index];
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Book',
      message: 'Are you sure you want to delete "$name"?',
      confirmButtonText: 'Delete',
    );
    if (!confirmed) return;

    _showSnackBar('Deleting...');
    final error = await _controller.deleteBook(index);
    _showSnackBar(error ?? 'Book "$name" deleted.');
    if (error == null) setState(() {});
  }

  // ---------------------------------------------------------------------------
  // Genre actions
  // ---------------------------------------------------------------------------

  Future<void> _addGenre() async {
    final name = await showTextDialog(
      context,
      title: 'Add Genre',
      fieldLabel: 'Genre name',
      confirmButtonText: 'Add',
    );
    if (name == null) return;

    _showSnackBar('Saving...');
    final error = await _controller.addGenre(name);
    _showSnackBar(error ?? 'Genre added.');
    if (error == null) setState(() {});
  }

  Future<void> _editGenre() async {
    final currentName = _controller.selectedGenre!;
    final newName = await showTextDialog(
      context,
      title: 'Edit Genre',
      fieldLabel: 'Genre name',
      confirmButtonText: 'Save',
      initialText: currentName,
    );
    if (newName == null) return;

    _showSnackBar('Saving...');
    final error = await _controller.editGenre(currentName, newName);
    _showSnackBar(error ?? 'Genre updated.');
    if (error == null) setState(() {});
  }

  Future<void> _deleteGenre() async {
    final name = _controller.selectedGenre!;
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Genre',
      message: 'Are you sure you want to delete "$name"?',
      confirmButtonText: 'Delete',
    );
    if (!confirmed) return;

    _showSnackBar('Deleting...');
    final error = await _controller.deleteGenre(name);
    _showSnackBar(error ?? 'Genre "$name" deleted.');
    if (error == null) setState(() {});
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Loading state — shown only on first fetch
    if (_controller.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Library',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Error state
    if (_controller.status == LibraryStatus.error) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Library',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _controller.errorMessage ?? 'Unknown error.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _controller
                    .initialize()
                    .then((_) => setState(() {})),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    // Success state
    final books = _controller.filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.selectedGenre == null
            ? () => _showSnackBar('Select a genre before adding a book.')
            : _addBook,
        tooltip: 'Add Book',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            GenreDropdown(
              genres: _controller.genres,
              selectedGenre: _controller.selectedGenre,
              onChanged: (selection) => setState(() {
                _controller.selectGenre(selection);
                _searchController.clear();
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              enabled: _controller.selectedGenre != null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                hintText: 'Search book',
              ),
              onChanged: (text) =>
                  setState(() => _controller.updateSearch(text)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: books.isEmpty
                  ? const Center(child: Text('No results.'))
                  : ListView.separated(
                      itemCount: books.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, filteredIndex) {
                        final book = books[filteredIndex];
                        final realIndex =
                            _controller.booksInSelectedGenre.indexOf(book);
                        return BookListTile(
                          book: book,
                          onTap: () => _showSnackBar('Selected: $book'),
                          onEdit: () => _editBook(realIndex),
                          onDelete: () => _deleteBook(realIndex),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            GenreActions(
              selectedGenre: _controller.selectedGenre,
              onAdd: _addGenre,
              onEdit: _editGenre,
              onDelete: _deleteGenre,
            ),
          ],
        ),
      ),
    );
  }
}
