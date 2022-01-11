import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/device_info/device_info.dart';
import 'package:http/http.dart' as http;

class LoginRepo {
  Future<Map<String, dynamic>> login(String number, String password) async {
    try {
      Map<String, dynamic> data = {};
      DeviceInfoLocalDataSource deviceInfo = new DeviceInfoLocalDataSource();
      String device_type = deviceInfo.getDeviceType();
      String device_token = await deviceInfo.getDeviceToken();
      String device_id = await deviceInfo.getDeviceId();
      final Map<String, dynamic> formData = {
        'client_id': AppEndPoints.CLIENT_ID,
        'client_secret': AppEndPoints.CLIENT_SECRET,
        'username': number,
        'password': password,
        'device_type': device_type,
        'device_token': device_token,
        'device_id': device_id,
      };
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.USER_LOGIN);
      final http.Response response = await http.post(url,
          body: json.encode(formData),
          headers: {'Content-Type': 'application/json'});
      data = json.decode(response.body);
      return data;
    } catch (err) {
      Map<String, dynamic> data = {'error': 'Something went wrong. Try again.'};
      return data;
    }
  }

  Future<Map<String, dynamic>> register(String number, String email,
      String f_name, String l_name, String password) async {
    try {
      Map<String, dynamic> data = {};
      DeviceInfoLocalDataSource deviceInfo = new DeviceInfoLocalDataSource();
      String device_type = deviceInfo.getDeviceType();
      String device_token = await deviceInfo.getDeviceToken();
      String device_id = await deviceInfo.getDeviceId();
      final Map<String, dynamic> formData = {
        'device_type': device_type,
        'device_token': device_token,
        'device_id': device_id,
        'login_by': 'manual',
        'first_name': f_name,
        'last_name': l_name,
        'email': email,
        'country_code': '+977',
        'mobile': number,
        'password': password,
      };

      // print(formData);
      // return false;
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.USER_SIGN_UP);
      final http.Response response =
          await http.post(url, body: json.encode(formData), headers: {
        'Accept': 'application/json',
        'Accept-Encoding': 'application/x-www-form-urlencoded',
        'Content-Type': 'application/json'
      });
      data = json.decode(response.body);
      return data;
    } catch (err) {
      Map<String, dynamic> data = {'error': 'Something went wrong. Try again.'};
      return data;
    }
  }

  Future<Map<String, dynamic>> checkEmail(String email) async {
    try {
      Map<String, dynamic> data = {};

      final Map<String, dynamic> formData = {
        'email': email,
      };
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.CHECK_EMAIL);
      final http.Response response = await http.post(url,
          body: json.encode(formData),
          headers: {'Content-Type': 'application/json'});
      data = json.decode(response.body);
      return data;
    } catch (err) {
      Map<String, dynamic> data = {'sucess': false};
      return data;
    }
  }

  Future<Map<String, dynamic>> validateOtp(String number, String otp) async {
    try {
      Map<String, dynamic> data = {};

      final Map<String, dynamic> formData = {'mobile': number, 'otp_code': otp};
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.VALIDATE_OTP);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final http.Response response =
          await http.post(url, body: json.encode(formData), headers: headers);

      print(response.body);
      data = json.decode(response.body);
      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {
        'errors': 'Something went wrong. Try Again.'
      };
      return data;
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String number) async {
    try {
      Map<String, dynamic> data = {};

      final Map<String, dynamic> formData = {'mobile': number};
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.FORGOT_PASSWORD);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Encoding': 'application/json',
      };
      final http.Response response =
          await http.post(url, body: json.encode(formData), headers: headers);

      print(response.body);
      data = json.decode(response.body);
      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {
        'errors': 'error',
        'message': 'Something went wrong, try again'
      };
      return data;
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String id, String password, String confirm) async {
    try {
      Map<String, dynamic> data = {};

      final Map<String, dynamic> formData = {
        'id': id,
        'password': password,
        'password_confirmation': confirm
      };
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.RESET_PASSWORD);
      final headers = {
        'Accept': 'application/json',
        'Accept-Encoding': 'application/json',
        'Content-Type': 'application/json'
      };
      final http.Response response =
          await http.post(url, body: json.encode(formData), headers: headers);

      if (response.statusCode == 200) {
        data = {'success': true, 'message': 'Password reset successfully'};
      } else {
        data = json.decode(response.body);
      }

      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {
        'errors': 'error',
        'message': 'Something went wrong, try again'
      };
      return data;
    }
  }

  Future<Map<String, dynamic>> changePassword(
      String old, String password, String confirm) async {
    try {
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL +
          AppEndPoints.CHANGE_PASSWORD +
          '?old_password=' +
          old +
          '&password=' +
          password +
          '&password_confirmation=' +
          confirm);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ' + token
      };
      final http.Response response = await http.post(url, headers: headers);

      print(response.body);
      data = json.decode(response.body);
      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {
        'error': 'Something went wrong, try again',
      };
      return data;
    }
  }
}
