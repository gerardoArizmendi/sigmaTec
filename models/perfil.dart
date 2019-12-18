class Perfil {
  final String id;
  final String nombre;
  final String bio;
  final String username;
  final String carrera;
  final int semestre;
  final String campus;
  final String imageUrl;
  final String imagePath;
  final String userEmail;
  final String userId;
  final bool isFollowed;

  Perfil(
      {this.id,
      this.nombre,
      this.bio,
      this.username,
      this.carrera,
      this.semestre,
      this.campus,
      this.imageUrl,
      this.imagePath,
      this.userEmail,
      this.userId,
      this.isFollowed = false});
}
