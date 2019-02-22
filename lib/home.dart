import 'dart:convert';
import 'package:sharifngo/classes/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharifngo/classes/globalWidgets.dart' as globalWidgets;
import 'package:sharifngo/pages/kidsearch.dart';

class home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new homeState();
  }

}

class homeState extends State<home> {

  GlobalKey<ScaffoldState> _globalKey=new GlobalKey();
  void _getUserInfo(String token) async{
    var response=await http.get('${globals.serverUrl}/api/user',
    headers: {
      'Accept':'application/json',
      'Authorization': 'Bearer $token'

    }
    )
        .timeout(Duration(seconds: 15),
        onTimeout: (){
      setState(() {
        //_inProgress=false;
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
      var resJson=json.decode(response.body);
      setState(() {
        globals.madadkarFname=resJson['userFirstName'];
        globals.madadkarLname=resJson['userLastName'];
        globals.madadkarId=int.tryParse(resJson['madadkarId'].toString());
        globals.userId=int.tryParse(resJson['userId'].toString());
        globals.madadkarCode=int.tryParse(resJson['madadkarCode'].toString());
      });


    }else{
      setState(() {
        //_inProgress=false;
        final snackBar = SnackBar(content: Text('زمان جلسه شما به پایان رسیده است، نرم افزار را بسته و دوباره باز کنید.',
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
        this.dispose();
      });
    }
  }

  @override
  void initState() {
    _getUserInfo(globals.token);
    super.initState();
  }
  Future<bool> _onWillPop() {
    return
      showDialog(
      context: context,
      builder: (context) =>
          new Directionality(textDirection: TextDirection.rtl,
              child:       new AlertDialog(
                title: new Text('خروج از نرم افزار'),
                content: new Text('آیا می خواهید از نرم افزار خارج شوید؟'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('خیر'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('بلی'),
                  ),
                ],
              ),
          )
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
      onWillPop: _onWillPop,
    child: new Directionality(textDirection: TextDirection.rtl,
          child: new Scaffold(
            key: _globalKey,
            appBar: new AppBar(

              title: new Text('نیکوکاران شریف'),
              centerTitle: true,

            ),
            drawer: new Drawer(

              child: new Container(
                height: double.maxFinite,
                width: double.maxFinite,
                padding: EdgeInsets.fromLTRB(15.0, 55.0, 15.0, 15.0),
                child: new Column(

                  children:globalWidgets.globalDrawer(context),
                ),
              )
            ),
            body: new Container(
              padding: EdgeInsets.all(15.0),
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/back.jpg'),fit: BoxFit.cover)
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(height: 15.0,),
                  new Hero(tag: 'name', child: new Icon(Icons.person,size: 65.0,color: Colors.black45,),),
                  new Text('${globals.madadkarFname} ${globals.madadkarLname}',textScaleFactor: 2.0,

                    style:TextStyle(color: Colors.white70) ,)
                ],
              ),

            ),
          )));
  }
}