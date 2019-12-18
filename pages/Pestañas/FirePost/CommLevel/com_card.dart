import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../models/comment.dart';
import '../../../../scoped-models/mains.dart';

import '../XtraPost/visual.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final int commentIndex;

  CommentCard(this.comment, this.commentIndex);

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
           model.authUser.id == comment.userId
              ? IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    model.selectPost(comment.fecha);
                    model.deletePost();
                  },
                )
              : null
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        BuildUserInfoRow(comment.userId, comment.fecha),
        Container(
          padding: EdgeInsets.only(right: 40, left: 20, top: 20, bottom: 20),
          child: Text(
            comment.comentario.toString(),
            textScaleFactor: 1.2,
          ),
        ),
        Divider(
          height: 1,
        ),
        _buildActionButtons(context),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    ));
  }
}
