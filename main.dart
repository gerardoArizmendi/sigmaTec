import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:map_view/map_view.dart';

// import 'package:flutter/rendering.dart';

import './pages/MainPages/AboutUs/auth.dart';
import './pages/MainPages/tabMain.dart';

import './pages/Pestañas/productos/products_admin.dart';
import './pages/Pestañas/Productos/products_muro.dart';
import './pages/Pestañas/Productos/product.dart';

import './pages/Pestañas/FirePerfil/perfil_muro.dart';
import './pages/Pestañas/FirePerfil/perfil_edit.dart';
// import './pages/Pestañas/FirePerfil/user_perfil.dart';

import './pages/Pestañas/FirePost/post_edit.dart';
import './pages/Pestañas/FirePost/post_content.dart';

import './pages/MainPages/AboutUs/Intro.dart';

import './scoped-models/mains.dart';
import './models/product.dart';
import './models/post.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  //MapView.setApiKey('AIzaSyAPskkHrvml2XsbijdGtKZ9NA6R2Enb0mg');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;
  FirebaseUser user;

  @override
  void initState() {
    // _model.autoAuthenticate();
    _model.fireUserSubject.listen((bool isAuthenticated) {
      setState(() {
        _model.userAuthFetch();
        _model.postWallGet();
        _isAuthenticated = isAuthenticated;
        print('Is autenticated');
      });
    });
    print('isNot authenticated');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.black,
            accentColor: Colors.blueGrey,
            buttonColor: Colors.blueGrey),
        // home: Intro(),
        routes: {
          '/authPage': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : TabMain(_model),
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : TabMain(_model),
          '/products': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          '/adminProducts': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model),
          '/editPerfil': (BuildContext context) => !_isAuthenticated
              ? AuthPage()
              : PerfilEdit(_model, _model.authUser.id),
          '/editPost': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : PostEditPage(),
          // '/posts': (BuildContext context) =>
          //     !_isAuthenticated ? Intro() : PostsPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductPage(product),
            );
          }
          if (pathElements[1] == 'post') {
            final String postId = pathElements[2];
            print(postId);
            bool focus; //comentarios
            if (pathElements[3] == 'true') {
              focus = true;
            } else {
              focus = false;
            }
            final Post post = _model.wallPost.firstWhere((Post post) {
              return post.id == postId;
            });
            final int index = _model.wallPost.indexWhere((Post post) {
              return post.id == postId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => !_isAuthenticated
                  ? AuthPage()
                  : PostData(post, index, focus, _model),
            );
          }
          if (pathElements[1] == 'perfil') {
            final String perfilId = pathElements[2];
            _model.userXGet(perfilId);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : PerfilPage(_model, false),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(_model));
        },
      ),
    );
  }
}
