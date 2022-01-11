import 'package:flutter/material.dart';
import 'package:mario_service/utils/form_util.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/imported/text_field.dart';
import 'package:mario_service/views/login/login.dart';
import 'package:mario_service/repositories/authentication/login_repo.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/views/verify_otp/verify_otp.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final LoginRepo _loginRepo = new LoginRepo();
  final SharedReferences references = new SharedReferences();
  final TextEditingController ftNameEditingController =
      TextEditingController(text: "");
  final TextEditingController lNameEditingController =
      TextEditingController(text: "");
  final TextEditingController emailEditingController =
      TextEditingController(text: "");
  // final TextEditingController cCodeEditingController = TextEditingController();
  final TextEditingController mobileEditingController =
      TextEditingController(text: "");
  final TextEditingController passEditingController =
      TextEditingController(text: "");
  final GlobalKey<FormState> _globalKeyRegisterPage = GlobalKey();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _globalKeyRegisterPage,
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
                      'Sign Up',
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
                      'Add your details to sign up',
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextField(
                          hint: "First name",
                          textEditingController: ftNameEditingController,
                          validator: (String text) =>
                              FormUtils.validateFirstName(text, context),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                          hint: "Last name",
                          textEditingController: lNameEditingController,
                          validator: (String text) =>
                              FormUtils.validateLastName(text, context),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                          hint: "Email",
                          textEditingController: emailEditingController,
                          validator: (String text) =>
                              FormUtils.validateEmail(text, context),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                          hint: "Mobile No",
                          isPhone: true,
                          textEditingController: mobileEditingController,
                          validator: (String text) =>
                              FormUtils.validatePhone(text, context),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                          hint: "Password",
                          obscure: true,
                          textEditingController: passEditingController,
                          validator: (String text) =>
                              FormUtils.validatePassword(text, context),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : PositiveButton(
                                onTap: () => _signUp(context),
                                text: "Sign Up",
                              ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () => {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()))
                  },
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 14,
                        color: const Color(0xff7c7d7e),
                      ),
                      children: [
                        TextSpan(
                          text: 'Already have an Account? ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
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
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signUp(BuildContext context) async {
    if (_globalKeyRegisterPage.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> _validateMail =
          await _loginRepo.checkEmail(emailEditingController.text);

      if (_validateMail['is_available']) {
        //showSnackSuccess(context, _validateMail['message']);
        Map<String, dynamic> _register = await _loginRepo.register(
            mobileEditingController.text,
            emailEditingController.text,
            ftNameEditingController.text,
            lNameEditingController.text,
            passEditingController.text);

        if (_register['error'] != null) {
          showSnackError(context, _register['error']);
        } else {
          await references.setAccessTokenOnly(_register['access_token']);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OtpPage(mobileEditingController.text, null)));
        }
      } else {
        showSnackError(context, _validateMail['message']);
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}
