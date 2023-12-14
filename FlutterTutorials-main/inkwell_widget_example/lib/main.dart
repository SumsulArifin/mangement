import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Inkwell Widget Example',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Scaffold(
      appBar: AppBar(title: Text('Inkwell Widget Example')),
      body: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print('on Tap');
      },
      child: Container(
        height: 50,
        width: 100,
        alignment: Alignment.center,
        child: Text('My Button'),
      ),
    );
  }
}
