import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../models/post.dart';

import './faved_main.dart';

import '../../../../scoped-models/mains.dart';

class FavedGenerator extends StatefulWidget {
  final MainModel model;
  final String userId;

  FavedGenerator(this.model, this.userId);

  @override
  State<StatefulWidget> createState() {
    return _FavedGeneratorState();
  }
}

class _FavedGeneratorState extends State<FavedGenerator> {
  initState() {
    widget.model.postWallGet();
    super.initState();
  }

  Widget _buildFavedWall(MainModel model, List<Post> posts) {
    return FavedPage(model, posts, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
    Widget content;
    if (!model.isLoading) {
      content = _buildFavedWall(model, model.postsGet);
    } else if (model.isLoading) {
      print('isLoading');
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
