import 'package:flutter/material.dart';
import '../../utils/widgets/app_loading.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _reloadData());
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Library'),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Reload',
          onPressed: _reloadData,
        ),
      ],
    );
  }

  Future<void> _reloadData() async {
    final reloadFuture = _controller.initialize();
    setState(() {});
    await reloadFuture;
    if (mounted) setState(() {});
  }

  // ---------------------------------------------------------------------------
  // Book actions
  // ---------------------------------------------------------------------------

  Future<void> _addBook() async {
    final name = await showTextDialog(
      context,
      title: 'Add book',
      fieldLabel: 'Book name',
      confirmButtonText: 'Add',
    );
    if (name == null) return;

    _showSnackBar('Salvando...');
    final error = await _controller.addBook(name);
    _showSnackBar(error ?? 'Livro adicionado.');
    if (error == null) setState(() {});
  }

  Future<void> _editBook(int index) async {
    final currentName = _controller.booksInSelectedGenre[index].name;
    final newName = await showTextDialog(
      context,
      title: 'Edit book',
      fieldLabel: 'Book name',
      confirmButtonText: 'Save',
      initialText: currentName,
    );
    if (newName == null) return;

    _showSnackBar('Salvando...');
    final error = await _controller.editBook(index, newName);
    _showSnackBar(error ?? 'Livro atualizado.');
    if (error == null) setState(() {});
  }

  Future<void> _deleteBook(int index) async {
    final name = _controller.booksInSelectedGenre[index].name;
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete book',
      message: 'Are you sure you want to delete "$name"?',
      confirmButtonText: 'Delete',
    );
    if (!confirmed) return;

    _showSnackBar('Excluindo...');
    final error = await _controller.deleteBook(index);
    _showSnackBar(error ?? 'Livro "$name" excluído.');
    if (error == null) setState(() {});
  }

  // ---------------------------------------------------------------------------
  // Genre actions
  // ---------------------------------------------------------------------------

  Future<void> _addGenre() async {
    final name = await showTextDialog(
      context,
      title: 'Add genre',
      fieldLabel: 'Genre name',
      confirmButtonText: 'Add',
    );
    if (name == null) return;

    _showSnackBar('Salvando...');
    final error = await _controller.addGenre(name);
    _showSnackBar(error ?? 'Gênero adicionado.');
    if (error == null) setState(() {});
  }

  Future<void> _editGenre() async {
    final currentName = _controller.selectedGenre!.name;
    final newName = await showTextDialog(
      context,
      title: 'Edit genre',
      fieldLabel: 'Genre name',
      confirmButtonText: 'Save',
      initialText: currentName,
    );
    if (newName == null) return;

    _showSnackBar('Salvando...');
    final error = await _controller.editGenre(newName);
    _showSnackBar(error ?? 'Gênero atualizado.');
    if (error == null) setState(() {});
  }

  Future<void> _deleteGenre() async {
    final name = _controller.selectedGenre!.name;
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete genre',
      message: 'Are you sure you want to delete "$name"?',
      confirmButtonText: 'Delete',
    );
    if (!confirmed) return;

    _showSnackBar('Excluindo...');
    final error = await _controller.deleteGenre();
    _showSnackBar(error ?? 'Gênero "$name" excluído.');
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
        appBar: _buildAppBar(),
        body: AppLoading(label: "Loading...")
      );
    }

    // Error state
    if (_controller.status == LibraryStatus.error) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _controller.errorMessage ?? 'Unable to load the data.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _reloadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // Success state
    final books = _controller.filteredBooks;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: GenreDropdown(
                        genres: _controller.genres,
                        selectedGenre: _controller.selectedGenre,
                        onChanged: (selection) => setState(() {
                          _controller.selectGenre(selection);
                          _searchController.clear();
                        }),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: 'Add book',
                      child: FloatingActionButton.small(
                        heroTag: 'add_book_inline',
                        onPressed: _controller.selectedGenre == null
                            ? () => _showSnackBar(
                                'Select a genre before adding a book.',
                              )
                            : _addBook,
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  enabled: _controller.selectedGenre != null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search book',
                  ),
                  onChanged: (text) =>
                      setState(() => _controller.updateSearch(text)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: books.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.separated(
                      itemCount: books.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, filteredIndex) {
                        final book = books[filteredIndex];
                        final realIndex = _controller.booksInSelectedGenre
                            .indexWhere((b) => b.id == book.id);
                        return BookListTile(
                          book: book,
                          onTap: () => _showSnackBar('Selecionado: ${book.name}'),
                          onEdit: () => _editBook(realIndex),
                          onDelete: () => _deleteBook(realIndex),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            GenreActions(
              selectedGenre: _controller.selectedGenre?.name,
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