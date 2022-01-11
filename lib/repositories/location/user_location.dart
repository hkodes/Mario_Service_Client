import 'dart:async';
import 'dart:convert';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class UserLocationRepo {
  Future<Map<String, dynamic>> getUsersLocation() async {
    try {
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.USER_LOCATION);
      final http.Response response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ' + token
      });
      print(response.body);
      data = json.decode(response.body);

      return data;
    } catch (err) {
      Map<String, dynamic> data = {};
      return data;
    }
  }

  Future<Map<String, dynamic>> setUsersLocation(
      String address, double lat, double long, String type) async {
    try {
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL +
          AppEndPoints.USER_LOCATION +
          '?address=' +
          address +
          '&latitude=' +
          lat.toString() +
          '&longitude=' +
          long.toString() +
          '&type=' +
          type);
      final http.Response response = await http.post(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ' + token
      });

// print(url);
      print(response.body);
      data = json.decode(response.body);
      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {'error': 'Error While Updating'};
      return data;
    }
  }

  Future<Map<String, dynamic>> updateUserLocation(
      double lat, double long) async {
    try {
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      final Map<String, dynamic> formData = {
        'latitude': lat.toString(),
        'longitude': long.toString(),
      };
      Uri url = Uri.parse(AppEndPoints.BASE_URL +
          AppEndPoints.UPDATE_USER_LOCATION_UPDATE_USER_LOCATION);
      final http.Response response =
          await http.post(url, body: json.encode(formData), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ' + token
      });
      data = json.decode(response.body);
      return data;
    } catch (err) {
      Map<String, dynamic> data = {'error': 'Error While Updating'};
      return data;
    }
  }
}
