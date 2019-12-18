class Post {
  final String id;
  final String titulo;
  final String contenido;
  final String fecha;
  final String tipo;
  final String imageUrl;
  final String imagePath;
  final String link;
  final String username;
  final String userId;
  final String userImage;
  final bool esFavorito;

  Post(
      {this.id,
      this.titulo,
      this.contenido,
      this.fecha,
      this.tipo,
      this.imageUrl,
      this.imagePath,
      this.link,
      this.username,
      this.userId,
      this.userImage,
      this.esFavorito = false});
}
