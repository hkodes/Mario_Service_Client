import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class ProvidersRepo {
  Future<List<Map<String, dynamic>>> getProviders() async {
    try {
      List<Map<String, dynamic>> data = [];
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      LatLng latlong = await references.getLatLng();
      Uri url = Uri.parse(AppEndPoints.BASE_URL +
          AppEndPoints.GET_SERVICE_PROVIDER +
          '?latitude=' +
          latlong.latitude.toString() +
          '&longitude=' +
          latlong.longitude.toString());
      final http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer ' + token});
      List<dynamic> _data = json.decode(response.body);
      if (_data.length > 0) {
        for (int i = 0; i < _data.length; i++) {
          data.add({
            'id': _data[i]['id'],
            'first_name': _data[i]['first_name'],
            'last_name': _data[i]['last_name'],
            'email': _data[i]['email'],
            'gender': _data[i]['gender'],
            'mobile': _data[i]['mobile'],
            'status': _data[i]['status'],
            'latitude': _data[i]['latitude'],
            'longitude': _data[i]['longitude'],
            'rating': _data[i]['rating'],
            'avatar': _data[i]['avatar'],
          });
        }
      }
      return data;
    } catch (err) {
      print(err);
      List<Map<String, dynamic>> data = [];
      return data;
    }
  }
}
