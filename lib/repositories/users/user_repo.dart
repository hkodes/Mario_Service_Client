import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class UserRepo {
  Future<Map<String, dynamic>> getUserDetail() async {
    try {
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url =
          Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.GET_USER_DETAIL_S);
      final http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer ' + token});
      data = json.decode(response.body);
      return data;
    } catch (err) {
      Map<String, dynamic> data = {'sucess': false};
      return data;
    }
  }

  Future<Map<String, dynamic>> updateUserDetails(
      String fName,
      String lName,
      String email,
      String phone,
      String gender,
      MultipartFile multipartFile) async {
    try {
      String picture = '';
      if (multipartFile != null) {
        picture = '&picture=' + multipartFile.toString();
      }
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL +
          AppEndPoints.UPDATE_USER_DETAIL +
          '?first_name=' +
          fName +
          '&last_name=' +
          lName +
          '&email=' +
          email +
          '&mobile=' +
          phone +
          '&gender=' +
          gender +
          picture);
      final http.Response response = await http.post(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ' + token
      });
      data = json.decode(response.body);
      return data;
    } catch (err) {
      Map<String, dynamic> data = {
        'errors:': 'error',
        'message': 'Could not update'
      };
      return data;
    }
  }
}
