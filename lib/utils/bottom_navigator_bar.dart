import 'dart:async';
import 'package:byme_flutter_app/pages/calendar_page.dart';
import 'package:byme_flutter_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int myIndex = 0;
  late PageController pc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: myIndex,
        onTap: (value) {
          myIndex = value;
          setState(() {});
        },
        selectedIconTheme: IconThemeData(
          color: Colors.black,
          size: 30.0,
          padding: EdgeInsets.all(8.0),
          backgroundColor: Colors.white,
          // Defina a forma do fundo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),

        unselectedIconTheme: IconThemeData(color: Colors.black),
        items: const [
          BottomNavigationBarItem(backgroundColor: Color(0xff672D6F), icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(FlutterIcons.calendar_ant), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.healing), label: 'Pacientes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: 'Perfil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Definições'),
        ],
      ),
    );
  }
}
