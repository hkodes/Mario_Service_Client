import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mario_service/utils/form_util.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/imported/text_field.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/views/dashboard/dashboard.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:mario_service/views/register/register.dart';
import 'package:mario_service/repositories/authentication/login_repo.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/views/reset_password/forget_password.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final LoginRepo _loginRepo = new LoginRepo();
  final SharedReferences references = new SharedReferences();
  final TextEditingController _emailEditingController =
      TextEditingController(text: "");
  final TextEditingController _passwordEditingController =
      TextEditingController(text: "");
  final GlobalKey<FormState> _globalKeyLoginPage = GlobalKey();
  Timer timer;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 75,
                  ),
                  Text(
                    'Login',
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
                    'Add your details to login',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      color: const Color(0xff7c7d7e),
                      fontWeight: FontWeight.w500,
                      height: 1.4285714285714286,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
              Form(
                key: _globalKeyLoginPage,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      hint: "9*********",
                      isPhone: true,
                      textEditingController: _emailEditingController,
                      validator: (String text) =>
                          FormUtils.validatePhone(text, context),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                      hint: "Password",
                      obscure: true,
                      textEditingController: _passwordEditingController,
                      validator: (String text) =>
                          FormUtils.validatePassword(text, context),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : PositiveButton(
                            onTap: () => _login(context),
                            text: "Login",
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () => _navigateToForgotPage(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Forgot your password?',
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
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () => _navigateToSignUp(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 14,
                            color: const Color(0xff7c7d7e),
                          ),
                          children: [
                            TextSpan(
                              text: 'Don\'t have an Account? ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign Up',
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
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    if (_globalKeyLoginPage.currentState.validate()) {
      _globalKeyLoginPage.currentState.save();
      setState(() {
        isLoading = true;
      });

      final Map<String, dynamic> successInformation = await _loginRepo.login(
          _emailEditingController.text, _passwordEditingController.text);
      setState(() {
        isLoading = false;
      });

      if (successInformation['error'] != null) {
        showSnackError(context, successInformation['error']);
      }

      if (successInformation['errors'] != null) {
        showSnackError(context, successInformation['message']);
      }

      if (successInformation['access_token'] != null) {
        await references.setAccessToken(successInformation['access_token'],
            successInformation['expires_in']);

        Timer.periodic(Duration(seconds: successInformation['expires_in']),
            (Timer t) => logoutUsr(context));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashBoardPage('')),
            (route) => false);
      }

      // BlocProvider.of<AuthenticationBloc>(context).add(
      //   LoginEvent(
      //     email: _emailEditingController.text,
      //     password: _passwordEditingController.text,
      //   ),
      // );
    }
  }

  logoutUsr(BuildContext context) async {
    await references.removeAccessToken();
    await references.removeAccessTokenOnly();
    await references.removeUserId();

    if (Platform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}

_navigateToForgotPage(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ForgetPassword(), fullscreenDialog: true));
}

_navigateToSignUp(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => RegisterPage()));
}
