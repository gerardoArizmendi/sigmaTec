import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './faved_wall.dart';
import '../../../../models/post.dart';

import '../../../../scoped-models/mains.dart';

class FavedPage extends StatefulWidget {
  final MainModel model;
  final List<Post> posts;
  final String userId;

  FavedPage(this.model, this.posts, this.userId);
  @override
  State<StatefulWidget> createState() {
    return _PostsPageState();
  }
}

class _PostsPageState extends State<FavedPage> {
  bool ready = false;
  @override
  initState() {
    if (mounted) {
      widget.model.clearComments(true);
      List<Post> posts = widget.model.postsGet;
      final List<String> idList = [];
      posts.forEach((post) {
        //Get id of all Posts in Query
        final String id = post.id;
        idList.add(id);
      });
      widget.model
          .esFavoritoList(idList, widget.userId); //Updates esFavorito: {bool}
      super.initState();
    }
  }

  Widget _buildPostsList(MainModel model) {
    Widget content = Center(child: Text('¡No se encontro nada!'));
    if (model.postsGet.length > 0) {
      content = FavedWall(model.postsGet, ready);
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          body: _buildPostsList(model),
        );
      },
    );
  }
}
