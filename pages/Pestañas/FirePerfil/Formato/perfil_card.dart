import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../FirePerfil/FollowLevel/follow_button.dart';

import '../../../../scoped-models/mains.dart';
import '../../../Pestañas/FirePerfil/perfil_edit.dart';
import '../../../Pestañas/FirePerfil/FollowLevel/follow_status.dart';

import './perfil_info_tag.dart';

import '../../../../models/perfil.dart';

//Tarjeta de Perfil

class PerfilCard extends StatelessWidget {
  final Perfil perfil;

  PerfilCard(this.perfil);

  Widget _buildBioRow(context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      margin: EdgeInsets.all(10),
      child: Text(
        perfil.bio,
        textScaleFactor: 1.3,
      ),
    );
  }

  Widget _buildEditButton(
      BuildContext context, MainModel model, String perfilId) {
    return GestureDetector(
      onTap: () {
        model.selectPerfil(model.authUser.id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PerfilEdit(model, perfilId);
            },
          ),
        ).then((_) {
          model.selectPerfil(null);
        });
      },
      child: Container(
          width: 140.0,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Row(children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text('Editar Perfil', style: TextStyle(color: Colors.white)),
            SizedBox(
              width: 10.0,
            ),
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
            child: Column(
          children: <Widget>[
            _buildBioRow(context),
            Row(
              children: <Widget>[
                PerfilInfoTag(
                    perfil.semestre.toString(), perfil.carrera, perfil.campus),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
            FollowStatus(perfil, model),
            SizedBox(
              height: 10.0,
            ),
            model.authUser.id == perfil.id
                ? _buildEditButton(context, model, perfil.id)
                : FollowButton(perfil, model.authUser)
          ],
        ));
      },
    );
  }
}
