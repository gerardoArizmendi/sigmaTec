import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../scoped-models/mains.dart';

class ComPost extends StatelessWidget {
  final String id;
  final String userId;
  final List<DocumentSnapshot> comments;
  final MainModel model;
  final bool newCom = true;

  ComPost(this.id, this.userId, this.comments, this.model);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      IconButton(
        icon: Icon(Icons.comment),
        onPressed: () {
          Future.value(newCom);
          model.selectPost(id);
          Navigator.pushNamed<bool>(context, '/post/' + id + '/true/');
        },
      ),
      Text(comments.length.toString())
    ]);
  }
}
