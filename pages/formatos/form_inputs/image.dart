import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../../../models/post.dart';
import '../../../models/perfil.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Post post;
  final Perfil perfil;

  ImageInput(this.setImage, this.post, this.perfil);

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                'Selecciona Imagen',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Camara'),
                onPressed: () {
                  _getImage(context, ImageSource.camera);
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Galeria'),
                onPressed: () {
                  _getImage(context, ImageSource.gallery);
                },
              )
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).primaryColor;
    Widget previewImage = Text('Escoge una Imagen');
    if (_imageFile != null) {
      previewImage = Image.file(
        _imageFile,
        fit: BoxFit.cover,
        height: 300.0,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
      );
      // } else if (widget.post != null) {
      //   previewImage = Image.network(
      //     widget.post.imageUrl,
      //     fit: BoxFit.cover,
      //     height: 300.0,
      //     width: MediaQuery.of(context).size.width,
      //     alignment: Alignment.topCenter,
      //   );
    } else if (widget.perfil.imageUrl != null) {
      previewImage = Image.network(
        widget.perfil.imageUrl,
        fit: BoxFit.cover,
        height: 300.0,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
      );
    }

    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: buttonColor,
            width: 2.0,
          ),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: buttonColor,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Agregá una Imagen',
                style: TextStyle(color: buttonColor),
              )
            ],
          ),
        ),
        SizedBox(height: 10.0),
        previewImage
        // _imageFile == null
        //     ? Text('Please pick an image.')
        //     :
      ],
    );
  }
}
