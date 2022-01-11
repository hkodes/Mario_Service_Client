import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class FaresRepo {
  Future<Map<String, dynamic>> getFare(LatLng serviceRequestLocation,
      String providerLat, String providerLong, String serviceType) async {
    try {
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL +
          AppEndPoints.CALCULATE_FARE +
          '?s_latitude=' +
          serviceRequestLocation.latitude.toString() +
          '&s_longitude=' +
          serviceRequestLocation.longitude.toString() +
          '&d_latitude=' +
          providerLat +
          '&d_longitude=' +
          providerLong +
          '&service_type=' +
          serviceType);
      final http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer ' + token});
      data = json.decode(response.body);
      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {'error': 'Something went wrong'};
      return data;
    }
  }
}
