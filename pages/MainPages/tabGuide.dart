import 'package:flutter/material.dart';
import 'package:sigma_tec/pages/Pesta%C3%B1as/FirePost/Walls/faved_gene.dart';

import '../../scoped-models/mains.dart';

import '../Pestañas/muros/talleres.dart';
import '../Pestañas/muros/repres.dart';

import '../Pestañas/FirePost/Walls/faved_main.dart';

class HomePage extends StatelessWidget {
  final MainModel model;

  HomePage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.local_play),
              text: 'Posts',
            ),
            Tab(
              icon: Icon(Icons.nature_people),
              text: 'RepresPage',
            ),
            Tab(
              icon: Icon(Icons.local_library),
              text: 'Talleres',
            ),
          ],
        ),
        primary: false,
        body: new TabBarView(
          children: <Widget>[
            RepresPage(model),
            RepresPage(model),
            Talleres(),
          ],
        ),
      ),
    );
  }
}
