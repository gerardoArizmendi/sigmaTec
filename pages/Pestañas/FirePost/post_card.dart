import 'package:flutter/material.dart';

// import 'package:photo_view/photo_view.dart';

import '../../../models/post.dart';

import '../FirePost/XtraPost/button_post.dart';
import '../FirePost/XtraPost/visual.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final int index;

  PostCard(this.post, this.index);


  //--------------------------------------------------------
  //--------------------------------------------------------
  //--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BuildUserInfoRow(post.userId, post.fecha),
          Container(
              margin: EdgeInsets.all(10),
              child: post.titulo != null
                  ? Text(
                      post.titulo,
                      textScaleFactor: 1.2,
                    )
                  : Text(
                      post.contenido,
                      maxLines: 5,
                    )),
          Divider(
            indent: 10,
          ),
          post.imageUrl == null
              ? Container()
              : Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 300,
                  child:
                      // PhotoView(
                      //   transitionOnUserGestures: true,
                      //   imageProvider: NetworkImage(post.imageUrl),
                      // ),
                      // ),
                      Text('Picture')),
          ButtonPost(post, index),
        ],
      ),
    );
  }
}
