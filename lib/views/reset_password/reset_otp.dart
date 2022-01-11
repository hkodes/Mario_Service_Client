import 'package:flutter/material.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/imported/package/OTP_field/otp_field.dart';
import 'package:mario_service/imported/package/OTP_field/style.dart';
import 'package:mario_service/views/reset_password/reset_password.dart';

class ResetOtp extends StatefulWidget {
  final String mobile;
  final int userId;

  const ResetOtp({
    Key key,
    @required this.mobile,
    @required this.userId,
  })  : assert(mobile != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ResetOtpState();
  }
}

class ResetOtpState extends State<ResetOtp> {
  String otpCode;
  String otpText;
  int userId;

  bool enabled = false;
  List<TextEditingController> listOfTextEditingController =
      List<TextEditingController>.filled(6, null, growable: false);

  @override
  void initState() {
    this.otpCode = widget.mobile;
    this.userId = widget.userId;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              'We have sent an OTP to\nyour Email',
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 25,
                color: const Color(0xff4a4b4d),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Please check your mobile \ncontinue to reset your password',
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 14,
                color: const Color(0xff7c7d7e),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: MediaQuery.of(context).size.width / 6,
                obscureText: false,
                keyboardType: TextInputType.number,
                textFieldAlignment: MainAxisAlignment.spaceEvenly,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  enabled = true;
                  otpText = pin;
                },
                onChanged: (pin) {
                  if (pin.length == 6) {
                    setState(() {
                      enabled = true;
                    });
                  } else {
                    setState(() {
                      enabled = false;
                    });
                  }
                },
                listOfTextEditingController: listOfTextEditingController),
            const SizedBox(
              height: 50,
            ),
            PositiveButton(
              onTap: enabled
                  ? () => _validate(context, otpText, otpCode, userId)
                  : null,
              text: "Next",
            ),
            const SizedBox(
              height: 50,
            ),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 14,
                  color: const Color(0xff7c7d7e),
                ),
                children: [
                  TextSpan(
                    text: 'Didn\'t Receive? ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "Click Here",
                    style: TextStyle(
                      color: const Color(0xfffc6011),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ));
  }

  _validate(BuildContext context, String otpText, String mobile, int userId) {
    if (otpText == mobile) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResetPassword(id: widget.userId)),
      );
    } else {
      showSnackError(context, "Invalid OTP");
    }
  }

  // void _update(BuildContext context) {
  //   if (widget.userId == null) {
  //     //navigate to detail
  //     context.router.popUntil((route) => route.isFirst);
  //     context.router.replace(DashBoardRoute());
  //   } else {
  //     //navigate to resetPassword
  //     context.router.push(
  //       ResetPassword(
  //         id: widget.userId,
  //       ),
  //     );
  //   }
  // }
}
