import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/data/datasources/todo_local_datasource.dart';
import 'package:todo_app/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/presentation/controllers/todo_controller.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final repository = TodoRepositoryImpl(
      TodoLocalDatasource(prefs),
    );

    return ChangeNotifierProvider(
      create: (_) => TodoController(repository),
      child: MaterialApp(
        title: 'Neon Tasks',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.cyber(),
        darkTheme: AppTheme.cyber(),
        themeMode: ThemeMode.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
