import 'package:flutter/material.dart';
import 'package:sharifngo/pages/kidsearch.dart';


  List<Widget> globalDrawer(BuildContext context){
    var item=new GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>new kids()));
      },
      child: new Container(
        padding: EdgeInsets.all(10.0),
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.red,width: 2.0,style: BorderStyle.none),
          color: Colors.green

        ),
        child: new Row(
        children: <Widget>[
    new Icon(Icons.child_care,color: Colors.red,size: 36.0,),
          new SizedBox(width: 18.0,),
          new Text('جستجوی کودکان')

    ],
      ),
      )
    );
    List<Widget> list=new List();
    list.add(item);
    return list;

  }
