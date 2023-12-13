import 'package:flutter/material.dart';
import 'package:hospitalplanner/navigation/User.dart';
import 'package:hospitalplanner/navigation/navigation_bar.dart';

void main(){
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _Home(),
      theme: ThemeData.dark(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigationBar(),
      body: Center(
        child: Text(
          'Welcome, ${myUser.getFirstName()}!',
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}

