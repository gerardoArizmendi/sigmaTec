import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../AboutUs/introCard.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() {
    return _IntroState();
  }
}

class _IntroState extends State<Intro> {
  //Facebook
  // FacebookLogin fbLogin = new FacebookLogin();

  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          elevation: 0,
          title: Text('T3C.inc'),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Swiper(
              itemBuilder: (BuildContext context, int index) =>
                  IntroCard(index),
              itemCount: 3,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
          ),
          Container(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                child: Text('Más sobre T3C'),
                color: Colors.white,
                highlightColor: Colors.black,
                textColor: Colors.black,
                elevation: 7.0,
                onPressed: () {
                  Navigator.pushNamed(context, '/chart');
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                child: Text('Continuar'),
                color: Colors.white,
                highlightColor: Colors.black,
                textColor: Colors.black,
                elevation: 7.0,
                onPressed: () {
                  Navigator.pushNamed(context, '/authPage');
                },
              ),
              SizedBox(
                height: 50.0,
              )
            ],
          ))
        ]));
  }
}
