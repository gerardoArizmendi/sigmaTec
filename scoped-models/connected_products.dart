import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../models/user.dart';
import '../models/perfil.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/auth.dart';

import '../models/product.dart';

mixin ConnectedModel on Model {
  Firestore firestore = Firestore();
  //Pestañas

  List<Product> _products = []; //Productos
  String _selProductId;

  //Ventanas
  String _selPerfilId;

  //Perfiles
  Perfil _userXReady;
  bool newUser = true;

  //Post
  String _selPostId;
  List<Comment> _fetchedComments = [];
  List<Post> _fetchedPosts = [];
  List<Post> _wallPosts = [];
  List<Post> _fetchedFaved = [];

  //Utility
  User _authenticatedUser;
  bool _isLoading = false;
  bool _know = false;
}

//===================================================================================================
//===================================================================================================
//===================================================================================================
//===================================================================================================
mixin FireData on ConnectedModel {
  bool _showPostFavoritos = false;

  //------------------Getters-------------------------

  Perfil get perfilXGet {
    return _userXReady;
  }

  void clearPerfilX(bool clear) {
    if (clear) {
      _userXReady = null;
    }
    clear = false;
  }

  void selectPerfil(String perfilId) {
    _selPerfilId = perfilId;
    notifyListeners();
  }

  String get userIdGet {
    return _authenticatedUser.id;
  }

  List<Comment> get commentsGet {
    return _fetchedComments;
  }

  List<Post> get postsGet {
    if (_showPostFavoritos) {
      return _fetchedPosts.where((Post post) => post.esFavorito).toList();
    }
    return _fetchedPosts;
  }

  List<Post> get postsFav {
    return _fetchedFaved;
  }

  void selectPost(String postId) {
    _selPostId = postId;
    notifyListeners();
  }

  String get selectedPostId {
    return _selPostId;
  }

  String get selectedPerfilId {
    return _selPerfilId;
  }

  int get selectedPostIndex {
    return _fetchedPosts.indexWhere((Post post) {
      return post.id == _selPostId;
    });
  }

  Post get selectedPost {
    if (selectedPostId == null) {
      return null;
    }

    return _fetchedPosts.firstWhere((Post post) {
      return post.id == _selPostId;
    });
  }

  void clearData(bool clear) {
    if (clear) {
      _fetchedPosts = [];
      _fetchedComments = [];
    }
    clear = false;
  }

  void clearPostSelected(bool clear) {
    if (clear) {
      _selPostId = null;
    }
    clear = false;
  }

  void clearComments(bool clear) {
    if (clear) {
      _fetchedComments = [];
    }
    clear = false;
  }

  void clearPosts(bool clear) {
    if (clear) {
      _fetchedPosts = [];
    }
    clear = false;
  }

  void isLoadingToggle(bool loading) {
    _isLoading = loading;
  }

  void esFavoritoList(List<String> idList, String userId) {
    //# TecSigma instances: idList.length

    //Prueba la carpeta Firebase/SIMAS/
    //    /idList[i]/'Favs'/'MeGusta'/

    _isLoading = true;
    notifyListeners();
    for (var i = 0; i < idList.length; i++) {
      print('getting Fav Status');
      isFavoriteStatus(idList[i], i, userId); //Query 'MeGusta' for each
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Null> isFavoriteStatus(id, index, userId) {
    return Firestore.instance
        .collection('/SIGMAS')
        .document(id)
        .collection('Favs')
        .document('MeGusta')
        .get()
        .then((value) {
      retrieveData(value, index, userId);
      return;
    });
  }

  retrieveData(doc, index, userId) async {
    DocumentSnapshot value = await doc;
    if (value.data == null) {
      _know = false; //Usar know to toggle favlist
      esFavorito(index, _know);
    } else {
      if (value.data.containsValue(userId)) {
        _know = true;
        esFavorito(index, _know);
      }
    }
  }

  void esFavorito(int index, know) {
    final Post updatedPost = Post(
      id: _fetchedPosts[index].id,
      titulo: _fetchedPosts[index].titulo,
      contenido: _fetchedPosts[index].contenido,
      fecha: _fetchedPosts[index].fecha,
      tipo: _fetchedPosts[index].tipo,
      imageUrl: _fetchedPosts[index].imageUrl,
      imagePath: _fetchedPosts[index].imagePath,
      link: _fetchedPosts[index].link,
      username: _fetchedPosts[index].username,
      userId: _fetchedPosts[index].userId,
      userImage: _fetchedPosts[index].userImage,
      esFavorito: know,
    );
    _fetchedPosts[index] = updatedPost;
    notifyListeners();
  }

  void toggleFavStaus(id, username, userId, know, type, documentId) async {
    _isLoading = true;
    notifyListeners();
    if (know) {
      Firestore.instance
          .collection('/SIGMAS')
          .document(id)
          .collection(type)
          .document(documentId)
          .updateData({'$userId': FieldValue.delete()});
    } else {
      Firestore.instance
          .collection('/SIGMAS')
          .document(id)
          .collection(type)
          .document(documentId)
          .setData({'$userId': userId}, merge: true);
    }

    _isLoading = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------------
  //-------------------------------Posts--------------------------------------
  //--------------------------------------------------------------------------

  Future<bool> storePost(String userId, String titulo, String contenido,
      String tipo, File image) async {
    // final uploadData = await uploadImage(image);

    // if (uploadData == null) {
    //   print('Upload failed');
    //   return false;
    // }

    DateTime _fechaOficial = DateTime.now();
    String _fecha = _fechaOficial.toString();
    Post newPost = Post(
        userId: userId,
        titulo: titulo,
        contenido: contenido,
        tipo: tipo,
        fecha:
            _fecha); //Todo nuevo post lo tendra, pero sera reemplazado por su id, when query.
    _fetchedPosts.add(newPost); //Updates Post wall
    notifyListeners();
    Firestore.instance.collection('/SIGMAS').document().setData({
      'userId': userId,
      'titulo': titulo,
      'contenido': contenido,
      'fecha': _fecha,
      'tipo': tipo,
      // image != null ? ({'imageUrl': uploadData['imageUrl'], 'imagenPath': uploadData['imagePath']}): 'imageUrl':null ,
    }).then((value) {});
    return true;
  }

  Future<Null> postGet({onlyForUser = false, onlyFor = false}) async {
    _isLoading = true;
    notifyListeners();
    clearData(true);
    Firestore.instance.collection('/SIGMAS').getDocuments().then((value) {
      getPostData(value, onlyForUser, onlyFor);
    }).catchError((e) {
      print(e);
    });
  }

  Future<Null> getPostData(QuerySnapshot data, onlyForUser, onlyFor) async {
    List<Map<dynamic, dynamic>> list;
    List<Post> _fetchedPostsNow = [];
    Iterable<String> ids;
    List<String> idsList = [];

    list = data.documents.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();
    ids = data.documents.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.documentID;
    }).toList();
    idsList = ids.toList();
    int i = 0;
    list.forEach((subject) {
      final Post post = Post(
        id: idsList[i++],
        titulo: subject['titulo'],
        contenido: subject['contenido'],
        fecha: subject['fecha'],
        tipo: subject['tipo'],
        imageUrl: subject['imageUrl'],
        imagePath: subject['imagePath'],
        link: subject['link'],
        userId: subject['userId'],
      );
      _fetchedPostsNow.add(post);
      _isLoading = false;
      notifyListeners();
    });
    _fetchedPosts = onlyForUser
        ? _fetchedPostsNow.where((Post post) {
            return post.userId == _authenticatedUser.id;
          }).toList()
        : onlyFor
            ? _fetchedPostsNow.where((Post post) {
                return post.userId == perfilXGet.id;
              }).toList()
            : _fetchedPostsNow;
  }

  Future<bool> deletePost() {
    _isLoading = true;
    final deletedProductId = selectedPost.id;
    _fetchedPosts.removeAt(selectedPostIndex);

    _selPostId = null;
    notifyListeners();
    return Firestore.instance
        .collection('/SIGMAS')
        .document(deletedProductId)
        .delete()
        .then((onValue) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
  }

  bool get displayFavotitosPost {
    return _showPostFavoritos;
  }

  void toggleFavPostMode() {
    _showPostFavoritos = !_showPostFavoritos;
    notifyListeners();
  }

  //-------------------------------------------------------------------------------------------
  //--------------------------------Comments-Fetched-------------------------------------------
  //-------------------------------------------------------------------------------------------
  Future<Null> commentsGetter() async {
    _isLoading = true;
    notifyListeners();
    String id = _selPostId;
    Firestore.instance
        .collection('/SIGMAS')
        .document(id)
        .collection('comentarios')
        .getDocuments()
        .then((value) {
      getComments(value.documents);
    }).catchError((e) {
      print('error: ');
      print(e);
    });
    _isLoading = false;
    notifyListeners();
  }

  Future<Null> getComments(List<DocumentSnapshot> data) async {
    List<Comment> _fetchedCommentsNow = [];
    data.forEach((subject) {
      final Comment comment = Comment(
        comentario: subject['comentario'],
        fecha: subject['fecha'],
        userId: subject['userId'],
      );
      _fetchedCommentsNow.add(comment);
      _fetchedComments = _fetchedCommentsNow;
      notifyListeners();
    });
  }

  void storeNewComment(id, comentario, context) {
    print(comentario);
    final String date = new DateTime.now().toString();
    print(date);
    _isLoading = true;
    notifyListeners();
    Comment newComment = Comment(
        comentario: comentario, userId: _authenticatedUser.id, fecha: date);
    _fetchedComments.add(newComment);
    notifyListeners();
    Firestore.instance
        .collection('/SIGMAS')
        .document(id)
        .collection('comentarios')
        .document(date)
        .setData({
      'comentario': comentario,
      'userId': _authenticatedUser.id,
      'fecha': date,
    }).then((value) {
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      print(e);
    });
  }
}

//=========================================================================================================
//=========================================================================================================
//=========================================================================================================
//=========================================================================================================
//=========================================================================================================
mixin FireUser on ConnectedModel {
  Future<Map<String, dynamic>> uploadImageUser(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST',
        Uri.parse('https://us-central1-t3c-inc.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong');
        print('error: ');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> storeUser(String nombre, String bio, String username,
      String campus, String carrera, int semestre, File image) async {
    final String email = _authenticatedUser.email;
    final String id = _authenticatedUser.id;
    String imageUrl;
    String imagePath;
    if (_authenticatedUser.imageUrl == null) {
      imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/t3c-inc.appspot.com/o/images%2Fno-image.jpg?alt=media&token=f2c97f47-4137-4484-bb56-4114747df84b';
      imagePath = 'images/no-image.jpg';
    } else {
      imageUrl = _authenticatedUser.imageUrl;
      imagePath = _authenticatedUser.imagePath;
    }

    if (image != null) {
      final uploadData = await uploadImageUser(image);
      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }

    Firestore.instance.collection('/Perfiles').document(id).updateData({
      'email': email,
      'id': id,
      'nombre': nombre,
      'bio': bio,
      'username': username,
      'campus': campus,
      'carrera': carrera,
      'semestre': semestre,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
    }).then((value) {
      _isLoading = false;
      print('Updated Perfil');
      print(imageUrl);
      notifyListeners();
      return true;
    }).catchError((e) {
      print('error StoreUser');
      print(e);
    });
    final User _userInfo = User(
      perfilId: id,
      email: email,
      id: _authenticatedUser.perfilId,
      token: _authenticatedUser.token,
      nombre: nombre,
      username: username,
      bio: bio,
      campus: campus,
      carrera: carrera,
      semestre: semestre,
      imageUrl: imageUrl,
      imagePath: imagePath,
    );
    _authenticatedUser = _userInfo;
    notifyListeners();
    return true;
  }

  //----------------------------------------------------------
  //------------------------Get-User--------------------------
  //----------------------------------------------------------

  Future<void> userAuthFetch() async {
    print('User ');
    _isLoading = true;
    notifyListeners();
    Firestore.instance
        .collection('/Perfiles')
        .document(_authenticatedUser.id)
        .get()
        .then((data) {
      print(data.data);
      if (data.data != null) {
        final User _userAuth = User(
          id: _authenticatedUser.id,
          email: _authenticatedUser.email,
          token: _authenticatedUser.token,
          nombre: data.data['nombre'],
          bio: data.data['bio'],
          username: data.data['username'],
          carrera: data.data['carrera'],
          campus: data.data['campus'],
          semestre: data.data['semestre'],
          imageUrl: data.data['imageUrl'],
          imagePath: data.data['imagePath'],
          perfilId: data.documentID,
        );
        _authenticatedUser = _userAuth;
        notifyListeners();
      }
    });
  }

  //Get a random User.
  Future<void> userXGet(String id) async {
    print('UserX');
    _isLoading = true;
    notifyListeners();
    Firestore.instance
        .collection('/Perfiles')
        .where('id', isEqualTo: id)
        .snapshots()
        .listen((data) {
      getPerfilData(data, false);
    });
    _isLoading = false;
    notifyListeners();
  }

  void getPerfilData(QuerySnapshot data, bool authUser) {
    final Perfil _userInfo = Perfil(
      id: data.documents[0].documentID,
      nombre: data.documents[0]['nombre'],
      bio: data.documents[0]['bio'],
      username: data.documents[0]['username'],
      carrera: data.documents[0]['carrera'],
      campus: data.documents[0]['campus'],
      semestre: data.documents[0]['semestre'],
      imageUrl: data.documents[0]['imageUrl'],
      imagePath: data.documents[0]['imagePath'],
      userEmail: data.documents[0]['email'],
      userId: _authenticatedUser.id,
    );
    _userXReady = _userInfo;
    notifyListeners();
  }

  void selectPerfil(String perfilId) {
    _selPerfilId = perfilId;
    notifyListeners();
  }
}

//=========================================================================================================
//=========================================================================================================
//=========================================================================================================
//=========================================================================================================
//=========================================================================================================
mixin FireFollow on ConnectedModel {
  int _following;
  DocumentSnapshot _followingList;
  int _followers;
  DocumentSnapshot _followersList;

  int get following {
    return _following;
  }

  int get followers {
    return _followers;
  }

  DocumentSnapshot get followingList {
    return _followingList;
  }

  List get followersList {
    return _followersList.data.values.toList();
  }

  Future<Null> postWallGet() async {
    _isLoading = true;
    notifyListeners();
    Firestore.instance.collection('/SIGMAS').getDocuments().then((value) {
      getPostList(value, true);
    }).catchError((e) {
      print(e);
    }).then((onValue) {
      defineWallPosts(_fetchedPosts);
    });
  }

  Future<Null> getPostList(QuerySnapshot data, onlyForFollowing) async {
    List<Map<dynamic, dynamic>> list;
    List<Post> _fetchedPostsNow = [];
    Iterable<String> ids;
    List<String> idsList = [];

    list = data.documents.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();
    ids = data.documents.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.documentID;
    }).toList();
    idsList = ids.toList();
    int i = 0;
    list.forEach((subject) {
      final Post post = Post(
        id: idsList[i++],
        titulo: subject['titulo'],
        contenido: subject['contenido'],
        fecha: subject['fecha'],
        tipo: subject['tipo'],
        imageUrl: subject['imageUrl'],
        imagePath: subject['imagePath'],
        link: subject['link'],
        userId: subject['userId'],
      );
      _fetchedPostsNow.add(post);
      _isLoading = false;
      notifyListeners();
    });
    _fetchedPosts = _fetchedPostsNow;
  }

  void defineWallPosts(List<Post> newWall) {
    _isLoading = true;
    notifyListeners();
    _wallPosts = newWall;
    _isLoading = false;
    notifyListeners();
  }

  List<Post> get wallPost {
    print('WallPosts');
    return _wallPosts;
  }

  void toggleFollowStaus(id, know, activity, documentId) async {
    String userId = _authenticatedUser.id;
    _isLoading = true;
    notifyListeners();
    if (know) {
      Firestore.instance
          .collection('/Perfiles')
          .document(id)
          .collection(activity)
          .document(documentId)
          .updateData({'$userId': FieldValue.delete()});
    } else {
      Firestore.instance
          .collection('/Perfiles')
          .document(id)
          .collection(activity)
          .document(documentId)
          .setData({'$userId': userId}, merge: true);
    }
    _isLoading = false;
    notifyListeners();
    updateFollowList(userId, id, know, 'Activity', 'Following');
  }

  void updateFollowList(id, userId, know, activity, documentId) async {
    _isLoading = true;
    notifyListeners();

    if (know) {
      Firestore.instance
          .collection('/Perfiles')
          .document(id)
          .collection(activity)
          .document(documentId)
          .updateData({'$userId': FieldValue.delete()});
    } else {
      Firestore.instance
          .collection('/Perfiles')
          .document(id)
          .collection(activity)
          .document(documentId)
          .setData({'$userId': userId}, merge: true);
    }
    _isLoading = false;
    notifyListeners();
  }

  //-------------------------------------------------------------
  //-------------------------------------------------------------
  //-------------------------------------------------------------

  void followersStatus(userId) {
    _isLoading = true;
    notifyListeners();
    Firestore.instance
        .collection('/Perfiles')
        .document(userId)
        .collection('Activity')
        .document('Followers')
        .get()
        .then((value) {
      retrieveFollowers(value, userId);
    });
    _isLoading = false;
    notifyListeners();
  }

  retrieveFollowers(doc, userId) async {
    DocumentSnapshot val = await doc;
    if (val.data == null) {
      _followers = 0; //Usar know to toggle favlist
    } else {
      _followersList = val;
      _followers = _followersList.data.length;
      notifyListeners();
    }
  }

  //-------------------------------------------------------------
  //-------------------------------------------------------------
  //-------------------------------------------------------------
  void followingStatus(userId) {
    _isLoading = true;
    notifyListeners();
    Firestore.instance
        .collection('/Perfiles')
        .document(userId)
        .collection('Activity')
        .document('Following')
        .get()
        .then((value) {
      retrieveFollowing(value, userId);
    });
    _isLoading = false;
    notifyListeners();
  }

  retrieveFollowing(doc, userId) async {
    print('Fetching Following:');
    DocumentSnapshot val = await doc;
    if (val.data == null) {
      _following = 0; //Usar know to toggle favlist
    } else {
      _followingList = val;
      _following = _followingList.data.length;
      notifyListeners();
    }
  }
}

//=========================================================================================================
//=========================================================================================================
//=========================================================================================================
//=========================================================================================================
//=========================================================================================================

mixin FireAuth on ConnectedModel {
  Timer _fireAuthTimer;
  PublishSubject<bool> _fireUserSubject = PublishSubject();

  User get authUser {
    return _authenticatedUser;
  }

  Perfil get authUserToPerfil {
    Perfil _perfil = Perfil(
      id: _authenticatedUser.perfilId,
      userEmail: _authenticatedUser.email,
      userId: _authenticatedUser.id,
      nombre: _authenticatedUser.nombre,
      username: _authenticatedUser.username,
      bio: _authenticatedUser.bio,
      campus: _authenticatedUser.campus,
      carrera: _authenticatedUser.carrera,
      semestre: _authenticatedUser.semestre,
      imageUrl: _authenticatedUser.imageUrl,
      imagePath: _authenticatedUser.imagePath,
    );
    return _perfil;
  }

  PublishSubject<bool> get fireUserSubject {
    return _fireUserSubject;
  }

  void initiateFacebookLogin(BuildContext context) async {
    // _isLoading = true;
    // notifyListeners();
    print("Inside Facebook");
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(800).height(800)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookLoginResult.accessToken.token);
        FirebaseAuth.instance.signInWithCredential(credential);
        final User _userAuth = User(
            id: profile['id'],
            email: profile['email'],
            token: facebookLoginResult.accessToken.token,
            nombre: profile['name'],
            imageUrl: profile['picture']['data']['url']);
        print(_userAuth.id);
        Query fetch = Firestore.instance
            .collection('/Perfiles')
            .where('id', isEqualTo: _userAuth.id);
        QuerySnapshot fetchedSnaps = await fetch.getDocuments();
        if (fetchedSnaps.documents.length == 0) {
          print("Empty");
          Firestore.instance
              .collection('/Perfiles')
              .document(_userAuth.id)
              .setData({
            'email': _userAuth.email,
            'id': _userAuth.id,
            'imageUrl':_userAuth.imageUrl,
          });
          Navigator.pushReplacementNamed(context, '/editPerfil');
        }
        _authenticatedUser = _userAuth;
        _fireUserSubject.add(true);
        // _isLoading = false;
        // notifyListeners();
        print(_authenticatedUser.email);
        break;
      default:
        print("default");
    }
  }

  Future registration(
      String _email, String _password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    print(_email);
    firestore.settings(timestampsInSnapshotsEnabled: true);
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .then((FirebaseUser user) async {
      var tokenRAW = user.getIdToken();
      String token = await tokenRAW;
      _authenticatedUser = User(id: user.uid, email: user.email, token: token);
      _fireUserSubject.add(true);
      _isLoading = false;
      notifyListeners();
      print('------New-User-------');
      print(_authenticatedUser.email);
      print(_authenticatedUser.token);
      print('Under:');
      Firestore.instance
          .collection('/Perfiles')
          .document(_authenticatedUser.id)
          .setData({'email': _email, 'id': _authenticatedUser.id});
      Navigator.pushReplacementNamed(context, '/editPerfil');
    }).catchError((e) {
      print(e);
      String errorType = 'Error';
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = 'El Email no existe';
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = 'La contraseña no es la correcta';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = 'Algun error';
          break;
        case 'The email address is already in use by another account.':
          errorType = 'El email ya esta siendo usado';
          break;
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Un Error ocurrio"),
              content: Text(errorType),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    _isLoading = false;
                    notifyListeners();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      _isLoading = false;
      notifyListeners();
    });
  }

  Future authentication(
      String _email, String _password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    print(_email);
    firestore.settings(timestampsInSnapshotsEnabled: true);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((FirebaseUser user) async {
      var tokenRAW = user.getIdToken();
      String token = await tokenRAW;
      _authenticatedUser = User(id: user.uid, email: user.email, token: token);
      _fireUserSubject.add(true);
      newUser = false;
      _isLoading = false;
      notifyListeners();
      print('---------User--------');
      print(_authenticatedUser.email);
      print(_authenticatedUser.token);
      // print('Over:');
      // Navigator.pushReplacementNamed(context, '/');
    }).catchError((e) {
      String errorType = 'Error';
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = 'El Email no existe';
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = 'La contraseña no es la correcta';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = 'Algun error';
          break;
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Un Error ocurrio"),
              content: Text(errorType),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    _isLoading = false;
                    notifyListeners();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      _isLoading = false;
      notifyListeners();
    });
  }

  bool get newUserStat {
    return newUser;
  }

  void firelogout() async {
    FirebaseAuth.instance.signOut();
    _authenticatedUser = null;
    _fireUserSubject.add(false);
    _fireAuthTimer.cancel();
    _selPerfilId = null;
    _selProductId = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    _isLoading = false;
    notifyListeners();
  }

  void setAuthTimeout(int time) {
    final time = 2;
    _fireAuthTimer = Timer(Duration(days: time), firelogout);
  }
}

//===================================================================================================
//===================================================================================================
//-----------------------------------------Principal-Productos---------------------------------------
//===================================================================================================
//===================================================================================================
mixin ProductsModel on ConnectedModel {
  bool _showProductsFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showProductsFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }

    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesProductsOnly {
    return _showProductsFavorites;
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST',
        Uri.parse('https://us-central1-t3c-inc.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addProduct(
      String title, String description, File image, double price) async {
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);

    if (uploadData == null) {
      print('Upload failed!');
      return false;
    }

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      // 'imagePath': uploadData['imagePath'],
      // 'imageUrl': uploadData['imageUrl'],
    };
    try {
      final http.Response response = await http.post(
          'https://t3c-inc.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: 'UploadData URL',
          imagePath: 'UploadDara Path',
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<bool> updateProduct(
      String title, String description, File image, double price) async {
    _isLoading = true;
    notifyListeners();
    String imageUrl = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);

      if (uploadData == null) {
        print('Upload failed!');
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    try {
      final http.Response response = await http.put(
          'https://t3c-inc.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: imageUrl,
          imagePath: imagePath,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      print(response);
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://t3c-inc.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts({onlyForUser = false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://t3c-inc.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['imageUrl'],
            imagePath: productData['imagePath'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id));
        fetchedProductList.add(product);
      });
      _products = onlyForUser
          ? fetchedProductList.where((Product product) {
              return product.userId == _authenticatedUser.id;
            }).toList()
          : fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      print('error products');
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        imagePath: selectedProduct.imagePath,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://t3c-inc.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://t3c-inc.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          imagePath: selectedProduct.imagePath,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteStatus);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
    _selProductId = null;
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showProductsFavorites = !_showProductsFavorites;
    notifyListeners();
  }
}

//-------Utility-Model---------------------Works-GOOD----
//-------Se encarga de conocer si hay un proceso cargando
//-------------------------------------------------------

mixin UtilityModel on ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}

//-------User-Model------------------------Works-GOOD----
//-------Se encarga de los asuntos del usuario-----------
//-------Autenticacion-----------------------------------
//-------Log-Out-----------------------------------------
//-------Time Signed Up----------------------------------

mixin UserModel on ConnectedModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDIPBHyX22JwNw_AOGMrTwDaXDPkAyGKKw',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDIPBHyX22JwNw_AOGMrTwDaXDPkAyGKKw',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Algo salio mal.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Autenticacion exitosa.';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Ya existe este Email.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'No se encontro este Email.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'El password es invalido';
    }
    _isLoading = false;
    notifyListeners();
    return {'succes': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    _selPerfilId = null;
    _selProductId = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    final time = 2;
    _authTimer = Timer(Duration(days: time), logout);
  }
}
