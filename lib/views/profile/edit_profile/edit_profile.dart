import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/repositories/users/user_repo.dart';

import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/common/dialog.dart';
import 'package:mario_service/views/login_register/login_register.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userModel;
  EditProfile(this.userModel);
  // final UserDetailModel userDetailModel;

  @override
  State<StatefulWidget> createState() {
    return EditProfileState(this.userModel);
  }
}

class EditProfileState extends State<EditProfile> {
  SharedReferences references = new SharedReferences();
  final UserRepo _userRepo = new UserRepo();
  final Map<String, dynamic> userModel;
  EditProfileState(this.userModel);
  TextEditingController _firstNameController,
      _lastNameController,
      _emailController,
      _mobileController;
  int _genderGroupValue = 99;
  MultipartFile multipartFile;
  File file;

  @override
  void initState() {
    _setNew(userModel['gender']);
    // if (widget.userDetailModel == null)
    // userDetailBloc.add(BLoadData());
    // else {
    // userDetailModel = widget.userDetailModel;
    _setUp();
    // }
    super.initState();
  }

  bool btnEnabled = true;

  @override
  void dispose() {
    // userDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: editProfileContent(),
    );
  }

  Widget editProfileContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StripContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          _showImagePicker(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade200,
                              child: Center(
                                child: file == null || multipartFile == null
                                    ? CachedNetworkImage(
                                        imageUrl: "",
                                        // userDetailModel.picture ?? "",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.person,
                                          size: 75,
                                        ),
                                        width: 75,
                                        height: 75,
                                      )
                                    : Image.file(file),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EditableTextField(
                              textTitle: "First Name",
                              textBody: this.userModel['first_name'],
                              textEditingController: _firstNameController,
                            ),
                          ),
                          Expanded(
                            child: EditableTextField(
                              textTitle: "Last Name",
                              textBody: this.userModel['last_name'],
                              //  userDetailModel.lastName,
                              textEditingController: _lastNameController,
                            ),
                          ),
                        ],
                      ),
                      EditableTextField(
                        textTitle: "Email",
                        textBody: this.userModel['email'],
                        // userDetailModel.email,
                        textEditingController: _emailController,
                      ),
                      EditableTextField(
                        textTitle: "Phone",
                        textBody: getPhone(this.userModel['country_code'],
                            this.userModel['mobile']),
                        textEditingController: _mobileController,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Gender"),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: _genderGroupValue,
                                onChanged: (newValue) {
                                  _genderGroupValue = newValue;
                                  setState(() {});
                                },
                              ),
                              Text("Male")
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _genderGroupValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _genderGroupValue = newValue;
                                  });
                                },
                              ),
                              Text("Female")
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: _genderGroupValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _genderGroupValue = newValue;
                                  });
                                },
                              ),
                              Text("Other")
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        BottomButton(
          title: 'Save',
          onTap: () => _submitData(context),
          isPositive: true,
          enabled: btnEnabled,
        ),
      ],
    );
  }

  void _setUp() {
    _firstNameController =
        TextEditingController(text: this.userModel['first_name']);
    _lastNameController =
        TextEditingController(text: this.userModel['last_name']);
    _emailController = TextEditingController(text: this.userModel['email']);
    _mobileController = TextEditingController(text: this.userModel['mobile']);
    // _setNew("MALE");
  }

  _getGenderText(int genderGroupValue) {
    if (_genderGroupValue == 0) {
      return "MALE";
    } else if (_genderGroupValue == 1) {
      return "FEMALE";
    } else if (_genderGroupValue == 2) {
      return "OTHER";
    } else
      return null;
  }

  void _setNew(String gender) {
    setState(() {
      if (gender == "MALE") {
        _genderGroupValue = 0;
      } else if (gender == "FEMALE") {
        _genderGroupValue = 1;
      } else if (gender == "OTHER") {
        _genderGroupValue = 2;
      } else
        _genderGroupValue = 99;
    });
  }

  void _showImagePicker(BuildContext context) async {
    DialogUtils.showImageSourceDialog(
      context,
      (path) {
        if (path != null) {
          print(path);
          _setImage(path);
        }
        // profilePageBloc.add(
        //   UploadImage(path: path),
        // );
      },
    );
  }

  void _submitData(BuildContext context) async {
    setState(() {
      btnEnabled = false;
    });

    Map<String, dynamic> _result = await _userRepo.updateUserDetails(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _mobileController.text,
        _getGenderText(_genderGroupValue),
        multipartFile);

    print(_result);

    if (_result['error'] == 'Login to Continue.') {
      await references.removeAccessToken();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
      return;
    }

    if (_result['errors'] != null) {
      showSnackError(context, _result['message']);
    } else {
      showSnackSuccess(context, 'Profile Updated Successfully');
    }

    setState(() {
      btnEnabled = true;
    });

    if (FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  Future<void> _setImage(String path) async {
    multipartFile = await MultipartFile.fromFile(path);
    file = File(path);
    setState(() {});
  }
}
