import 'package:flutter/material.dart';
import 'package:sample_futures_streams/StreamScreen.dart';

import 'FutureScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuturesAndStreams',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'FuturesAndStreams'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
            //container com botões para levar a página futures ou streams
            Container(
              margin: EdgeInsets.only(right: 10),
              child: RaisedButton(
                  child: Text('Future'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FutureScreen()));
                  }),
            ),
            RaisedButton(
                child: Text('Stream'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StreamScreen()));
                })
          ])),
    );
  }
}
