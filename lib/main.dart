import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

void main() async{
  Map _data = await getJson();
  List _features = _data['features'];


  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: new Text("Quakes",
        style: new TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
        centerTitle: true,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(10.5),
            itemBuilder: (BuildContext context,int position){
              if(position.isOdd) return new Divider();
              final index = position ~/ 2;
              var format = new DateFormat.yMMMMd("en_US").add_jm();
              //var dateString = format.format();


              var date = format.format(DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000, isUtc: true));
              return new ListTile(
                title: new Text("$date",
                style: new TextStyle(color: Colors.orange, fontSize: 14.9,fontWeight: FontWeight.w500),),
                subtitle: new Text("${_features[index]['properties']['place']}",
                  style: new TextStyle(color: Colors.grey, fontSize: 10.9,fontWeight: FontWeight.w300),),
                leading: new CircleAvatar(
                  backgroundColor: Colors.green,
                  child: new Text("${_features[index]['properties']['mag']}",
                    style: new TextStyle(color: Colors.white, fontSize: 14.9,fontWeight: FontWeight.w500),),
                ),
              onTap: (){_showOnTapMessage(context, "${_features[index]['properties']['title']}");}
              
              );
            }),
      ),
    ),
  ));
}
void _showOnTapMessage(BuildContext context, String message){
  var alert = new AlertDialog(
    title: new Text("Quakes"),
    content: new Text(message,
      style: new TextStyle(color: Colors.grey, fontSize: 14.9,fontWeight: FontWeight.w500),),
      actions: <Widget>[
          new FlatButton(onPressed: (){Navigator.pop(context);},child: new Text('OK'),)]);


      showDialog(context: context, builder: (context) => alert);
}

Future<Map> getJson() async{
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);
  
  return json.decode(response.body);
}