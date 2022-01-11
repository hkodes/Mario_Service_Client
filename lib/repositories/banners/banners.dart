import 'dart:async';
import 'dart:convert';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class BannersRepo {
  Future<List<Map<String, dynamic>>> getBanners() async {
    try {
      List<Map<String, dynamic>> data = [];
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url =
          Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.GET_BANNER_IMAGE);
      final http.Response response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      });
      List<dynamic> _data = json.decode(response.body);
      if (_data.length > 0) {
        for (int i = 0; i < _data.length; i++) {
          data.add({
            'id': _data[i]['id'],
            'url': _data[i]['url'],
            'video': _data[i]['video'],
            'position': _data[i]['position'],
            'status': _data[i]['status'],
            'created_at': _data[i]['created_at'],
            'updated_at': _data[i]['updated_at']
          });
        }
      }
      return data;
    } catch (err) {
      List<Map<String, dynamic>> data = [];
      return data;
    }
  }
}
