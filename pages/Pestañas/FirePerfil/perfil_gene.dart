import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../FirePerfil/perfil_muro.dart';

import '../../../models/post.dart';

import '../../../scoped-models/mains.dart';

class PerfilWallGenerator extends StatefulWidget {
  final MainModel model;
  final String userId;

  PerfilWallGenerator(this.model, this.userId);

  @override
  State<StatefulWidget> createState() {
    return _PerfilWallGeneratorState();
  }
}

class _PerfilWallGeneratorState extends State<PerfilWallGenerator> {
  bool authUser;

  @override
  initState() {
    widget.model.clearPosts(true);
    if (widget.model.authUser.id == widget.userId) {
      setState(() {
        authUser = true;
        widget.model.postGet(onlyForUser: true);
        print('Is User');
      });
    } else {
      setState(() {
        authUser = false;
        print('Is NOT User');
        widget.model.postGet(onlyFor: true);
      });
    }
    super.initState();
  }

  Widget _buildPerfil(MainModel model, List<Post> fetchPosts) {
    return new PerfilPage(widget.model, authUser);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildPerfil(widget.model, widget.model.postsGet);
    });
  }
}
