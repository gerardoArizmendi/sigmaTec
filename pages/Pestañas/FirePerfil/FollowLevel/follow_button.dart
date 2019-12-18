import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../models/user.dart';
import '../../../../models/perfil.dart';
import '../../../../scoped-models/mains.dart';

class FollowButton extends StatefulWidget {
  final Perfil perfil;
  final User user;

  FollowButton(this.perfil, this.user);

  @override
  State<StatefulWidget> createState() {
    return _FollowButtonState();
  }
}

class _FollowButtonState extends State<FollowButton> {
  bool _following = false;
  DocumentSnapshot _followers;
  // int _followersNom;

  @override
  void initState() {
    followingStatus(widget.perfil.id, widget.user.id);
    super.initState();
  }

  void followingStatus(id, userId) {
    Firestore.instance
        .collection('/Perfiles')
        .document(id)
        .collection('Activity')
        .document('Followers')
        .get()
        .then((value) {
      retrieveData(value, userId);
    });
  }

  retrieveData(doc, userId) async {
    DocumentSnapshot val = await doc;
    if (mounted) {
      if (val.data == null) {
        setState(() {
          _following = false; //Usar know to toggle favlist
        });
      } else {
        _followers = val;
        // setState(() {
        //   _followersNom = _followers.data.length;
        // });
        if (_followers.data.containsValue(userId)) {
          _following = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return GestureDetector(
        onTap: () {
          model.toggleFollowStaus(widget.perfil.id, _following, 'Activity', 'Followers');
          if (mounted) {
            model.selectPerfil(widget.perfil.id);
            followingStatus(widget.perfil.id, widget.user.id);
            setState(() {
              _following = !_following;
            });
          }
        },
        child: Container(
            width: 140.0,
            decoration: BoxDecoration(
              color: _following == true ? Colors.white : Colors.blue,
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
              _following == true
                  ? Text('Siguiendo', style: TextStyle(color: Colors.blue))
                  : Text('Seguir', style: TextStyle(color: Colors.white)),
              SizedBox(
                width: 10.0,
              ),
            ])),
      );
    });
  }
}
