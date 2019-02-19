import 'dart:convert';
import 'package:sharifngo/classes/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharifngo/classes/globalWidgets.dart' as globalWidgets;
import 'package:sharifngo/classes/data.dart';

class kisResults extends StatefulWidget {
  searchData inputData=new searchData();

  kisResults(this.inputData);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new kidsState(inputData);
  }
}

class kidsState extends State<kisResults> {
  searchData inputData=new searchData();
  GlobalKey<ScaffoldState> _globalKey=new GlobalKey();


  kidsState(this.inputData);

  Future<Kids> _getKidsList (searchData inputData)async{
    var response=await http.post('http://soft.sharifngo.com:8020/api/madadjou',
        headers: {
          'Accept':'application/json',
          'Authorization': 'Bearer ${globals.token}'
        },
      body: {
      'Sharayet':inputData.State,
        'City':inputData.LiveCity,
        'BirthCity':inputData.BirthCity,
        'FirstName':inputData.FirstName,
        'LastName':inputData.LastName,
        'Seyed':inputData.isSeyed,
        'noSeyed':inputData.isNotSeyed,
      }
    ).timeout(Duration(seconds: 15),
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
      var result=Kids.fromJson(resJson);
      return result;


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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: new Scaffold(
          key: _globalKey,
          appBar: new AppBar(
            actions: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 30.0,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
            title: new Text('نیکوکاران شریف'),
            centerTitle: true,
          ),
          drawer: new Drawer(
              child: new Container(
            height: double.maxFinite,
            width: double.maxFinite,
            padding: EdgeInsets.fromLTRB(15.0, 55.0, 15.0, 15.0),
            child: new Column(
              children: globalWidgets.globalDrawer(context),
            ),
          )),
          body: new FutureBuilder<Kids>(
              future: _getKidsList(inputData),
              builder: (context,snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return new Center(
                      child: new Stack(
                        children: <Widget>[
                          new CircularProgressIndicator(

                          ),
                          new Text('در حال دریافت داده ها...')
                        ],
                      ),
                    );
                  case ConnectionState.none:
                    return new Center(
                      child: new Text('خطا در دریافت'),
                    );
                  case ConnectionState.done:
                    {
                      if (snapshot.hasError){
                        return new Center(
                          child: new Text(snapshot.error.toString()),
                        );

                      }
                      if (!snapshot.hasData){
                        return new Center(
                          child: new Text('نتیجه ای یافت نشد'),
                        );
                      }else{
                        var list=snapshot.data.madadjous;
                        return new ListView.builder(
                          itemCount: list.length,
                            itemBuilder: (context,index){
                            return new Card(
                              child: new Stack(
                                children: <Widget>[
                                  new Text('${list[index].firstName} ${list[index].lastName}')
                                ],
                              ),
                            );
                            });
                      }
                    }
                }
              })
        ));
  }
}
