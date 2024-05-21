import 'package:byme_flutter_app/utils/appointment/get_appointment.data.dart';
import 'package:byme_flutter_app/utils/appointment/get_appointment_class_data.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Appointments {
  final String patientName;
  final String sex;
  final String processNumber;

  Appointments(
      {required this.patientName,
      required this.processNumber,
      required this.sex});
}

class CalendarPage extends StatefulWidget {
  final PageController pageController;

  const CalendarPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
      future: getAppointmentsClassData('all', getDate()),
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
          List<dynamic>? appointmentsData = snapshot.data;
          if (appointmentsData == null || appointmentsData.isEmpty) {
            return Center(
              child: Text('Nenhum appointment encontrado'),
            );
          }

          print(appointmentsData);
          Map<DateTime, List<Appointments>> appointments = {};

          // for (var appointment in appointmentsData) {
          //   String patientName = appointment['patient_data']['name'];
          //   String processNumber = appointment['patient_data']['processnumber'];
          //   String sex = appointment['sex'];

          //   Appointments appointmentObj = Appointments(
          //     patientName: patientName,
          //     processNumber: processNumber,
          //     sex: sex,
          //   );

          //   DateTime appointmentDate = DateTime.parse(appointment['date']);

          //   if (appointments.containsKey(appointmentDate)) {
          //     appointments[appointmentDate]!.add(appointmentObj);
          //   } else {
          //     appointments[appointmentDate] = [appointmentObj];
          //   }
          // }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
            body: Column(
              children: [
                TableCalendarWidget(),
              ],
            ),
          );
        }
      },
    );
  }
}

class TableCalendarWidget extends StatefulWidget {
  const TableCalendarWidget({super.key});

  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget> {
  DateTime today = DateTime.now();
  DateTime _now = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarStyle: CalendarStyle(
          todayTextStyle: TextStyle(color: Colors.white),
          todayDecoration: BoxDecoration(
              color: const Color(0xff672D6F).withOpacity(0.5),
              shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(
              color: const Color(0xff672D6F), shape: BoxShape.circle)),
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
      availableGestures: AvailableGestures.all,
      locale: "pt_BR",
      focusedDay: _now,
      firstDay: _now,
      lastDay: _now.add(Duration(days: 90)),
      selectedDayPredicate: (day) => isSameDay(day, today),
      onDaySelected: _onDaySelected,
    );
  }
}
