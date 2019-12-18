import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';

import './tabGuide.dart';
import '../ui_elementes/logout_list_title.dart';
import '../Pestañas/FirePerfil/perfil_gene.dart';
import '../../scoped-models/mains.dart';

import '../Pestañas/Muros/main_wall.dart';

import '../../models/user.dart';
import '../../models/perfil.dart';
import './../formatos/helpers/user_data.dart';

class TabMain extends StatefulWidget {
  final MainModel model;

  TabMain(this.model);

  @override
  State<StatefulWidget> createState() {
    return _TabMainState();
  }
}

class _TabMainState extends State<TabMain> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            drawer: _buildSideDrawer(
                    context, widget.model.authUser, widget.model),
            floatingActionButton: widget.model.authUser.nombre == null
                ? null
                : FloatingActionButton(
                child: new Icon(Icons.speaker_notes),
                onPressed: () {
                  widget.model.clearPostSelected(true);
                  Navigator.of(context).pushNamed('/editPost');
                }),
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.functions)),
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.assignment_ind)),
                ],
              ),
              backgroundColor: Colors.blue,
              title: Text('MiSigmas'),
            ),
            body: TabBarView(
                    children: [
                      MainPostWall(widget.model.wallPost),
                      HomePage(widget.model),
                      PerfilWallGenerator(widget.model, widget.model.authUser.id),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildName(Perfil perfil, MainModel model) {
    Widget perfilName = Container();
    if (perfil == null) {
      return perfilName;
    } else if (model.isLoading) {
      perfilName = Center(child: Container());
    } else if (perfil.nombre != null && !model.isLoading) {
      perfilName = UserData(model, perfil);
    }
    return perfilName;
  }

  Widget _buildSideDrawer(
      BuildContext context, User perfil, MainModel model) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.blueGrey,
            automaticallyImplyLeading: false,
            title: Text('T3C'),
          ),
          _buildName(model.authUserToPerfil, model),
          ListTile(
            leading: Icon(Icons.group_work),
            title: Text('Posts ∑'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/posts');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Productos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          ),
          ListTile(
            leading: Icon(Icons.movie_filter),
            title: Text('Memes'),
            onTap: () {
              print('Memes');
            },
          ),
          ListTile(
            leading: Icon(Icons.group_work),
            title: Text('Proyectos ∑'),
            onTap: () {
              print('Proyectos');
            },
          ),
          Divider(),
          ListTile(
            title: Text('T3C_INC'),
            leading: Icon(
              Icons.favorite,
            ),
            onTap: () {
              _goToInstagram();
            },
          ),
          Divider(),
          LogoutListTitle()
        ],
      ),
    );
  }

  _goToInstagram() async {
    const url = 'https://www.instagram.com/t3c_inc/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Hubo un error, intentalo más tarde $url';
    }
  }
}
