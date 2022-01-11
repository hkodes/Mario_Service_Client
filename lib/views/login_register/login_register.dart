import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mario_service/external_svg_resources/svg_resources.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/login/login.dart';
import 'package:mario_service/views/register/register.dart';

class LoginRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SvgPicture.string(
                      svg_card_3,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: 75,
                      height: 75,
                      child: Image.asset('assets/icon/icon.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Service',
                    style: TextStyle(
                      fontFamily: 'Cabin',
                      fontSize: 34,
                      color: const Color(0xfffc6011),
                      letterSpacing: 1.1560000000000001,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Mario',
                    style: TextStyle(
                      fontFamily: 'Cabin',
                      fontSize: 34,
                      color: const Color(0xff4a4b4d),
                      letterSpacing: 1.156,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Service Delivery',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 10,
                  color: const Color(0xff4a4b4d),
                  letterSpacing: 2.36,
                  height: 3.4,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Discover the best services from over 1,000\n service provider and fast delivery to your doorstep',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 13,
                  color: const Color(0xff7c7d7e),
                  fontWeight: FontWeight.w500,
                  height: 1.4615384615384615,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              PositiveButton(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage())),
                text: "Login",
              ),
              const SizedBox(
                height: 25,
              ),
              NegativeButton(
                text: "Register",
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RegisterPage())),
              )
            ],
          ),
        ),
      ),
    );
  }
}
