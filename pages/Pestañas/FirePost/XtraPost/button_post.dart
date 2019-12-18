import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../scoped-models/mains.dart';
import '../../../../models/post.dart';

import './like_post.dart';
import './com_post.dart';

class ButtonPost extends StatefulWidget {
  final Post post;
  final int index;

  ButtonPost(this.post, this.index);

  @override
  State<StatefulWidget> createState() {
    return _ButtonPostState();
  }
}

class _ButtonPostState extends State<ButtonPost> {
  List<DocumentSnapshot> _comments = [];

  @override
  void initState() {
    if (mounted) {
      commentsStatus(widget.post.id, widget.post.userId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildActionButtons(context, widget.post, widget.index, _comments);
  }

  void commentsStatus(String id, String userId) {
    Firestore.instance
        .collection('/SIGMAS')
        .document(id)
        .collection('comentarios')
        .getDocuments()
        .then((value) {
      if (mounted) {
        setState(() {
          _comments = value.documents;
        });
      }
    }).catchError((e) {
      print('error: ');
      print(e);
    });
  }
}

//-------------------------------------------------------------
//-----------------------Action-Buttons------------------------
//-------------------------------------------------------------

Widget _buildActionButtons(BuildContext context, Post post, int index,
    List<DocumentSnapshot> comentarios) {
  return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
    if (model.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              color: Theme.of(context).accentColor,
              onPressed: () {
                model.selectPost(post.id);
                print(post.id);
                Navigator.pushNamed<bool>(
                    context, '/post/' + post.id + '/false/');
              }),
          LikePost(post, model.authUser, index),
          ComPost(post.id, post.userId, comentarios, model),
          model.authUser.id == post.userId
              ? IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    model.selectPost(post.id);
                    model.deletePost();
                  },
                )
              : null
        ],
      );
    }
  });
}
