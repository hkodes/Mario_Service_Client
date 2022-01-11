import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedReferences {
  var isFirst = true;

  Future<bool> getPrefernce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirst = prefs.getBool('isFirstTime');
    return isFirst;
  }

  Future<void> setPrefernce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstTime', false);
  }

  Future<void> setAccessToken(String token, int expiry) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await getAccessToken() != null) {
      await removeAccessToken();
    }
    prefs.setString('access_token', token);
    prefs.setInt('expiry', expiry);
  }

  Future<void> setAccessTokenOnly(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await getAccessToken() != null) {
      await removeAccessTokenOnly();
    }
    prefs.setString('access_token', token);
  }

  Future<void> setUserId(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await getUserId() != null) {
      await removeUserId();
    }
    prefs.setInt('userId', id);
  }

  Future<String> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> removeAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    prefs.remove('expiry');
  }

  Future<void> removeAccessTokenOnly() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
  }

  Future<void> removeUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  Future<void> setLatLng(double lat, double long) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('user_latitiude', lat);
    prefs.setDouble('user_longitude', long);
  }

  Future<LatLng> getLatLng() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('user_latitiude');
    double longitude = prefs.getDouble('user_longitude');

    return LatLng(latitude, longitude);
  }

  Future<Map<String, dynamic>> getLocation() async {
    Map<String, dynamic> _data = {};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getDouble('user_latitude') != null) {
      _data['latitude'] = prefs.getDouble('user_latitiude');
    }

    if (prefs.getDouble('user_longitude') != null) {
      _data['longitude'] = prefs.getDouble('user_longitude');
    }

    // _data['longitude'] = prefs.getDouble('user_longitude');
    return _data;
  }
}
