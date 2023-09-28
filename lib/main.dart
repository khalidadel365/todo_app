import 'package:flutter/material.dart';

import 'layout/todo_app/todoLayout.dart';
import 'modules/new_tasks/new_tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  HomeLayout(),
    );
  }
}


