import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/verify_user.dart';
import 'package:byme_flutter_app/utils/clear_token.dart';
import 'package:byme_flutter_app/utils/get_user_data.dart';
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
      if (!loggedIn) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderPageBar(
              text: 'Página Inicial',
              image: '',
            ),
          ],
        ));
  }
}
