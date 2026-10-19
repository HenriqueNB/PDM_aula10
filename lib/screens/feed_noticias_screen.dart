import 'package:flutter/material.dart';
import '../models/noticia_model.dart';
import '../services/noticia_service.dart';

class FeedNoticiasScreen extends StatefulWidget {
  const FeedNoticiasScreen({super.key});

  @override
  State<FeedNoticiasScreen> createState() => _FeedNoticiasScreenState();
}

class _FeedNoticiasScreenState extends State<FeedNoticiasScreen> {
  final _service = NoticiaService();
  List<NoticiaModel> _todasNoticias = [];
  List<NoticiaModel> _noticiasFiltradas = [];
  bool _carregando = true;
  String? _erro;
  final TextEditingController _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarFeed();
  }

  Future<void> _carregarFeed() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final lista = await _service.buscarNoticias();
      setState(() {
        _todasNoticias = lista;
        _noticiasFiltradas = lista;
      });
    } catch (e) {
      setState(() => _erro = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _filtrarNoticias(String query) {
    setState(() {
      _noticiasFiltradas = _todasNoticias
          .where((noticia) =>
              noticia.titulo.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed de Notícias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarFeed,
          ),
        ],
      ),
      body: _buildConteudo(),
    );
  }

  Widget _buildConteudo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_erro!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _carregarFeed,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Campo de Busca (Desafio Básico da Aula 10)
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _buscaController,
            onChanged: _filtrarNoticias,
            decoration: InputDecoration(
              hintText: 'Filtrar notícias por título...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: _noticiasFiltradas.isEmpty
              ? const Center(child: Text('Nenhuma notícia encontrada.'))
              : ListView.builder(
                  itemCount: _noticiasFiltradas.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final noticia = _noticiasFiltradas[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(noticia.id.toString()),
                        ),
                        title: Text(
                          noticia.titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          noticia.resumo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}