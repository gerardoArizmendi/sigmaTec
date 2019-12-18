import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/post.dart';
import '../../../models/comment.dart';
import '../../../models/perfil.dart';

import './CommLevel/com_muro.dart';
import './XtraPost/visual.dart';
import './XtraPost/like_post.dart';

import '../../../scoped-models/mains.dart';

class PostData extends StatefulWidget {
  final Post post;
  final int index;
  final bool comFocus;
  final MainModel model;
  // final DocumentSnapshot userInfo;

  PostData(this.post, this.index, this.comFocus, this.model);
  @override
  State<StatefulWidget> createState() {
    return _PostDataPageState(post, model);
  }
}

class _PostDataPageState extends State<PostData> {
  MainModel model;
  Post post;

  _PostDataPageState(this.post, this.model);

  Perfil userInfo;
  String _comentario;
  List<Comment> comments = [];
  final TextEditingController _controller = new TextEditingController();
  bool focus;

  @override
  void initState() {
    if (mounted) {
      widget.model.userAuthFetch();
      widget.model.commentsGetter();
      focus = widget.comFocus;
    }
    super.initState();
  }

  FocusNode com = new FocusNode();

  @override
  Widget build(BuildContext context) {
    if (focus) {
      FocusScope.of(context).requestFocus(com);
    } else {
      FocusScope.of(context).unfocus();
    }

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          print('Poped');
          widget.model.clearPostSelected(true);
          widget.model.clearComments(true);
          widget.model.postGet();
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Card(
                  child: Column(
                children: <Widget>[
                  BuildUserInfoRow(post.userId, post.fecha),
                  post.titulo != null ? _buildTitulo() : Divider(),
                  _buildContenido(),
                  Divider(),
                  LikePost(widget.post, widget.model.authUser, widget.index),
                  Divider(),
                  Container(
                    color: Colors.grey[100],
                    margin: EdgeInsets.all(20.0),
                    child: TextField(
                      controller: _controller,
                      focusNode: com,
                      decoration: InputDecoration(hintText: 'Comentario'),
                      onChanged: (value) {
                        setState(() {
                          _comentario = value;
                        });
                      },
                    ),
                  ),
                  FlatButton(
                    child: Icon(Icons.subdirectory_arrow_right),
                    onPressed: () {
                      _controller.clear();
                      model.storeNewComment(post.id, _comentario, context);
                      widget.model.commentsGetter();
                      setState(() {
                        focus = false;
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  Expanded(
                      child: ComentariosWallMain(
                          widget.post.id, widget.post.userId, widget.model))
                ],
              )),
            )));
  }

// //---------------------------------------------------------------------
// //-----------------------------Build-POST------------------------------
// //---------------------------------------------------------------------

  Widget _buildContenido() {
    return Container(
      constraints: BoxConstraints(),
      padding: EdgeInsets.all(20),
      child: Text(post.contenido),
    );
  }

  Widget _buildTitulo() {
    return Card(
        child: Container(
            margin: EdgeInsets.all(10),
            child: Text(
              post.titulo,
              textAlign: TextAlign.justify,
              textScaleFactor: 1.2,
            )));
  }
}
