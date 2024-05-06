import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/verify_user.dart';
import 'package:byme_flutter_app/utils/clear_token.dart';
import 'package:byme_flutter_app/utils/header_page_bar.dart';
import 'package:byme_flutter_app/utils/bottom_navigator_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    verifyUser().then((loggedIn) {
      if (loggedIn) {
      } else {
        print('Nao esta logado');
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    return Scaffold(
      body: Column(children: [
        HeaderPageBar(),
        BottomNavigatorBar()
      ],),
    );
  }
}
