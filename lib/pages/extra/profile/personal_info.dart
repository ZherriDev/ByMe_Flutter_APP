import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:flutter/material.dart';

class PersonalInfo extends StatefulWidget {
  final PageController pageController;

  const PersonalInfo({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String getDate() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String todayDate = '$year-$month-$day';
    return todayDate;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(context, 'all', getDate(), null, null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Erro ao carregar dados'),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text('Informações Pessoais')],
            );
          }
        });
  }
}
