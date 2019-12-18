import 'package:flutter/material.dart';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';

import '../../../models/perfil.dart';
import '../../../scoped-models/mains.dart';
import '../../formatos/helpers/ensure_visible.dart';
import '../../formatos/form_inputs/image.dart';

class PerfilEdit extends StatefulWidget {
  final MainModel model;
  final String userId;

  PerfilEdit(this.model, this.userId);

  @override
  State<StatefulWidget> createState() {
    return _PerfilEditState();
  }
}

class _PerfilEditState extends State<PerfilEdit> {
  final Map<String, dynamic> _formData = {
    'nombre': null,
    'username': null,
    'bio': null,
    'carrera': null,
    'semestre': 0,
    'image': null,
    'userImage': null
  };
  bool newUser = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nombreFocusNode = FocusNode();
  final _nombreTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _usernameTextController = TextEditingController();
  final _semestreFocusNode = FocusNode();
  final _carreraFocusNode = FocusNode();
  final _carreraTextController = TextEditingController();
  final _campusFocusNode = FocusNode();
  final _campusTextController = TextEditingController();

  Widget _buildNombreTextField(Perfil perfil) {
    if (perfil == null && _nombreTextController.text.trim() == '') {
      _nombreTextController.text = '';
      newUser = true;
    } else if (perfil != null && _nombreTextController.text.trim() == '') {
      _nombreTextController.text = perfil.nombre;
    } else if (perfil != null && _nombreTextController.text.trim() != '') {
      _nombreTextController.text = _nombreTextController.text;
    } else if (perfil == null && _nombreTextController.text.trim() != '') {
      _nombreTextController.text = _nombreTextController.text;
    } else {
      _nombreTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
        focusNode: _nombreFocusNode,
        child: TextFormField(
          focusNode: _nombreFocusNode,
          decoration: InputDecoration(
              labelText: 'tu nombre',
              border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0))),
          controller: _nombreTextController,
          // initialValue: perfil == null ? '' : perfil.title,
          validator: (String value) {
            // if (value.trim().length <= 0) {
            if (value.isEmpty || value.length < 5) {
              return 'Tu nombre requiere ser +5 caracteres.';
            } else {
              return '';
            }
          },
          onSaved: (String value) {
            _formData['nombre'] = value;
          },
        ));
  }

  Widget _buildBioTextField(Perfil perfil) {
    if (perfil == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (perfil != null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = perfil.bio;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(
            labelText: 'Bio: ¿a que te dedicas?',
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0))),
        // initialValue: perfil == null ? '' : perfil.description,
        controller: _descriptionTextController,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 10) {
            return 'Tu bio requiere ser +5 caracteres.';
          } else {
            return '';
          }
        },
        onSaved: (String value) {
          _formData['bio'] = value;
        },
      ),
    );
  }

  Widget _buildUsernameTextField(Perfil perfil) {
    if (perfil == null && _usernameTextController.text.trim() == '') {
      _usernameTextController.text = '';
    } else if (perfil != null && _usernameTextController.text.trim() == '') {
      _usernameTextController.text = perfil.username;
    } else if (perfil != null && _usernameTextController.text.trim() != '') {
      _usernameTextController.text = _usernameTextController.text;
    } else if (perfil == null && _usernameTextController.text.trim() != '') {
      _usernameTextController.text = _usernameTextController.text;
    } else {
      _usernameTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _usernameFocusNode,
      child: TextFormField(
        focusNode: _usernameFocusNode,
        decoration: InputDecoration(
            labelText: 'username',
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0))),
        controller: _usernameTextController,
        // initialValue: perfil == null ? '' : perfil.title,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 5) {
            return 'Tu nombre requiere ser +5 caracteres.';
          } else {
            return '';
          }
        },
        onSaved: (String value) {
          _formData['username'] = value;
        },
      ),
    );
  }

  Widget _buildCampusField(Perfil perfil) {
    if (perfil == null && _campusTextController.text.trim() == '') {
      _campusTextController.text = '';
    } else if (perfil != null && _campusTextController.text.trim() == '') {
      _campusTextController.text = perfil.campus;
    } else if (perfil != null && _campusTextController.text.trim() != '') {
      _campusTextController.text = _campusTextController.text;
    } else if (perfil == null && _campusTextController.text.trim() != '') {
      _campusTextController.text = _campusTextController.text;
    } else {
      _campusTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _campusFocusNode,
      child: TextFormField(
        focusNode: _campusFocusNode,
        decoration: InputDecoration(
            labelText: 'campus',
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0))),
        controller: _campusTextController,
        // initialValue: perfil == null ? '' : perfil.title,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length > 4) {
            return 'Tu campus requiere ser 3 caracteres.';
          } else {
            return '';
          }
        },
        onSaved: (String value) {
          _formData['campus'] = value;
        },
      ),
    );
  }

  Widget _buildCarreraField(Perfil perfil) {
    if (perfil == null && _carreraTextController.text.trim() == '') {
      _carreraTextController.text = '';
    } else if (perfil != null && _carreraTextController.text.trim() == '') {
      _carreraTextController.text = perfil.carrera;
    } else if (perfil != null && _carreraTextController.text.trim() != '') {
      _carreraTextController.text = _carreraTextController.text;
    } else if (perfil == null && _carreraTextController.text.trim() != '') {
      _carreraTextController.text = _carreraTextController.text;
    } else {
      _carreraTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _carreraFocusNode,
      child: TextFormField(
        focusNode: _carreraFocusNode,
        decoration: InputDecoration(
            labelText: 'carrera - Ej: ITC',
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0))),
        controller: _carreraTextController,
        // initialValue: perfil == null ? '' : perfil.title,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length > 4) {
            return 'Tu carrera requiere ser 3 caracteres.';
          } else {
            return '';
          }
        },
        onSaved: (String value) {
          _formData['carrera'] = value;
        },
      ),
    );
  }

  Widget _buildSemestreField(Perfil perfil) {
    return EnsureVisibleWhenFocused(
      focusNode: _semestreFocusNode,
      child: TextFormField(
        focusNode: _semestreFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Semestre actual',
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0))),
        initialValue: perfil.semestre == null ? '' : perfil.semestre.toString(),
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'Requiere ser un numero.';
          } else {
            return '';
          }
        },
        onSaved: (String value) {
          _formData['semestre'] = int.parse(value);
        },
      ),
    );
  }

  Widget _buildSubmitButton(Perfil perfil) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text('Guardar'),
                textColor: Colors.white,
                onPressed: () {
                  if (!model.newUserStat) {
                    if (_formData['image'] == null && perfil.imageUrl != null) {
                      _formData['userImage'] = perfil.imageUrl;
                    }
                  }
                  _submitForm(model.storeUser, model.newUserStat);
                  model.userAuthFetch();
                });
      },
    );
  }

  void _submitForm(Function updatePerfil, bool newUser) {
    _formKey.currentState.save();
    updatePerfil(
      _nombreTextController.text,
      _descriptionTextController.text,
      _usernameTextController.text,
      _campusTextController.text,
      _carreraTextController.text,
      _formData['semestre'],
      _formData['image'],
    );
    newUser ? Navigator.pushReplacementNamed(context, '/') : Navigator.pop(context);
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  Widget _buildPageContent(BuildContext context, Perfil perfil) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              ImageInput(_setImage, null, perfil),
              _buildNombreTextField(perfil),
              SizedBox(height: 10.0),
              _buildBioTextField(perfil),
              SizedBox(height: 10.0),
              _buildUsernameTextField(perfil),
              SizedBox(height: 10.0),
              _buildCampusField(perfil),
              SizedBox(height: 10.0),
              _buildCarreraField(perfil),
              SizedBox(height: 10.0),
              _buildSemestreField(perfil),
              // LocationInput(_setLocation, perfil),
              //SizedBox(height: 10.0),
              SizedBox(height: 10.0),
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
      ),
    );
  }

  // void _submitForm(
  //     Function addProduct, Function updateProduct, Function setSelectedProduct,
  //     [int selectedProductIndex]) {
  //   if (!_formKey.currentState.validate() ||
  //       (_formData['image'] == null && selectedProductIndex == -1)) {
  //     return;
  //   }
  //   _formKey.currentState.save();
  //   if (selectedProductIndex == -1) {
  //     addProduct(_nombreTextController.text, _descriptionTextController.text,
  //         _formData['image'], _formData['price']).then((bool success) {
  //       if (success) {
  //         Navigator
  //             .pushReplacementNamed(context, '/products')
  //             .then((_) => setSelectedProduct(null));
  //       } else {
  //         showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: Text('Algo salio mal :('),
  //                 content: Text('Vuelve a intentarlo'),
  //                 actions: <Widget>[
  //                   FlatButton(
  //                     onPressed: () => Navigator.of(context).pop(),
  //                     child: Text('Okay'),
  //                   )
  //                 ],
  //               );
  //             });
  //       }
  //     });
  //   } else {
  //     updateProduct(
  //       _nombreTextController.text,
  //       _descriptionTextController.text,
  //       _formData['image'],
  //       _formData['price'],
  //     ).then((_) => Navigator
  //         .pushReplacementNamed(context, '/products')
  //         .then((_) => setSelectedProduct(null)));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.authUserToPerfil);
      return Scaffold(
        appBar: AppBar(
          title: Text('Edita producto'),
        ),
        body: pageContent,
      );
    });
  }
}

// void _submitData() {
//   Firestore.instance
//       .collection('/Perfiles')
//       .document(userInfo['id'])
//       .updateData({
//     'id': userInfo['id'],
//     'username': _username,
//     'about': _about,
//     'carrera': _carrera,
//     'campus': _campus,
//     'semestre': _semestre,
//   }).then((value) {
//     print(_username);
//     //something
//   }).catchError((e) {
//     print(e);
//   });
// }
