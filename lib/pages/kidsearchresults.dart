import 'dart:convert';
import 'package:sharifngo/classes/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharifngo/classes/globalWidgets.dart' as globalWidgets;
import 'package:sharifngo/classes/data.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    var response=await http.post('${globals.serverUrl}/api/madadjou',
        headers: {
          'Accept':'application/json',
          'Authorization': 'Bearer ${globals.token}',
          'Content-Type':'application/x-www-form-urlencoded'
        },
      body: {
      'Sharayet':inputData.State,
        'City':inputData.LiveCity,
        'BirthCity':inputData.BirthCity,
        'FirstName':inputData.FirstName,
        'LastName':inputData.LastName,
        'Seyed':inputData.isSeyed.toString(),
        'noSeyed':inputData.isNotSeyed.toString(),
        "fromAge": inputData.fromAge.toString(),
        "toAge": inputData.toAge.toString()

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

  Widget _buildDialog(Madadjous item){
    return new Directionality(textDirection: TextDirection.rtl,
        child: SimpleDialog(
          title: new Text('${item.firstName} ${item.lastName}'),
          children: <Widget>[
            new Container(
              //height: 400,
              padding: EdgeInsets.all(4.0),
              margin: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(width: 3.0,color: Colors.black12,style: BorderStyle.solid),


              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('کد کودک: ${item.code}'),
                  new Text('وضعیت: ${item.statusName}'),
                  new Text('تولد: ${item.birth}'),
                  new Text('محل تولد: ${item.birthPlace}'),
                  new Text('محل سکونت: ${item.city} '),
                  item.isSeyed?new Text('سید می باشد',style: TextStyle(color: Colors.green),):new Text('سید نمی باشد',style: TextStyle(color: Colors.blue)),
                  new Text('توضیحات:'),
                  new Text(item.note,textAlign: TextAlign.justify,textScaleFactor: 0.8,softWrap: true,textDirection: TextDirection.rtl,
                  locale: Locale('fa-IR'),

                  ),
                  new Container(
                    height: 150,
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    color: Colors.blueGrey,
                    child: new ListView.builder(
                        itemCount: item.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,i){
                          return new Container(
                            height: 145.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: Colors.amber,
                                width: 2.0,
                              ),

                            ),
                            child: Image.network(item.images[i],fit: BoxFit.fitHeight,)??new Text('Pic Connot load...'),
                          );

                        })
                  ),


                ],
              ),
            ),
            new RaisedButton(onPressed: ()=>Navigator.of(context).pop(),child: new Text('بستن'),)

          ],

        ));
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
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                      if (!snapshot.hasData || snapshot.data.madadjous.length==0){
                        return new Center(
                          child: new Text('نتیجه ای یافت نشد، حداقل یکی از فیلدهای جستجو باید پر باشد.', softWrap: true,textAlign: TextAlign.center,),
                        );
                      }else{
                        var list=snapshot.data.madadjous;
                        return new ListView.builder(
                          itemCount: list.length,
                            itemBuilder: (context,index){
                            var item=list[index];
                            return new
                                GestureDetector(
                              onTap: (){
                                showDialog(context: context,child: _buildDialog(item));
                              },
                              child: Card(
                                color: Colors.white70.withOpacity(0.5),
                                  margin: EdgeInsets.all(4.0),
                                  child:new Container(
                                    padding: EdgeInsets.all(8.0),
                                    //alignment: Alignment.centerRight,
                                    /*child: new Row(
                                  children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,

                                children: <Widget>[
                                  new Text('کد کودک: ${list[index].code}'),
                                new Text('نام و نام خانوادگی: ${list[index].firstName} ${list[index].lastName}'),
                                new Text('تاریخ تولد: ${list[index].birth}'),
                                new Text('محل تولد: ${list[index].birthPlace}'),
                                new Text('محل سکونت: ${list[index].city}'),
                                new Text('علت حمایت: ${list[index].statusName}'),
                                ],
                              ),
                                   // new Image.asset('assets/images/Logo.png'),
                                  ],
                                ),*/
                                    child:
                                    new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text('نام:${item.firstName} ${item.lastName}',style: TextStyle(color: Colors.pink.shade700),textScaleFactor: 1.2,),
                                        new Text('کد کودک: ${item.code}'),
                                        new Text('وضعیت: ${item.statusName}'),
                                        new Text('تولد: ${item.birth}'),
                                        new Text('محل تولد: ${item.birthPlace}'),
                                        new Text('محل سکونت: ${item.city} '),
                                        item.isSeyed?new Text('سید می باشد',style: TextStyle(color: Colors.green),):new Text('سید نمی باشد',style: TextStyle(color: Colors.red))
                                      ],
                                    ),
                                  )

                              )
                              ,
                            );
                            });
                      }
                    }
                }
              })
        ));
  }
}
