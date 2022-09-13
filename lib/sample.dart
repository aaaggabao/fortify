import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppScreen(),
    );
  }
}

class MyAppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppScreenState();
  }
}

class MyAppScreenState extends State<MyAppScreen> {
  late StreamController<List<String>> _phobiasStream;

  final TextEditingController _textEditingController = TextEditingController();

  void _loadPhobias() async =>
      await rootBundle.loadString('lib/phobia.txt').then((phobias) {
        List<String> _listOfSortedPhobias = [];
        for (String i in LineSplitter().convert(phobias)) {
          for (String t in _textEditingController.text.split('')) {
            if (i.split('-').first.toString().contains(t)) {
              _listOfSortedPhobias.add(i);
            }
          }
        }
        _phobiasStream.add(_listOfSortedPhobias);
      });

  @override
  void initState() {
    super.initState();
    _phobiasStream = StreamController<List<String>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textEditingController,
          onChanged: (text) {
            print("Text $text");
            _loadPhobias();
          },
        ),
      ),
      body: StreamBuilder(
        stream: _phobiasStream.stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
            height: 300,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                print("Data");
                return Text("test");
              },
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}