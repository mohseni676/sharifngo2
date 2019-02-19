import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:sharifngo/classes/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as PATH;
import 'package:sharifngo/home.dart';

import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

//import 'package:http/';

void main() async {
  Permission permission;
  //final res = await SimplePermissions.requestPermission(permission);

  runApp(new MaterialApp(
    title: 'SharifMD',
    home: new program(),
    theme: new ThemeData(primaryColor: Colors.red, fontFamily: 'Yekan'),
    debugShowCheckedModeBanner: false,
  ));
}

class program extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new programState();
  }
}

class programState extends State<program> {

  var _userName=new TextEditingController();
  var _passWord=new TextEditingController();
  bool _inProgress=false;

  GlobalKey<ScaffoldState> _globalKey=new GlobalKey();
  var _formGlobalKey=new GlobalKey<FormState>();
 // bool _isSaved=false;
   final FocusNode _userFocus=new FocusNode();
   final FocusNode _passFocus=new FocusNode();

  Future<void> _checkLogin() async {
    setState(() {
      _inProgress=true;
    });
    var response=await http.post(
        'http://soft.sharifngo.com:8020/token',
        body: {
          'username':_userName.text,
          'password':_passWord.text,
          'grant_type':'password'
        }
    ).timeout(Duration(seconds: 15),onTimeout: (){
      setState(() {
        _inProgress=false;
        final snackBar = SnackBar(content: Text('ارتباط با سرور بر قرار نشد، فیلترشکن را قطع کنید و یا اتصال اینترنت خود را بررسی کنید.',
          textAlign: TextAlign.center,
          textScaleFactor: 0.9,
          style: TextStyle(
              fontFamily: 'Yekan'
          ),
        ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 7),

        );
        //_passWord.text='';
        //_userName.text='';

// Find the Scaffold in the Widget tree and use it to show a SnackBar
        _globalKey.currentState.showSnackBar(snackBar);
        return;
      });
    });

    if (response.statusCode==200){
      var jsresponse=json.decode(response.body);
      globals.token=jsresponse['access_token'].toString();
      globals.tokenExpireTime=int.tryParse(jsresponse['expires_in'].toString());
      //debugPrint(globals.token);
      //debugPrint(globals.tokenExpireTime.toString());


        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context)=>home()));


    }else{
      debugPrint('Error');
      setState(() {
        _inProgress=false;
        final snackBar = SnackBar(content: Text('نام و نام کاربری اشتباه است',
        textAlign: TextAlign.center,
          textScaleFactor: 1.2,
          style: TextStyle(
            fontFamily: 'Yekan'
          ),
        ),
        backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),

        );
        _passWord.text='';
        _userName.text='';

// Find the Scaffold in the Widget tree and use it to show a SnackBar
        _globalKey.currentState.showSnackBar(snackBar);
      });
    }

  }
  List<Widget> _buildContex(BuildContext context){
    var content= Center(
      child: new ListView(
        padding: EdgeInsets.only(right: 25.0, left: 25.0,top: 35.0),
        children: <Widget>[
          new Hero(
              tag: 'Logo',
              child: CircleAvatar(
                child: new Image.asset('assets/images/Logo.png'),
                backgroundColor: Colors.white70,
                radius: 80.0,
              )),
          new Column(
            children: <Widget>[
              Form(
                  key: _formGlobalKey,
                  child: new Column(

                    children: <Widget>[
                      new SizedBox(
                        height: 22.0,
                      ),
                      new TextFormField(

                        controller: _userName=new TextEditingController(),
                        validator: (value){
                          if(value.isEmpty)
                            return 'نام کاربری را وارد کنید';
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),

                          ),
                          hintText: 'نام کاربری',
                          prefixIcon: new Icon(Icons.verified_user),


                        ),
                        textAlign: TextAlign.center,
                        focusNode: _userFocus,
                        onFieldSubmitted: (fed){
                          _userFocus.unfocus();
                          FocusScope.of(context).requestFocus(_passFocus);
                        },

                      ),
                      new SizedBox(
                        height: 12.0,
                      ),
                      new TextFormField(
                        controller: _passWord,
                        validator: (value){
                          if(value.isEmpty)
                            return 'رمز عبور را وارد کنید';
                        },
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),

                          ),
                          hintText: 'رمز عبور',
                          prefixIcon: new Icon(Icons.vpn_key),

                        ),
                        textAlign: TextAlign.center,
                        obscureText: true,
                        focusNode: _passFocus,
                        onFieldSubmitted: (fed){
                          _passFocus.unfocus();
                          if (_formGlobalKey.currentState.validate()){
                            _checkLogin();
                          }
                        },

                      ),

                      new SizedBox(
                        height: 10.0,
                      ),
                      new RaisedButton(onPressed: (){
                        if (_formGlobalKey.currentState.validate()){
                          _checkLogin();
                        }

                      },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        color: Colors.green,
                        highlightColor: Colors.red,
                        textTheme: ButtonTextTheme.primary,
                        padding: EdgeInsets.all(18.0),
                        child: new Text('ورود به سیستم'),
                      ),


                    ],
                  ))

            ],
          )
        ],
      ),
    );
    var l=new List<Widget>();
    l.add(content);
    if (_inProgress){
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      l.add(modal);
    }
    return l;

  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return new Directionality(
        textDirection: TextDirection.rtl,
        child: new Scaffold(
          key: _globalKey,
          appBar: new AppBar(
            title: new Text('بنیاد نیکوکاران شریف'),
            centerTitle: true,
          ),
          body:
            new Stack(
              children: _buildContex(context),
            )
          /*new Center(
            child: new ListView(
              padding: EdgeInsets.only(right: 25.0, left: 25.0,top: 35.0),
              children: <Widget>[
                new Hero(
                    tag: 'Logo',
                    child: CircleAvatar(
                      child: new Image.asset('assets/images/Logo.png'),
                      backgroundColor: Colors.white70,
                      radius: 80.0,
                    )),
                new Column(
                  children: <Widget>[
                    Form(
                        key: _formGlobalKey,
                        child: new Column(

                      children: <Widget>[
                        new SizedBox(
                          height: 22.0,
                        ),
                        new TextFormField(

                          controller: _userName=new TextEditingController(),
                          validator: (value){
                            if(value.isEmpty)
                              return 'نام کاربری را وارد کنید';
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),

                            ),
                            hintText: 'نام کاربری',
                            prefixIcon: new Icon(Icons.verified_user),


                          ),
                          textAlign: TextAlign.center,
                          focusNode: _userFocus,
                          onFieldSubmitted: (fed){
                            _userFocus.unfocus();
                            FocusScope.of(context).requestFocus(_passFocus);
                          },

                        ),
                        new SizedBox(
                          height: 12.0,
                        ),
                        new TextFormField(
                          controller: _passWord,
                          validator: (value){
                            if(value.isEmpty)
                              return 'رمز عبور را وارد کنید';
                          },
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),

                            ),
                            hintText: 'رمز عبور',
                            prefixIcon: new Icon(Icons.vpn_key),

                          ),
                          textAlign: TextAlign.center,
                          obscureText: true,
                          focusNode: _passFocus,
                          onFieldSubmitted: (fed){
                            _passFocus.unfocus();
                            if (_formGlobalKey.currentState.validate()){
                              _checkLogin();
                            }
                          },

                        ),

                        new SizedBox(
                          height: 10.0,
                        ),
                        new RaisedButton(onPressed: (){
                          if (_formGlobalKey.currentState.validate()){
                            _checkLogin();
                          }

                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                          color: Colors.green,
                          highlightColor: Colors.red,
                          textTheme: ButtonTextTheme.primary,
                          padding: EdgeInsets.all(18.0),
                          child: new Text('ورود به سیستم'),
                        ),


                      ],
                    ))

                  ],
                )
              ],
            ),
          ),*/
        ));
  }


}
