import 'package:flutter/material.dart';
import 'screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo_Application',
      debugShowCheckedModeBanner: false,
      home: NoteList(),
    );
  }
}
