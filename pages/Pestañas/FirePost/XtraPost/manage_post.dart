import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../post_edit.dart';
import '../../../../scoped-models/mains.dart';

class ManagePost extends StatefulWidget {
  final String postId;
  final MainModel model;

  ManagePost(this.postId, this.model);
  @override
  State<StatefulWidget> createState() {
    return _ManagePostPageState();
  }
}

class _ManagePostPageState extends State<ManagePost> {
  @override
  initState() {
    widget.model.clearData(true);
    widget.model.postGet();
    widget.model.userAuthFetch();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.postsGet[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PostEditPage();
            },
          ),
        ).then((_) {
          model.selectPost(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return WillPopScope(
            onWillPop: () {
              print('Back button pressed!');
              Navigator.pop(context, false);
              return Future.value(false);
            },
            child: Scaffold(
              appBar: AppBar(),
              body: Container(
                  child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(model.postsGet[index].titulo),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        model.selectPost(widget.model.postsGet[index].id);
                        model.deletePost();
                      }
                    },
                    background: Container(
                      color: Colors.red,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                model.postsGet[index].userImage,
                              ),
                            ),
                            title: Text(model.postsGet[index].titulo),
                            subtitle: Text(
                                '\$${model.postsGet[index].username.toString()}'),
                            trailing: _buildEditButton(context, index, model)),
                        Divider(),
                      ],
                    ),
                  );
                },
                itemCount: model.postsGet.length,
              )),
            ));
      },
    );
  }
}
