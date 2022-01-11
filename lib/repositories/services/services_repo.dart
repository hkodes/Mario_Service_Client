import 'dart:async';
import 'dart:convert';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class ServicesRepo {
  Future<List<Map<String, dynamic>>> getServices() async {
    try {
      List<Map<String, dynamic>> data = [];
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(
          AppEndPoints.BASE_URL + AppEndPoints.GET_SERVICE_CATEGORIES);
      final http.Response response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      });
      List<dynamic> _data = json.decode(response.body);
      print(_data);
      if (_data.length > 0) {
        for (int i = 0; i < _data.length; i++) {
          data.add({
            'id': _data[i]['id'],
            'name': _data[i]['name'],
            'provider_name': _data[i]['provider_name'],
            'image': _data[i]['image'],
            'marker': _data[i]['marker'],
            'fixed': _data[i]['fixed'],
            'price': _data[i]['price'],
            'type_price': _data[i]['type_price'],
            'calculator': _data[i]['calculator'],
            'description': _data[i]['description'],
            'status': _data[i]['status'],
            'children': []
          });

          if (_data[i]['children_recursive'].length > 0) {
            for (int j = 0; j < _data[i]['children_recursive'].length; j++) {
              data[i]['children'].add({
                'id': _data[i]['children_recursive'][j]['id'],
                'name': _data[i]['children_recursive'][j]['name'],
                'provider_name': _data[i]['children_recursive'][j]
                    ['provider_name'],
                'image': _data[i]['children_recursive'][j]['image'],
                'marker': _data[i]['children_recursive'][j]['marker'],
                'fixed': _data[i]['children_recursive'][j]['fixed'],
                'price': _data[i]['children_recursive'][j]['price'],
                'type_price': _data[i]['children_recursive'][j]['type_price'],
                'calculator': _data[i]['children_recursive'][j]['calculator'],
                'description': _data[i]['children_recursive'][j]['description'],
                'status': _data[i]['children_recursive'][j]['status'],
              });
            }
          }
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
