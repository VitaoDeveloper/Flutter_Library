import 'package:flutter/material.dart';
import '../../controllers/biblioteca_controller.dart';
import 'widgets/genero_dropdown.dart';
import 'widgets/genero_acoes.dart';
import 'widgets/livro_list_tile.dart';
import 'widgets/dialogs.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = BibliotecaController();
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Mensagem
  // ---------------------------------------------------------------------------

  void _mostrarSnackBar(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------------------------------------------------------------------------
  // Ações de livro
  // ---------------------------------------------------------------------------

  Future<void> _adicionarLivro() async {
    final nome = await mostrarDialogTexto(
      context,
      titulo: 'Adicionar livro',
      labelCampo: 'Nome do livro',
      textoBotaoConfirmar: 'Adicionar',
    );
    if (nome == null) return;

    final erro = _controller.adicionarLivro(nome);
    _mostrarSnackBar(erro ?? 'Livro adicionado.');
    if (erro == null) setState(() {});
  }

  Future<void> _editarLivro(int indexReal) async {
    final livroAtual = _controller.livrosDoGeneroAtual[indexReal];
    final novoNome = await mostrarDialogTexto(
      context,
      titulo: 'Editar livro',
      labelCampo: 'Nome do livro',
      textoBotaoConfirmar: 'Salvar',
      textoInicial: livroAtual,
    );
    if (novoNome == null) return;

    final erro = _controller.editarLivro(indexReal, novoNome);
    _mostrarSnackBar(erro ?? 'Livro atualizado.');
    if (erro == null) setState(() {});
  }

  Future<void> _excluirLivro(int indexReal) async {
    final livro = _controller.livrosDoGeneroAtual[indexReal];
    final confirmado = await mostrarDialogConfirmacao(
      context,
      titulo: 'Excluir livro',
      mensagem: 'Tem certeza que deseja excluir "$livro"?',
      textoBotaoConfirmar: 'Excluir',
    );
    if (!confirmado) return;

    _controller.excluirLivro(indexReal);
    setState(() {});
    _mostrarSnackBar('Livro "$livro" excluído.');
  }

  // ---------------------------------------------------------------------------
  // Ações de gênero
  // ---------------------------------------------------------------------------

  Future<void> _adicionarGenero() async {
    
    final nome = await mostrarDialogTexto(
      context,
      titulo: 'Adicionar gênero',
      labelCampo: 'Nome do gênero',
      textoBotaoConfirmar: 'Adicionar',
    );
    if (nome == null) return;

    final erro = _controller.adicionarGenero(nome);
    _mostrarSnackBar(erro ?? 'Gênero adicionado.');
    if (erro == null) setState(() {});
  }

  Future<void> _editarGenero() async {
    final generoAtual = _controller.generoSelecionado!;
    final novoNome = await mostrarDialogTexto(
      context,
      titulo: 'Editar Gênero',
      labelCampo: 'Nome do Gênero',
      textoBotaoConfirmar: 'Salvar',
      textoInicial: generoAtual,
    );
    if (novoNome == null) return;

    final erro = _controller.editarGenero(generoAtual, novoNome);
    _mostrarSnackBar(erro ?? 'Gênero atualizado.');
    if (erro == null) setState(() {});
  }

  Future<void> _excluirGenero() async {
    final genero = _controller.generoSelecionado!;
    final confirmado = await mostrarDialogConfirmacao(
      context,
      titulo: 'Excluir gênero',
      mensagem: 'Tem certeza que deseja excluir "$genero"?',
      textoBotaoConfirmar: 'Excluir',
    );
    if (!confirmado) return;

    _controller.excluirGenero(genero);
    setState(() {});
    _mostrarSnackBar('Gênero "$genero" excluído.');
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final livros = _controller.livrosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Biblioteca Flutter',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.generoSelecionado == null
            ? () => _mostrarSnackBar('Selecione um gênero antes de adicionar.')
            : _adicionarLivro,
        tooltip: 'Adicionar Livro',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            GeneroDropdown(
              generos: _controller.generos,
              generoSelecionado: _controller.generoSelecionado,
              onChanged: (selecao) => setState(() {
                _controller.selecionarGenero(selecao);
                _buscaController.clear();
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _buscaController,
              enabled: _controller.generoSelecionado != null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar livro',
              ),
              onChanged: (txt) => setState(() => _controller.atualizarBusca(txt)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: livros.isEmpty
                  ? const Center(child: Text('Nenhum resultado.'))
                  : ListView.separated(
                      itemCount: livros.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, indexFiltrado) {
                        final livro = livros[indexFiltrado];
                        final indexReal =
                            _controller.livrosDoGeneroAtual.indexOf(livro);
                        return LivroListTile(
                          livro: livro,
                          onTap: () =>
                              _mostrarSnackBar('Você selecionou: $livro'),
                          onEditar: () => _editarLivro(indexReal),
                          onExcluir: () => _excluirLivro(indexReal),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            GeneroAcoes(
              generoSelecionado: _controller.generoSelecionado,
              onAdicionar: _adicionarGenero,
              onEditar: _editarGenero,
              onExcluir: _excluirGenero,
            ),
          ],
        ),
      ),
    );
  }
}
