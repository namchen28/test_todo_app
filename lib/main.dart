import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/bloc/todo_bloc.dart';
import 'package:todo_test/bloc/bloc_export.dart';
import 'package:todo_test/notification/local_notification.dart';
import 'package:todo_test/screens/todo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;

  runApp(BlocProvider(
    create: (context) => TodoBloc(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: CupertinoColors.systemOrange,
          elevation: 10,
        ),
        scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
        appBarTheme: const AppBarTheme(
          backgroundColor: CupertinoColors.activeOrange,
        ),
      ),
      home: const ToDoScreen(),
    );
  }
}
