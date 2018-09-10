import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

Future<Socket> sock;

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  double _value = 0.0;
  bool _switchVal = false;

  void _onChanged(double value) {
    setState(() {
      _value = value;
    });
  }

  void _onSwitch(bool value) {
    setState(() {
      _switchVal = value;
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("TCP"),
        ),
        body: buttons(_value, _onChanged, _switchVal, _onSwitch),
      ),
    );
  }
}

Center buttons(double val, Function fnx, bool switchVal, Function switchFn) {

  return Center(
    child: Stack(
      children: <Widget>[
        Positioned(
          top: 100.0,
          left: 100.0,
          child: SizedBox(
            width: 200.0,
            height: 50.0,
            child: FlatButton(
              onPressed: btnOn,
              child: Text("ON"),
              color: Colors.deepOrange,
              padding: EdgeInsets.all(20.0),
            ),
          ),
        ),
        Positioned(
          top: 300.0,
          left: 100.0,
          child: SizedBox(
            width: 200.0,
            height: 50.0,
            child: FlatButton(
              onPressed: btnOff,
              child: Text("OFF"),
              color: Colors.deepOrange,
              padding: EdgeInsets.all(20.0),
            ),
          ),
        ),
        Positioned(
          top: 450.0,
          left: 50.0,
          child: SizedBox(
            width: 300.0,
            child: Slider(
              min: 0.0,
              max: 250.0,
              divisions: 250,
              value: val,
              label: val.toString(),
              onChangeStart: (double va){
                sock = Socket.connect('192.168.1.41', 4015);
                print("Start");
              },
              onChanged: (double va) {
                fnx(va);
                sock.then((socket) => socket.write(va.toString() + '\n'));
                print("${va.round()}");
              },
              onChangeEnd: (double va){
                sock.then((socket)=> socket.close());
                print("End");
              },
            ),
          ),
        ),
        Positioned(
          top: 500.0,
          left: 50.0,
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Switch(
              value: switchVal,
              onChanged: (bool va) {
                switchFn(va);
              },
            ),
          ),
        ),
        Positioned(
          top: 520.0,
          left: 250.0,
          child: Chip(
            shape: StadiumBorder(side: BorderSide(width: 2.0)),
            backgroundColor: Colors.deepOrangeAccent,
            padding: EdgeInsets.all(20.0),
            label: Text(DateTime.now().day.toString()),
            avatar: Icon(Icons.child_care),
          ),
        ),
        Positioned(
          top: 570.0,
          left: 50.0,
          child: Card(
            color: Colors.indigoAccent,
            child: Column(children: <Widget>[
                Container(margin: EdgeInsets.all(10.0),child: Text("Cesar"),),
                Container(margin: EdgeInsets.all(10.0),child: Text("Isabel"),),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

void btnOn() async {
  await Socket.connect('192.168.1.41', 4015).then((socket) {
    socket.write('1');
    socket.close();
  });
}

void btnOff() async {
  await Socket.connect('192.168.1.41', 4015).then((socket) {
    socket.write('0');
    socket.close();
  });
}

void btnSlider(double val) async {
  await Socket.connect('192.168.1.41', 4015).then((socket) {
    String dataOut = val.round().toString() + '\n';
    socket.write(dataOut);
    socket.close();
  });
}

