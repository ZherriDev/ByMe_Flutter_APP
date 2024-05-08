import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/user/verify_user.dart';
import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:byme_flutter_app/utils/user/get_user_data.dart';

Future<Map<String, dynamic>?> fetchUserData(BuildContext context) async {
  try {
    final loggedIn = await verifyUser();
    if (!loggedIn) {
      Navigator.of(context).pushReplacementNamed('/');
      return null;
    }
    final userStorage = await readToken();
    String token = userStorage?['token'];
    int doctorId = userStorage?['doctor_id'];
    return await getUserData(token, doctorId);
  } catch (e) {
    print('Erro ao obter dados do usuário: $e');
    return null;
  }
}
