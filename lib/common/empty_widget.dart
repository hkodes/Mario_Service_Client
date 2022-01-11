import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mario_service/external_svg_resources/svg_resources.dart';

class EmptyOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.string(
          empty_cart,
          height: MediaQuery.of(context).size.width,
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          'Oops! Its empty!',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 21,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'We have not received any order under this category',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 17,
            color: const Color(0xff9f9f9f),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
