import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sigma_tec/models/user.dart';

import '../post_card.dart';
import '../../../../models/post.dart';
import '../../../../models/user.dart';
import '../../../../scoped-models/mains.dart';

class FavedWall extends StatefulWidget {
  final List<Post> posts; //model.postsGet
  final bool ready;

  FavedWall(this.posts, this.ready);
  @override
  State<StatefulWidget> createState() {
    return _FavedWallState();
  }
}

class _FavedWallState extends State<FavedWall> {
  @override
  initState() {
    // print(widget.posts.length);
    print(widget.ready.toString());
    super.initState();
  }

  //--------------------------------------------------------------
  //--------------------List-View---------------------------------
  //--------------------------------------------------------------
  Widget _buildFavedList(List<Post> posts, User user, MainModel model) {
    Widget productCards = Center(
      child: Text('No haz compartido Likes'),
    );
    print(posts.length);
    List<Post> favedPosts = [];
    if (posts.length > 0) {
      // posts = posts.reversed.toList();
      print('postLength');
      int i = 0;
      widget.posts.forEach((subject) {
        subject.esFavorito ? favedPosts.add(posts[i]) : null;
        i++;
      });
    }
    favedPosts = favedPosts.reversed.toList();
    print(favedPosts.length);
    if (favedPosts.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Widget item = PostCard(favedPosts[index], index);
          return item;
        },
        itemCount: favedPosts.length,
      );
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget item = _buildFavedList(widget.posts, model.authUser, model);
        return item;
      },
    );
  }
}
