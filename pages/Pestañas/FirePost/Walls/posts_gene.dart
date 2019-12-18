import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../posts.dart';

import '../../../../models/post.dart';

import '../../../../scoped-models/mains.dart';

class PostsGenerator extends StatefulWidget {
  final MainModel model;
  final String userId;

  PostsGenerator(this.model, this.userId);

  @override
  State<StatefulWidget> createState() {
    return _PostsGeneratorState();
  }
}

class _PostsGeneratorState extends State<PostsGenerator> {
  initState() {
    widget.model.clearPosts(true);
    if (widget.model.authUser.id == widget.userId) {
      widget.model.postGet(onlyForUser: true);
    } else {
      widget.model.postGet(onlyFor: true);
    }
    super.initState();
  }

  Widget _buildPostsWall(MainModel model, List<Post> fetchPosts) {
    return new PostsWall(
      model.postsGet,
      model,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return widget.model.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildPostsWall(widget.model, widget.model.postsGet);
    });
  }
}
