import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../scoped-models/mains.dart';

import '../../../../models/perfil.dart';

class FollowStatus extends StatefulWidget {
  final Perfil user;
  final MainModel model;

  FollowStatus(this.user, this.model);

  @override
  State<StatefulWidget> createState() {
    return _FollowStatusState();
  }
}

class _FollowStatusState extends State<FollowStatus> {
  @override
  void initState() {
    print('Follow Status:');
    print(widget.user.nombre);
    print(widget.user.id);
    widget.model.followersStatus(widget.user.id);
    widget.model.followingStatus(widget.user.id);
    super.initState();
  }

  Widget _buildInteraction(context, model) {
    return Container(
        padding: EdgeInsets.only(left: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            //Seguidores
            Row(
              children: <Widget>[
                Text(
                  'Seguidores: ',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  model.followers.toString(),
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(width: 15),
            //Siguiendo
            Row(
              children: <Widget>[
                Text(
                  'Siguiendo: ',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  model.following.toString(),
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildInteraction(context, model);
      },
    );
  }
}
