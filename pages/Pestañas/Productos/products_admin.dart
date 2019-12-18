import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../../../scoped-models/mains.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        appBar: AppBar(
          leading: Container(child: 
            IconButton(
              icon: Icon(Icons.backspace),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/proyectos');
              },
            ),),
          title: Text('Tus Productos'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Agrega un Producto',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'Mis Products',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductEditPage(),
            ProductListPage(model)
          ],
        ),
      ),
    );
  }
}
