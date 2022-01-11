import 'dart:async';
import 'dart:convert';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class PromoCodeRepo {
  Future<List<Map<String, dynamic>>> getUserPromo() async {
    try {
      List<Map<String, dynamic>> data = [];
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.GET_PROMO_CODE);
      final http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer ' + token});
      List<dynamic> _data = json.decode(response.body);
      if (_data.length > 0) {
        for (int i = 0; i < _data.length; i++) {
          data.add({
            'id': _data[i]['id'],
            'promo_code': _data[i]['promo_code'],
            'percentage': _data[i]['percentage'],
            'max_amount': _data[i]['max_amount'],
            'promo_description': _data[i]['promo_description'],
            'expiration': _data[i]['expiration'],
            'status': _data[i]['status'],
            'deleted_at': _data[i]['deleted_at'],
            'created_at': _data[i]['created_at']
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
