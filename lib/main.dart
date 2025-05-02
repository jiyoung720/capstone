import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/todo_list_page.dart';
import 'pages/start_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/reset_password_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/', // 시작은 스플래시
      routes: {
        '/': (context) => const SplashScreen(),
        '/start': (context) => const StartPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/reset': (context) => ResetPasswordPage(),
        '/todo': (context) => const TodoListPage(),
      },
    );
  }
}
