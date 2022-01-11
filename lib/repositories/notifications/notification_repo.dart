import 'dart:async';
import 'dart:convert';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class NotificationRepo {
  Future<List<Map<String, dynamic>>> getUserNotification() async {
    try {
      List<Map<String, dynamic>> data = [];
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url =
          Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.GET_NOTIFICAION_LIST);
      final http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer ' + token});
      List<dynamic> _data = json.decode(response.body);
      if (_data.length > 0) {
        for (int i = 0; i < _data.length; i++) {
          data.add({
            'id': _data[i]['id'],
            'notify_type': _data[i]['notify_type'],
            'image': _data[i]['image'],
            'description': _data[i]['description'],
            'status': _data[i]['status'],
            'expiry_date': _data[i]['expiry_date']
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
