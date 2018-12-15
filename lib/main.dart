import 'package:flutter/material.dart';
import 'package:flutter_app/MembersListScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter!',
        theme: ThemeData(primaryColor: Color.fromARGB(255, 255, 35, 115)),
        home: ListOfMembers());
  }
}
