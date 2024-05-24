import 'package:byme_flutter_app/utils/appointment/get_appointment_class_data.dart';
import 'package:byme_flutter_app/utils/calendar/delete_appointment.dart';
import 'package:byme_flutter_app/utils/calendar/dialog_add_appointment.dart';
import 'package:byme_flutter_app/utils/widgets/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Appointments {
  final int appointmentId;
  final int patientId;
  final String patientName;
  final String sex;
  final String processNumber;
  final DateTime date;
  final String time;

  Appointments(
      {required this.appointmentId,
      required this.patientId,
      required this.patientName,
      required this.processNumber,
      required this.sex,
      required this.date,
      required this.time});
}

class CalendarPage extends StatefulWidget {
  final Function(int) patientPageID;
  final PageController pageController;

  const CalendarPage(
      {Key? key, required this.patientPageID, required this.pageController})
      : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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
    void reloadPage() {
      setState(() {});
    }

    return FutureBuilder<List<dynamic>?>(
      future: getAppointmentsClassData('all', getDate()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Text('Erro ao carregar dados'),
          );
        } else {
          List<dynamic>? appointmentsData = snapshot.data;
          if (appointmentsData == null || appointmentsData.isEmpty) {
            return const Center(
              child: Text('Nenhuma consulta encontrada'),
            );
          }

          Map<DateTime, List<Appointments>> appointments = {};

          for (var appointment in appointmentsData) {
            int appointmentId = appointment['appointment_id'];
            int patientId = appointment['patient_id'];
            String patientName = appointment['patient_data']['name'];
            String processNumber = appointment['patient_data']['processnumber'];
            String sex = appointment['patient_data']['sex'];
            String time = appointment['time'];
            DateTime appointmentDate = DateTime.parse(appointment['date']);

            Appointments appointmentObj = Appointments(
                appointmentId: appointmentId,
                patientId: patientId,
                patientName: patientName,
                processNumber: processNumber,
                sex: sex,
                date: appointmentDate,
                time: time);

            if (appointments.containsKey(appointmentDate)) {
              appointments[appointmentDate]!.add(appointmentObj);
            } else {
              appointments[appointmentDate] = [appointmentObj];
            }
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(left: 14, right: 14, bottom: 14),
                  child: Center(
                    child: TableCalendarWidget(
                      appointments: appointments,
                      patientPageID: widget.patientPageID,
                      reloadPage: reloadPage,
                      pageController: widget.pageController,
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  bottom: 10,
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff672D6F),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddAppointment(
                              context: context,
                              pageController: widget.pageController,
                              reloadPage: reloadPage,
                            );
                          });
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class TableCalendarWidget extends StatefulWidget {
  final Map<DateTime, List<Appointments>> appointments;
  final Function(int) patientPageID;
  final Function() reloadPage;
  final PageController pageController;

  const TableCalendarWidget(
      {Key? key,
      required this.appointments,
      required this.patientPageID,
      required this.reloadPage,
      required this.pageController})
      : super(key: key);

  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget> {
  final DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  late ValueNotifier<List<Appointments>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime(_today.year, _today.month, _today.day);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  List<Appointments> _getEventsForDay(DateTime day) {
    String strDay = day.toString();
    strDay = strDay.replaceFirst('Z', '');
    day = DateTime.parse(strDay);
    return widget.appointments[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          calendarStyle: CalendarStyle(
              todayTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                  color: const Color(0xff672D6F).withOpacity(0.5),
                  shape: BoxShape.circle),
              selectedDecoration: const BoxDecoration(
                  color: Color(0xff672D6F), shape: BoxShape.circle)),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            titleTextFormatter: (date, locale) {
              return DateFormat.yMMMM(locale).format(date).toCapitalized();
            },
          ),
          availableGestures: AvailableGestures.all,
          locale: "pt_BR",
          focusedDay: _focusedDay!,
          firstDay: _today,
          lastDay: _today.add(const Duration(days: 90)),
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          onDaySelected: _onDaySelected,
          eventLoader: _getEventsForDay,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            _selectedEvents.value = _getEventsForDay(focusedDay);
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          calendarFormat: _calendarFormat,
        ),
        const SizedBox(
          height: 20,
        ),
        ValueListenableBuilder<List<Appointments>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              if (value.isEmpty) {
                return const Center(
                  child: Text('Não há consultas para este dia'),
                );
              } else {
                int minusHeight = 0;

                if (_calendarFormat == CalendarFormat.twoWeeks) {
                  minusHeight = 500;
                } else if (_calendarFormat == CalendarFormat.month) {
                  minusHeight = 655;
                } else {
                  minusHeight = 455;
                }

                return SizedBox(
                  height: MediaQuery.of(context).size.height - minusHeight,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        int appointmentId = value[index].appointmentId;
                        int patientId = value[index].patientId;
                        String patientName = value[index].patientName;
                        String time = value[index].time;

                        return ListTile(
                          onTap: () {
                            widget.patientPageID(patientId);
                            widget.pageController.jumpToPage(6);
                          },
                          title: Text(patientName),
                          subtitle: Text(
                            time,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeleteAppointment(
                                      reloadPage: widget.reloadPage,
                                      context: context,
                                      appointmentId: appointmentId,
                                      pageController: widget.pageController,
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 25,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }),
                );
              }
            })
      ],
    );
  }
}
