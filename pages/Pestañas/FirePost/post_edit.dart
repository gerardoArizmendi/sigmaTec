import 'package:flutter/material.dart';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:sigma_tec/models/post.dart';

import '../../formatos/helpers/ensure_visible.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../scoped-models/mains.dart';

//import '../../formatos/form_inputs/imagePick.dart';

class PostEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostEditPageState();
  }
}

class _PostEditPageState extends State<PostEditPage> {
  final Map<String, dynamic> _formData = {
    'titulo': null,
    'contenido': null,
    'tipo': null,
    'fecha': null,
    'image': null,
    'sticker': null,
  };

  String _tipo;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _stickerFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _titleTextController = TextEditingController();
  final _stickerTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  Widget _cajonTitulo(Post post) {
    if (post == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (post != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = post.titulo;
    } else if (post != null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else if (post == null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else {
      _titleTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Titulo del Post'),
        controller: _titleTextController,
        // initialValue: product == null ? '' : product.title,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 5) {
            return 'El titulo requiere ser +5 caracteres.';
          }
        },
        onSaved: (String value) {
          _formData['titulo'] = value;
        },
      ),
    );
  }

  Widget _cajonContenido(Post post) {
    if (post == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (post != null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = post.contenido;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(labelText: 'Descripción del Post'),
        // initialValue: product == null ? '' : product.description,
        controller: _descriptionTextController,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 10) {
            return 'El contenido requiere ser +10 caracteres.';
          }
        },
        onSaved: (String value) {
          _formData['contenido'] = value;
        },
      ),
    );
  }

  Widget _estampadoOriginal(Post post, User perfil) {
    if (post == null && _stickerTextController.text.trim() == '') {
      _stickerTextController.text = '';
    } else if (post != null && _stickerTextController.text.trim() == '') {
      _stickerTextController.text = post.titulo;
    } else if (post != null && _stickerTextController.text.trim() != '') {
      _stickerTextController.text = _stickerTextController.text;
    } else if (post == null && _stickerTextController.text.trim() != '') {
      _stickerTextController.text = _stickerTextController.text;
    } else {
      _stickerTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _stickerFocusNode,
      child: TextFormField(
        focusNode: _stickerFocusNode,
        decoration: InputDecoration(labelText: 'Sticker'),
        controller: _stickerTextController,
        // initialValue: product == null ? '' : product.title,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 5) {
            return 'El titulo requiere ser +5 caracteres.';
          }
        },
        onSaved: (String value) {
          _formData['sticker'] = value;
          _stickerTextController.text = value;
        },
      ),
    );
  }

  Widget _buildTipoTextField() {
    final List<String> tipo = <String>[
      'LiFE',
      'DEPORTES',
      'NOTICIAS',
      'TALLERES',
      'GRUPOS',
      'JustForFun',
      'RECOMENDACIONES',
      'OTRO',
    ];
    if (_tipo == null) {
      _tipo = 'Tipo: ';
      print(_tipo);
    }
    return Row(children: <Widget>[
      DropdownButton<String>(
        items: tipo.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        iconSize: 30.0,
        hint: Text(_tipo),
        onChanged: (tipo) {
          setState(() {
            _tipo = tipo;
            _formData['tipo'] = _tipo;
          });
          print(_tipo);
        },
      ),
    ]);
  }

  Widget _buildPageContent(BuildContext context, Post post, User perfil) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
          margin: EdgeInsets.all(10.0),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                children: <Widget>[
                  _cajonTitulo(post),
                  _cajonContenido(post),
                  SizedBox(
                    height: 10.0,
                  ),
                  _estampadoOriginal(post, perfil),
                  // LocationInput(_setLocation, product),
                  //SizedBox(height: 10.0),
                  // ImageInput(post, _setImage),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildTipoTextField(),
                  _buildSubmitButton(perfil),
                  // GestureDetector(
                  //   onTap: _submitForm,
                  //   child: Container(
                  //     color: Colors.green,
                  //     padding: EdgeInsets.all(5.0),
                  //     child: Text('My Button'),
                  //   ),
                  // )
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildSubmitButton(User perfil) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text('Guardar'),
                textColor: Colors.white,
                onPressed: () {
                  _submitForm(model.storePost, model.selectPost, perfil,
                      model.selectedPostIndex);
                  model.postGet();
                });
      },
    );
  }

  // void _setImage(File image) {
  //   _formData['image'] = image;
  // }

  void _submitForm(Function storeNewPost, Function setSelectedPost, User user,
      [int selectedPostIndex]) {
    if (!_formKey.currentState.validate()) {
      print('not abel');
      print(_formKey.currentState.validate().toString());
      return;
    }
    _formKey.currentState.save();
    if (selectedPostIndex == -1) {
      print('about to safe');
      storeNewPost(
              user.id,
              _titleTextController.text,
              _descriptionTextController.text,
              _tipo,
              _formData['image'])
          .then((bool success) {
        if (success) {
          Navigator.pop(context, false);
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Algo salio mal :('),
                  content: Text('Vuelve a intentarlo'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedPost, model.authUser);

        return WillPopScope(
            onWillPop: () {
              print('Back button pressed!');
              Navigator.pop(context, false);
              model.clearPostSelected(true);
              return Future.value(false);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Edita producto'),
              ),
              body: pageContent,
            ));
      },
    );
  }
}
