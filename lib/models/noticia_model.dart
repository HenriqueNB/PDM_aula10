class NoticiaModel {
  final int id;
  final String titulo;
  final String resumo;
  final String conteudoCompleto;
  final String autor;
  final String urlImagem;

  NoticiaModel({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.conteudoCompleto,
    required this.autor,
    required this.urlImagem,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    final bodyText = json['body'] as String? ?? 'Sem conteúdo disponível.';
    return NoticiaModel(
      id: json['id'] ?? 0,
      titulo: json['title'] ?? 'Sem título',
      resumo: bodyText.length > 50 ? '${bodyText.substring(0, 50)}...' : bodyText,
      conteudoCompleto: bodyText,
      autor: json['autor'] ?? 'Autor ID ${json['userId'] ?? 1}',
      urlImagem: json['urlImagem'] ?? 'https://picsum.photos/seed/${json['id'] ?? 1}/600/300',
    );
  }
}