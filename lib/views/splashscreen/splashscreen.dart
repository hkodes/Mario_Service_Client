import 'package:flutter/material.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/repositories/check_api/check_api.dart';
import 'package:mario_service/utils/enums.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/views/carousel/carousel.dart';
import 'package:mario_service/views/dashboard/dashboard.dart';
import 'package:mario_service/views/login_register/login_register.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  SharedReferences shared = new SharedReferences();
  CheckApi check = new CheckApi();
  Map<String, dynamic> response = {};

  @override
  void initState() {
    // checkAuthentication();
    super.initState();

    changeRoute(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset('assets/icon/icon.png'),
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
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'Mario',
                  style: TextStyle(
                    fontFamily: 'Cabin',
                    fontSize: 34,
                    color: const Color(0xff4a4b4d),
                    letterSpacing: 1.1560000000000001,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.center,
                ),
              ],
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
          ],
        ),
      ),
    );
    // );
  }

  // void _gotoDashBoard(BuildContext context) {
  //   context.router.replace(DashBoardRoute());
  // }

  // void _gotoDMap(BuildContext context) {
  //   context.router.replace(MapOrder());
  // }

  // void _gotoLoginPage(BuildContext context) {
  //   context.router.replace(LoginRegisterRoute());
  // }

  // void _exitApp(BuildContext context) {
  //   showSnackError(context, "Server is not responding");
  // }

  // void _gotoCarousel(BuildContext context) {
  //   context.router.replace(CarouselRoute());
  // }

  void changeRoute(BuildContext context) async {
    // setState(() {

    response = await check.check();
    var isFirst = false;
    if (await shared.getPrefernce() == null) {
      isFirst = true;
    }
    String tokn = await shared.getAccessToken();
    if (response['sucess']) {
      Future.delayed(
          Duration(
            seconds: 1,
          ), () {
        if (isFirst) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Carousel()));
        } else {
          if (tokn == null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginRegisterPage()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DashBoardPage('')));
          }
        }
      });
    } else {
      showSnackError(context, "Server is not responding");
    }
  }

  // });
}
