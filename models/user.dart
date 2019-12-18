import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String token;
  final String nombre;
  final String bio;
  final String username;
  final String carrera;
  final int semestre;
  final String campus;
  final String imageUrl;
  final String imagePath;
  final String perfilId;

  User({
    @required this.id,
    @required this.email,
    @required this.token,
    this.nombre,
    this.bio,
    this.username,
    this.carrera,
    this.semestre,
    this.campus,
    this.imageUrl,
    this.imagePath,
    this.perfilId,
  });
}
