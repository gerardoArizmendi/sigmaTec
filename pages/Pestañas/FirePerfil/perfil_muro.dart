import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sigma_tec/pages/Pesta%C3%B1as/FirePost/Walls/faved_gene.dart';

import '../../../models/perfil.dart';

import '../FirePost/Walls/posts_gene.dart';

import './Formato/perfil.dart';
import '../../../scoped-models/mains.dart';

class PerfilPage extends StatefulWidget {
  final MainModel model;
  final bool authUser;

  PerfilPage(this.model, this.authUser);

  @override
  State<StatefulWidget> createState() {
    return _PerfilPageState();
  }
}

class _PerfilPageState extends State<PerfilPage> {
  Perfil perfil;

  Widget _buildPerfil(BuildContext context, Perfil perfil, MainModel model) {
    Widget content = Center(
        child: RaisedButton(
            child: Text('Crea tu perfil'),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/editPerfil');
            }));
    if (model.authUser.nombre != null && !model.isLoading) {
      content = PerfilCustom(perfil);
    } else if (model.isLoading) {
      content = Center(child: Container(child: Text('Im Loading')));
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        print('{Buildind Profile Wall}');
        widget.authUser == false
            ? perfil = widget.model.perfilXGet
            : perfil = widget.model.authUserToPerfil;
        return Scaffold(
            body: ((perfil.nombre == null) && (perfil.imageUrl == null))
                ? _buildPerfil(context, perfil, model)
                : DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                                expandedHeight: 200.0,
                                forceElevated: true,
                                pinned: true,
                                flexibleSpace: FlexibleSpaceBar(
                                  title: Text(perfil.nombre),
                                  background: Hero(
                                      tag: perfil.id.toString(),
                                      child: FadeInImage(
                                        image: NetworkImage(perfil.imageUrl),
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            AssetImage('assets/Logo∑.jpg'),
                                      )),
                                )),
                            SliverList(
                                delegate: SliverChildListDelegate([
                              Container(
                                  child: _buildPerfil(context, perfil, model))
                            ])),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _SliverAppBarDelegate(
                                TabBar(
                                  labelColor: Colors.blueGrey,
                                  indicatorColor: Colors.blueGrey,
                                  unselectedLabelColor: Colors.black,
                                  tabs: [
                                    Tab(icon: Icon(Icons.info), text: "Posts"),
                                    Tab(
                                        icon: Icon(Icons.favorite),
                                        text: "Favs"),
                                  ],
                                ),
                              ),
                            ),
                          ];
                        },
                        body: new TabBarView(children: <Widget>[
                          new PostsGenerator(model, perfil.id),
                          new FavedGenerator(model, perfil.id),
                        ]))));
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
