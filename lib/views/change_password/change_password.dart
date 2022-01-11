import 'package:flutter/material.dart';
import 'package:mario_service/repositories/authentication/login_repo.dart';
import 'package:mario_service/utils/form_util.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/imported/text_field.dart';
import 'package:mario_service/views/login_register/login_register.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordState();
  }
}

class ChangePasswordState extends State<ChangePasswordPage> {
  final LoginRepo _loginRepo = new LoginRepo();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final GlobalKey<FormState> _globalKeyChangePassword = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change Password"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StripContainer(
                  child: Form(
                    key: _globalKeyChangePassword,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          hint: "Old Password",
                          obscure: true,
                          textEditingController: _oldPasswordController,
                          validator: (String text) =>
                              FormUtils.validatePassword(text, context),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CustomTextField(
                          hint: "New Password",
                          obscure: true,
                          textEditingController: _newPasswordController,
                          validator: (String text) =>
                              FormUtils.validatePassword(text, context),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CustomTextField(
                          hint: "Password Confirmation",
                          obscure: true,
                          textEditingController: _passwordConfirmController,
                          validator: (String text) =>
                              FormUtils.validateConfirmationPassword(
                                  text, context, _newPasswordController.text),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            BottomButton(
              onTap: () {
                if (FocusScope.of(context).isFirstFocus) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
                if (_globalKeyChangePassword.currentState.validate()) {
                  changePassword(
                      context,
                      _newPasswordController.text,
                      _oldPasswordController.text,
                      _passwordConfirmController.text);
                  // changePasswordBloc.add(
                  //   UpdatePasswordEvent(
                  //     changePasswordRequest: ChangePasswordRequestEntity(
                  //       password: _newPasswordController.text,
                  //       oldPassword: _oldPasswordController.text,
                  //       passwordConfirmation:
                  //           _passwordConfirmController.text,
                  //     ),
                  //   ),
                  // );
                }
              },
              title: "Update Password",
              enabled: !loading,
              isPositive: true,
            )
          ],
        ));
  }

  void changePassword(
      BuildContext context, String text, String text2, String text3) async {
    setState(() {
      loading = true;
    });

    Map<String, dynamic> _result =
        await _loginRepo.changePassword(text2, text, text3);

    if (_result['error'] != null) {
      showSnackError(context, _result['error']);
      if (_result['error'] == 'Login to Continue.') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginRegisterPage()),
            (route) => false);
        return;
      }
    } else {
      showSnackSuccess(context, _result['message']);
    }

    setState(() {
      loading = false;
    });
  }
}
