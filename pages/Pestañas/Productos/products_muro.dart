import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../formatos/pages/products/products.dart';

import '../../../scoped-models/mains.dart';


class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    // widget.model.userGet();
    print("Fetching Products");
    super.initState();
  }

  // Widget _buildName(Perfil perfil, MainModel model) {
  //   Widget perfilCards;
  //   if (perfil != null) {
  //     perfilCards = Text(perfil.nombre);
  //   } else {
  //     perfilCards = Container();
  //   }
  //   return perfilCards;
  // }

  // // Widget _buildSideDrawer(
  // //     BuildContext context, Perfil perfil, MainModel model) {
  // //   return Drawer(
  // //     child: Column(
  // //       children: <Widget>[
  // //         SizedBox(
  // //           height: 30.0,
  // //         ),
  // //         _buildName(perfil, model),
  // //         ListTile(
  // //           leading: Icon(Icons.edit),
  // //           title: Text('Mis productos'),
  // //           onTap: () {
  // //             Navigator.pushReplacementNamed(context, '/adminProducts');
  // //           },
  // //         ),
  // //         Divider(),
  // //         ListTile(
  // //           leading: Text(
  // //             '∑',
  // //             style: TextStyle(
  // //               fontSize: 26.0,
  // //               fontWeight: FontWeight.bold,
  // //             ),
  // //           ),
  // //           title: Text('MiSigma'),
  // //           onTap: () {
  // //             Navigator.pushReplacementNamed(context, '/');
  // //           },
  // //         ),
  // //         ListTile(
  // //           leading: Icon(Icons.question_answer),
  // //           title: Text('Chismografo'),
  // //           onTap: () {
  // //             Navigator.pushReplacementNamed(context, '/blog');
  // //           },
  // //         ),
  // //         ListTile(
  // //           leading: Icon(Icons.group_work),
  // //           title: Text('Proyectos ∑'),
  // //           onTap: () {
  // //             Navigator.pushReplacementNamed(context, '/proyectos');
  // //           },
  // //         ),
  // //         Divider(),
  // //         ListTile(
  // //           title: Text('T3C_INC'),
  // //           leading: Icon(Icons.favorite),
  // //           onTap: () {
  // //             _goToInstagram();
  // //           },
  // //         ),
  // //         Divider(),
  // //         LogoutListTitle()
  // //       ],
  // //     ),
  // //   );
  // // }

  // _goToInstagram() async {
  //   const url = 'https://www.instagram.com/t3c_inc/';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Hubo un error, intentalo más tarde $url';
  //   }
  // }

  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('¡No se encontro nariz!'));
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: model.fetchProducts,
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        // drawer: _buildSideDrawer(context, model.perfilGet, model),
        appBar: AppBar(
          title: Text('Productos'),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                  icon: Icon(model.displayFavoritesProductsOnly
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    model.toggleDisplayMode();
                  },
                );
              },
            )
          ],
        ),
        body: _buildProductsList(),
      );
    });
  }
}

// floatingActionButton: FloatingActionButton(
//           child: new Icon(Icons.speaker_notes),
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/adminProducts');
//           }),
//     );
