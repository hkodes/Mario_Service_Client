import 'dart:async';

import 'dart:convert';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/resources/app_constants.dart';
import 'package:http/http.dart' as http;

class CheckApi {
  Future<Map<String, dynamic>> check() async {
    try {
      Map<String, dynamic> data = {};
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.CHECK_API);
      final http.Response response = await http.get(url);
      data = json.decode(response.body);
      return data;
    } catch (err) {
      Map<String, dynamic> data = {'sucess': false};
      return data;
    }
  }

  Future<bool> checkResponse(String response) async {
    bool isError = false;
    final SharedReferences prefs = new SharedReferences();
    if (response == 'Login to Continue.') {
      prefs.removeAccessToken();
      isError = true;
    }

    return isError;
  }
  // if (responseData["name"] != null) {
  //   hasError = false;
  //   message = "Shop Successfully";
  // }

  // return {'success': !hasError, 'message': message};
}
