import 'package:biblioteca/models/genre.dart';
import 'package:biblioteca/services/library_service.dart';
import 'package:flutter/material.dart';

/// Gerencia o estado e a lógica de negócio da biblioteca.
///
/// Separa completamente as regras de manipulação de livros e gêneros
/// da camada de apresentação (widgets).
class LibraryController extends ChangeNotifier {
  
  final LibraryService _service = LibraryService();

  String? error;
  bool loading = false;

  List<Genre> genresList = [];
  Map<String, List<String>> genresMap = {};

  Map<String, List<String>> convertListToMap(List<Genre> genres) {
    return {
      for (var genre in genres)
        genre.name: (genre.books).map((book) => book.name).toList()
    };
  }

  Future<void> fetchLibrary() async {
    loading = true;
    notifyListeners();

    try {
      genresList = await _service.fetchLibraryData();
      genresMap = convertListToMap(genresList);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  String? generoSelecionado;
  String busca = '';

  // ---------------------------------------------------------------------------
  // Derived state
  // ---------------------------------------------------------------------------

  List<String> get livrosDoGeneroAtual =>
      genresMap[generoSelecionado] ?? const [];

  List<String> get livrosFiltrados {
    if (busca.isEmpty) return livrosDoGeneroAtual;
    return livrosDoGeneroAtual
        .where((l) => l.toLowerCase().contains(busca.toLowerCase()))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Seleção / busca
  // ---------------------------------------------------------------------------

  void selecionarGenero(String? genero) {
    generoSelecionado = genero;
    busca = '';
    notifyListeners();
  }

  void atualizarBusca(String texto) {
    busca = texto;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Livros
  // ---------------------------------------------------------------------------

  /// Retorna [null] em caso de sucesso ou uma mensagem de erro.
  String? adicionarLivro(String nome) {
    if (generoSelecionado == null) return 'Selecione um gênero primeiro.';
    final normalizado = _capitalizar(nome.trim());
    if (normalizado.isEmpty) return 'O nome não pode ser vazio.';
    if (_livroJaExiste(normalizado)) return 'Já existe um livro com esse nome.';

    genresMap[generoSelecionado!]!.add(normalizado);
    notifyListeners();
    return null;
  }

  /// Retorna [null] em caso de sucesso ou uma mensagem de erro.
  String? editarLivro(int indexReal, String novoNome) {
    final livros = livrosDoGeneroAtual;
    if (indexReal < 0 || indexReal >= livros.length) return 'Índice inválido.';

    final normalizado = _capitalizar(novoNome.trim());
    if (normalizado.isEmpty) return 'O nome não pode ser vazio.';

    final livroAtual = livros[indexReal];
    if (_livroJaExiste(normalizado) &&
        normalizado.toLowerCase() != livroAtual.toLowerCase()) {
      return 'Já existe um livro com esse nome.';
    }

    livros[indexReal] = normalizado;
    notifyListeners();
    return null;
  }

  void excluirLivro(int indexReal) {
    livrosDoGeneroAtual.removeAt(indexReal);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Gêneros
  // ---------------------------------------------------------------------------

  String? adicionarGenero(String nome) {
    final normalizado = _capitalizar(nome.trim());
    if (normalizado.isEmpty) return 'O nome não pode ser vazio.';
    if (genresMap.containsKey(normalizado)) return 'Já existe esse gênero.';

    genresMap[normalizado] = [];
    generoSelecionado = normalizado;
    notifyListeners();
    return null;
  }

  String? editarGenero(String generoAtual, String novoNome) {
    if (!genresMap.containsKey(generoAtual)) return 'Gênero não encontrado.';

    final normalizado = _capitalizar(novoNome.trim());
    if (normalizado.isEmpty) return 'O nome não pode ser vazio.';
    if (genresMap.containsKey(normalizado) &&
        normalizado.toLowerCase() != generoAtual.toLowerCase()) {
      return 'Já existe esse gênero.';
    }

    final livros = genresMap.remove(generoAtual)!;
    genresMap[normalizado] = livros;
    generoSelecionado = normalizado;
    notifyListeners();
    return null;
  }

  void excluirGenero(String genero) {
    genresMap.remove(genero);
    generoSelecionado = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Helpers privados
  // ---------------------------------------------------------------------------

  bool _livroJaExiste(String nome) =>
      livrosDoGeneroAtual.any((l) => l.toLowerCase() == nome.toLowerCase());

  String _capitalizar(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
