import 'package:flutter/material.dart';

import './post_card.dart';
import '../../../models/post.dart';
import '../../../scoped-models/mains.dart';

class PostsWall extends StatelessWidget {
  final List<Post> postWall;
  final MainModel model;
  final bool user;

  PostsWall(this.postWall, this.model, this.user);

  //--------------------------------------------------------------
  //--------------------List-View---------------------------------
  //--------------------------------------------------------------
  Widget _buildPostList(List<Post> posts, MainModel model) {
    posts = posts.reversed.toList();
    Widget productCards = ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final item = Center(
            child: Container(
          child: Text('Intentalo de Nuevo'),
        ));
        return item;
      },
      itemCount: 1,
    );
    if (posts.length > 0 && !model.isLoading) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final item = PostCard(posts[index], index);
          return item;
        },
        itemCount: posts.length,
      );
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return _buildPostList(postWall, model);
  }
}
