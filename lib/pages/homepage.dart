import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/verify_user.dart';
import 'package:byme_flutter_app/utils/read_token.dart';
import 'package:byme_flutter_app/utils/get_user_data.dart';

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
    readToken().then((userStorage) {
      String token = userStorage?['token'];
      int doctorId = userStorage?['doctor_id'];
      getUserData(token, doctorId).then((userData) {});
    });
    return Container();
  }
}
