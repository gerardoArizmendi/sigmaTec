import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../FirePost/posts.dart';

import '../../../models/post.dart';

import '../../../scoped-models/mains.dart';

class MainPostWall extends StatefulWidget {
  final List<Post> wallPosts;

  MainPostWall(this.wallPosts);

  @override
  State<StatefulWidget> createState() {
    return _MainPostWallState();
  }
}

class _MainPostWallState extends State<MainPostWall> {
  
  Widget _buildPostsWall(MainModel model) {
    return PostsWall(widget.wallPosts, model, true);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
    Widget content;
    if (!model.isLoading) {
      content = _buildPostsWall(model);
    } else if (model.isLoading) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: model.postWallGet,
      child: content,
    );
    },);
  }
}
