import 'package:flutter/material.dart';

class PatientsPage extends StatefulWidget {
  final PageController pageController;

  const PatientsPage({Key? key, required this.pageController}) : super(key: key);

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}