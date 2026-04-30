import 'package:biblioteca/models/genre.dart';
import 'package:biblioteca/services/library_service.dart';
import 'package:flutter/material.dart';

/// Gerencia o estado e a lógica de negócio da biblioteca.
///
/// Separa completamente as regras de manipulação de livros e gêneros
/// da camada de apresentação (widgets).
class LibraryController extends ChangeNotifier {
  final LibraryService _service;
  LibraryController(this._service);

  String? error;
  bool loading = false;
  List<Genre> genres = [];


  Future<void> fetchLibrary() async {
    loading = true;
    notifyListeners();

    try {
      genres = await _service.fetchLibraryData();
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  String? generoSelecionado;
  String busca = '';

  final Map<String, List<String>> generos = {};

  // ---------------------------------------------------------------------------
  // Derived state
  // ---------------------------------------------------------------------------

  List<String> get livrosDoGeneroAtual =>
      generos[generoSelecionado] ?? const [];

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

    generos[generoSelecionado!]!.add(normalizado);
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
    if (generos.containsKey(normalizado)) return 'Já existe esse gênero.';

    generos[normalizado] = [];
    generoSelecionado = normalizado;
    notifyListeners();
    return null;
  }

  String? editarGenero(String generoAtual, String novoNome) {
    if (!generos.containsKey(generoAtual)) return 'Gênero não encontrado.';

    final normalizado = _capitalizar(novoNome.trim());
    if (normalizado.isEmpty) return 'O nome não pode ser vazio.';
    if (generos.containsKey(normalizado) &&
        normalizado.toLowerCase() != generoAtual.toLowerCase()) {
      return 'Já existe esse gênero.';
    }

    final livros = generos.remove(generoAtual)!;
    generos[normalizado] = livros;
    generoSelecionado = normalizado;
    notifyListeners();
    return null;
  }

  void excluirGenero(String genero) {
    generos.remove(genero);
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
