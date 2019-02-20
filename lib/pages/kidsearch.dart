import 'dart:convert';
import 'package:sharifngo/classes/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharifngo/classes/globalWidgets.dart' as globalWidgets;
import 'package:sharifngo/classes/data.dart';
import 'package:sharifngo/pages/kidsearchresults.dart' as ss;



class kids extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new kidsState();
  }
}


class kidsState extends State<kids> {
  searchData _searchData=new searchData();
  static const List<String> stateOf=['همه','بد سرپرست','بیماری سرپرست','فوت سرپرست','بیماری'];
  TextEditingController kidFname=new TextEditingController();
  TextEditingController kidLname=new TextEditingController();
  TextEditingController kidCity=new TextEditingController();
  TextEditingController kidBCity=new TextEditingController();
  TextEditingController kidFromAge=new TextEditingController();
  TextEditingController kidToAge=new TextEditingController();
  String kidState=stateOf[0];
  bool kidIsSeyed=true;

  bool kidIsNotSeyed=true;

  List<DropdownMenuItem> listState=[
    new DropdownMenuItem(child: new Container(width: 165.0,padding: EdgeInsets.all(2.0),child: new Text(stateOf[0]),),value: stateOf[0],),
    new DropdownMenuItem(child: new Container(width: 165.0,padding: EdgeInsets.all(2.0),child: new Text(stateOf[1]),),value: stateOf[1],),
    new DropdownMenuItem(child: new Container(width: 165.0,padding: EdgeInsets.all(2.0),child: new Text(stateOf[2]),),value: stateOf[2],),
    new DropdownMenuItem(child: new Container(width: 165.0,padding: EdgeInsets.all(2.0),child: new Text(stateOf[3]),),value: stateOf[3],),
    new DropdownMenuItem(child: new Container(width: 165.0,padding: EdgeInsets.all(2.0),child: new Text(stateOf[4]),),value: stateOf[4],)
  ];
  void _value1Changed  (bool value) async => setState(() {
    kidIsSeyed = value;
    debugPrint(kidIsSeyed.toString());
  });
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      new Directionality(textDirection: TextDirection.rtl,
    child: new Scaffold(
    appBar: new AppBar(
      actions: <Widget>[
        new IconButton(icon: Icon(Icons.arrow_forward_ios,size: 30.0,color: Colors.white70,), onPressed: (){
          Navigator.of(context).pop();
        })
      ],
    title: new Text('نیکوکاران شریف'),
    centerTitle: true,
    ),
    floatingActionButton: FloatingActionButton(onPressed: (){
      _searchData.FirstName=kidFname.text;
      _searchData.LastName=kidLname.text;
      _searchData.BirthCity=kidBCity.text;
      _searchData.LiveCity=kidCity.text;

      _searchData.State=kidState;
      if (kidState=='همه')
        _searchData.State='';
      _searchData.isSeyed=kidIsSeyed;
      _searchData.isNotSeyed=kidIsNotSeyed;
      if (kidFromAge.text.isNotEmpty )
      _searchData.fromAge=int.parse(kidFromAge.text);
      if (kidToAge.text.isNotEmpty)
      _searchData.toAge=int.parse(kidToAge.text);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ss.kisResults(_searchData)));
    },
      backgroundColor: Colors.redAccent,
      //materialTapTargetSize: MaterialTapTargetSize.padded,
      shape: CircleBorder(side: BorderSide(color: Colors.red,style: BorderStyle.solid,width: 3.0)),
    child: new Icon(Icons.search,size: 35.0,),
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
        width: double.maxFinite,
        height: double.maxFinite,
        padding: EdgeInsets.all(15.0),
        child:
        Form(
          child:
          ListView(
            children: <Widget>[
              new TextField(
                controller: kidFname,

                decoration: InputDecoration(hintText: 'بخشی از نام کودک',prefixIcon: Icon(Icons.child_care),
                    border: OutlineInputBorder(borderSide: BorderSide())
                ),


              ),
              new SizedBox(height: 3.0,),
              new TextField(
                controller: kidLname,
                decoration: InputDecoration(hintText: 'بخشی از فامیلی کودک',prefixIcon: Icon(Icons.child_care),
                    border: OutlineInputBorder(borderSide: BorderSide())
                ),

              ),
              new SizedBox(height: 3.0,),
              new TextField(
                controller: kidCity,
                decoration: InputDecoration(hintText: 'بخشی از نام شهر سکونت',prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(borderSide: BorderSide())
                ),

              ),
              new SizedBox(height: 3.0,),
              new TextField(
                controller: kidBCity,
                decoration: InputDecoration(hintText: 'بخشی از نام شهر تولد',prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(borderSide: BorderSide())
                ),

              ),
              new SizedBox(height: 3.0,),
                new Container(
                  padding: EdgeInsets.all(1.0),

             decoration: BoxDecoration(
                 border: Border.all(
                   color: Colors.black38
                 ),
               borderRadius: BorderRadius.circular(5.0),
             ),
             child: DropdownButtonHideUnderline(

                 child: ButtonTheme(

                   alignedDropdown: true,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(6.0),
                     side: BorderSide(width: 2.0)
                   ),
                   child: DropdownButton(
                       hint: new Text('وضعیت سرپرست',textAlign: TextAlign.center,),

                       iconSize: 35.0,
                       items:listState,
                       value: kidState
                       , onChanged:(value){
                     setState(() {
                       kidState=value;
                     });
                     debugPrint(kidState);
                   }

                   ),
                 ))

           ),
              new SizedBox(height: 3.0,),
              new Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: Colors.black38,

                  ),
                  borderRadius: BorderRadius.circular(5.0),

                ),
                child:
                new CheckboxListTile(
                    title: new Text('کودک سید'),
                    value: kidIsSeyed,
                    onChanged: (val){
                      setState(() {
                        kidIsSeyed=!kidIsSeyed;
                      });
                    }),

              ),
              new SizedBox(height: 3.0,),
              new Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: Colors.black38,

                  ),
                  borderRadius: BorderRadius.circular(5.0),

                ),
                child:
                new CheckboxListTile(
                    title: new Text('کودک غیر سید'),
                    value: kidIsNotSeyed,
                    onChanged: (val){
                      setState(() {
                        kidIsNotSeyed=!kidIsNotSeyed;
                      });
                    }),

              ),
              new SizedBox(height: 3.0,),
              new TextField(
                controller: kidFromAge,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                decoration: InputDecoration(hintText: 'از سن',prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderSide: BorderSide())
                ),

              ),
              new SizedBox(height: 3.0,),
              new TextField(
                controller: kidToAge,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                decoration: InputDecoration(hintText: 'تا سن',prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderSide: BorderSide())
                ),

              ),




            ],
          ),

        ),

      )
    )
    ) ;
  }
}