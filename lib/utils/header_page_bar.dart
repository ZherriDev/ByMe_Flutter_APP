import 'package:flutter/material.dart';

class HeaderPageBar extends StatelessWidget {
  final String text;
  final String image;

  const HeaderPageBar({
    super.key,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Color(0xff672D6F),
              borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(30),
                  bottomEnd: Radius.circular(30))),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
        Positioned(
          top: 110,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xff672D6F),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(image),
          ),
        ),
      ]),
    );
  }
}
