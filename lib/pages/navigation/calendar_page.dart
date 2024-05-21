import 'package:byme_flutter_app/app_localizations.dart';
import 'package:byme_flutter_app/utils/appointment/get_appointment.data.dart';
import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:table_calendar/table_calendar.dart';

class Appointments {
  final String patientName;
  final String time;
  final String date;
  final String processNumber;

  Appointments(
      {required this.patientName,
      required this.time,
      required this.date,
      required this.processNumber});
}

class CalendarPage extends StatefulWidget {
  final PageController pageController;

  const CalendarPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _now = DateTime.now();
  late List<Appointments> _appointments;

  String getDate() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String todayDate = '$year-$month-$day';
    return todayDate;
  }

  @override
  void initState() {
    super.initState();

    _appointments = [];
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final translations = {
      'en': {
        'month': 'Month',
        'week': 'Week',
        // Adicione outras traduções necessárias para o table_calendar em inglês aqui
      },
      'pt': {
        'month': 'Mês',
        'week': 'Semana',
        // Adicione outras traduções necessárias para o table_calendar em português aqui
      },
    };

    return AppLocalizations(locale);
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getAppointmentsData('all', getDate()),
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
          List<dynamic> data = snapshot.data?['appointments'];

          _appointments = data
              .map((item) => Appointments(
                  date: item['date'],
                  time: item['time'],
                  patientName: item['patient_data']['name'],
                  processNumber: item['patient_data']['processnumber']))
              .toList();

          print(_appointments[0].time);

          return Column(
            children: [
              TableCalendar(
                focusedDay: _now,
                firstDay: _now,
                lastDay: _now.add(Duration(days: 90)),
                locale: Localizations.localeOf(context).languageCode,
              ),
            ],
          );
        }
      },
    );
  }
}
