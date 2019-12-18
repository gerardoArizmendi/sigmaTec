import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../scoped-models/mains.dart';


class BuildUserInfoRow extends StatefulWidget {
  final String userId;
  final String fecha;

  BuildUserInfoRow(this.userId, this.fecha);

  @override
  State<StatefulWidget> createState() {
    return _BuildUserInfoRowState();
  }
}

class _BuildUserInfoRowState extends State<BuildUserInfoRow> {
  String username;
  String userImage;

  @override
  void initState() {
    extractUserData(widget.userId);
    super.initState();
  }

  void extractUserData(String id) async {
    print(id);
    DocumentSnapshot value =
        await Firestore.instance.collection('/Perfiles').document(id).get();
    if (mounted) {
      setState(() {
        username = value.data['username'];
        userImage = value.data['imageUrl'];
      });
    }
  }

  Widget _buildUsersInfoRow(MainModel model) {
    // print(model.perfilXGet.id);
    String tiempoDesde = '1997';
    final dateNow = new DateTime.now();
    var fechaPost = DateTime.parse(widget.fecha);
    final dateTimeSincePost = dateNow.difference(fechaPost).inMinutes;
    if (dateTimeSincePost < 60) {
      tiempoDesde = (dateTimeSincePost.toString()) + ' min';
    } else if (dateTimeSincePost <= 1440) {
      tiempoDesde = ((dateTimeSincePost / 60).round().toString()) + ' hrs';
    } else if (dateTimeSincePost <= 10080) {
      tiempoDesde = ((dateTimeSincePost / 1440).round().toString()) + ' dias';
    } else {
      tiempoDesde = DateFormat('kk:mm - dd-MM-yyyy').format(fechaPost);
    }

    return (username == null || userImage == null) 
        ? Center(child: CircularProgressIndicator())
        : Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/perfil/' + widget.userId);
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                    radius: 29,
                  ),
                  title: Text(username),
                  subtitle: Text(tiempoDesde),
                ),
              ),
            ),
            flex: null,
          );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildUsersInfoRow(model);
      },
    );
  }
}
