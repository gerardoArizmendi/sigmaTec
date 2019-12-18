import 'package:flutter/material.dart';

import './perfil_card.dart';
import '../../../../models/perfil.dart';

class PerfilCustom extends StatelessWidget {
  final Perfil perfil;

  PerfilCustom(this.perfil);
  Widget _buildPerfil(Perfil perfil) {
    Widget perfilCards;
    if (perfil != null) {
      perfilCards = PerfilCard(perfil);
    } else {
      perfilCards = Container();
    }
    return perfilCards;
  }

  @override
  Widget build(BuildContext context) {
    return _buildPerfil(perfil);
  }
}
