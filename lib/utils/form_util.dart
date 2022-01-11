import 'package:flutter/material.dart';

class FormUtils {
  static String validateEmail(String value, BuildContext context) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "please enter email";
    } else if (!regExp.hasMatch(value)) {
      return "invalid Email";
    } else {
      return null;
    }
  }

  static String validatePassword(String password, BuildContext context) {
    if (password.length < 6) {
      return "minimum password length is 6";
    } else if (password.length == 0) {
      return 'please enter password';
    } else
      return null;
  }

  static String validateConfirmationPassword(
      String password, BuildContext context, String confirmPassword) {
    if (password.length < 8) {
      return "password cannot be less than 8 length character";
    } else if (password != confirmPassword) {
      return "passwords does not matches";
    }
    return null;
  }

  static String validateFirstName(String name, BuildContext context) {
    if (name.length == 0) {
      return "please enter first name";
    } else
      return null;
  }

  static String validateMessage(String name, BuildContext context) {
    if (name.length == 0) {
      return "please enter a message";
    } else
      return null;
  }

  static String validateLastName(String name, BuildContext context) {
    if (name.length == 0) {
      return "please enter last name";
    } else
      return null;
  }

  static String validateSurname(String name, BuildContext context) {
    if (name.length == 0) {
      return "please enter surname";
    } else
      return null;
  }

  static String validatePostCode(String name, BuildContext context) {
    if (name.length == 0) {
      return "please enter post code";
    } else
      return null;
  }

  static validatePhone(String text, BuildContext context) {
    if (text.length == 0) {
      return "please enter phone number";
    } else if (text.length != 10) {
      return "please enter a valid phone number(10 digit)";
    } else
      return null;
  }

  static validateAccountNumber(String text, BuildContext context) {
    if (text.length == 0) {
      return "please enter your bank account number";
    } else
      return null;
  }

  static validateSortCode(String text, BuildContext context) {
    if (text.length == 0) {
      return "please enter your sort code";
    } else
      return null;
  }

  static validateBankName(String text, BuildContext context) {
    if (text.length == 0) {
      return "please enter your bank name";
    } else
      return null;
  }

  static validateDateOfBirth(String text, BuildContext context) {
    if (text.length == 0) {
      return "please enter your date of birth";
    } else
      return null;
  }

  static validateNationalInsurance(String text, BuildContext context) {
    if (text.length == 0) {
      return "please enter your national insurance number";
    } else
      return null;
  }

// static validateAge(String text) {
//   try {
//     int.parse(text);
//     if (text.length == 0) {
//       return "Please enter your pets age";
//     } else
//       return null;
//   } on FormatException {
//     return "The age is Invalid";
//   } catch (e) {
//     return e.toString();
//   }
// }
//
// static validateRace(String text) {
//   if (text.length == 0) {
//     return "Please enter your pets race/breed";
//   } else
//     return null;
// }
}
