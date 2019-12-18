import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../../../scoped-models/mains.dart';

import './commentarios.dart';

class ComentariosWallMain extends StatefulWidget {
  final String id;
  final String userId;
  final MainModel model;

  ComentariosWallMain(this.id, this.userId, this.model);
  @override
  State<StatefulWidget> createState() {
    return _CommentariosPageState();
  }
}

class _CommentariosPageState extends State<ComentariosWallMain> {
  Widget _buildCommentsWall(MainModel model) {
    return ComentariosWall(widget.model.commentsGet);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content;
        if (!model.isLoading) {
          content = _buildCommentsWall(widget.model);
        } else if (model.isLoading) {
          content = Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(
          onRefresh: model.commentsGetter,
          child: content,
        );
      },
    );
  }
}
