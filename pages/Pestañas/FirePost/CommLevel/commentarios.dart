import 'package:flutter/material.dart';

import './com_card.dart';
import '../../../../models/comment.dart';

class ComentariosWall extends StatelessWidget {
  final List<Comment> comentarios;

  ComentariosWall(this.comentarios);
  //--------------------------------------------------------------
  //--------------------List-View---------------------------------
  //--------------------------------------------------------------
  Widget _buildProductList(List<Comment> comments) {
    comments = comments.reversed.toList();
    Widget productCards;
    if (comments.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final item = CommentCard(comments[index], index);
          return item;
        },
        itemCount: comments.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList(comentarios);
  }
}
