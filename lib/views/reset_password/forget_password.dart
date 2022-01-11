import 'package:flutter/material.dart';
import 'package:mario_service/utils/form_util.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/repositories/authentication/login_repo.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/imported/text_field.dart';
import 'package:mario_service/views/login/login.dart';
import 'package:mario_service/views/reset_password/reset_otp.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordState();
  }
}

class ForgetPasswordState extends State<ForgetPassword> {
  final LoginRepo _loginRepo = new LoginRepo();
  TextEditingController _emailEditingController = TextEditingController();
  final _formKeyForgetPassword = GlobalKey<FormState>();

  bool btnEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyForgetPassword,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 75,
              ),
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 30,
                  color: const Color(0xff4a4b4d),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Please enter your phone to receive a\n code to create a new password via sms",
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 14,
                  color: const Color(0xff7c7d7e),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 75,
              ),
              CustomTextField(
                hint: "phone",
                isPhone: true,
                validator: (String text) =>
                    FormUtils.validatePhone(text, context),
                textEditingController: _emailEditingController,
              ),
              const SizedBox(
                height: 50,
              ),
              PositiveButton(
                onTap: btnEnabled
                    ? () {
                        if (_formKeyForgetPassword.currentState.validate()) {
                          return _validate(
                              context, _emailEditingController.text);
                        }
                        return null;
                      }
                    : null,
                text: "Send",
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () => _navigateToLoginPage(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Back to login',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      color: const Color(0xff7c7d7e),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validate(BuildContext context, String text) async {
    setState(() {
      btnEnabled = false;
    });

    Map<String, dynamic> _message = await _loginRepo.forgotPassword(text);

    setState(() {
      btnEnabled = true;
    });
    if (_message['errors'] != null) {
      showSnackError(context, _message['message']);
    } else {
      showSnackSuccess(context, _message['message']);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResetOtp(
                mobile: _message['user']['otp'].toString(),
                userId: _message['user']['id'])),
      );
    }

    // changePasswordBloc.add(ForgetPasswordEvent(
    //   email: text,
    // ));
  }

  _navigateToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
