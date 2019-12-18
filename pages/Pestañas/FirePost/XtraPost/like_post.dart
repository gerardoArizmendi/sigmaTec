import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../models/post.dart';
import '../../../../models/user.dart';
import '../../../../scoped-models/mains.dart';

class LikePost extends StatefulWidget {
  final Post post;
  final User user;
  final int index;

  LikePost(this.post, this.user, this.index);

  @override
  State<StatefulWidget> createState() {
    return _ComPostState();
  }
}

class _ComPostState extends State<LikePost> {
  bool _know = false;
  int _favs = 0;
  DocumentSnapshot _favorites;

  @override
  void initState() {
    if (!widget.post.esFavorito)
    isFavoriteStatus(widget.post.id, widget.user.id);
    super.initState();
  }

  void isFavoriteStatus(id, userId) {
    Firestore.instance
        .collection('/SIGMAS')
        .document(id)
        .collection('Favs')
        .document('MeGusta')
        .get()
        .then((value) {
      retrieveData(value, userId);
    });
  }

  retrieveData(doc, userId) async {
    DocumentSnapshot val = await doc;
    if (mounted) {
      if (val.data == null) {
        _know = false; //Usar know to toggle favlist
      } else {
        _favorites = val;
        setState(() {
          _favs = _favorites.data.length;
        });
        if (_favorites.data.containsValue(userId)) {
          _know = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Row(children: <Widget>[
          IconButton(
            icon: Icon(_know ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              model.toggleFavStaus(widget.post.id, widget.user.username,
                  widget.user.id, _know, 'Favs', 'MeGusta');
              if (mounted) {
                model.selectPost(widget.post.id);
                isFavoriteStatus(widget.post.id, widget.user.id);
                setState(() {
                  _know = !_know;
                });
              }
            },
          ),
          Text(_favs.toString())
        ]);
      },
    );
  }
}
