import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future<RawDatagramSocket> sock;

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  double _value = 0.0;

  void _onChanged(double value) {
    setState(() {
      _value = value;
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
        body: buttons(_value, _onChanged),
      ),
    );
  }
}

Center buttons(double val, Function fnx) {

  return Center(
    child: Stack(
      children: <Widget>[
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
                sock = RawDatagramSocket.bind(InternetAddress.anyIPv4, 4010);
                print("Start");
              },
              onChanged: (double va) {
                fnx(va);
                List<int> data = new Utf8Codec().encode(va.toString() + '\n');
                InternetAddress addr = new InternetAddress('192.168.1.33');
                sock.then((socket) => socket.send(data, addr, 4010));
                print("${va.round()}");
              },
              onChangeEnd: (double va){
                sock.then((socket)=> socket.close());
                print("End");
              },
            ),
          ),
        ),
      ],
    ),
  );
}

