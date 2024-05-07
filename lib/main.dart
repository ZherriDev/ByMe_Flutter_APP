import 'package:byme_flutter_app/pages/landing_page.dart';
import 'package:byme_flutter_app/pages/register_page.dart';
import 'package:byme_flutter_app/pages/login_page.dart';
import 'package:byme_flutter_app/pages/forgot_pass_page.dart';
import 'package:byme_flutter_app/pages/homepage.dart';
import 'package:byme_flutter_app/utils/inside_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByMe',
      theme: ThemeData(
        fontFamily: 'Lato',
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/inside_app': (context) => const InsideApp(),
        '/homepage': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
