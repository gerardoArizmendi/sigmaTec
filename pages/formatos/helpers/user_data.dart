import 'package:flutter/material.dart';
import 'package:sigma_tec/pages/Pesta%C3%B1as/FirePerfil/FollowLevel/follow_status.dart';

import '../../../scoped-models/mains.dart';

import '../../Pestañas/FirePerfil/perfil_muro.dart';
import '../../../models/perfil.dart';

//AppDrawer Name.

class UserData extends StatelessWidget {
  final MainModel model;
  final Perfil perfil;

  UserData(this.model, this.perfil);

  Widget _buildNameRow(context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<bool>(
                builder: (BuildContext context) => PerfilPage(model, true)));
      },
      child: Container(
          padding: EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              perfil.nombre,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '@' + perfil.username,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ])),
    );
  }

  Widget _buildAvatarImage() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(12),
        child: CircleAvatar(
          backgroundImage: NetworkImage(perfil.imageUrl),
          radius: 35,
        ),
      ),
      onTap: () {
        print('Profile');
        print(model.isLoading);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildAvatarImage(),
        _buildNameRow(context),
        SizedBox(
          height: 10.0,
        ),
        FollowStatus(perfil, model),
        SizedBox(
          height: 10.0,
        ),
        Divider(),
      ],
    );
  }
}
