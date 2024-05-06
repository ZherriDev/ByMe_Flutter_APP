import 'package:flutter/material.dart';

class HeaderPageBar extends StatelessWidget {
  const HeaderPageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: Container(
              color: const Color(0xff672D6F),
              child: Container(
                color: Colors.red,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
              ),
            )),
      ],
    );
  }
}
