import 'dart:async';
import 'dart:convert';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:http/http.dart' as http;

class OrderRepo {
  Future<Map<String, dynamic>> scheduleOrder(
      String slat,
      String slong,
      String dlat,
      String dlong,
      String service,
      String scheduleD,
      String scheduleT) async {
    try {
      final Map<String, dynamic> formData = {
        's_latitude': slat,
        's_longitude': slong,
        'd_latitude': dlat,
        'd_longitude': dlong,
        'service_type': service,
        'payment_mode': 'CASH',
        'schedule_date': scheduleD,
        'schedule_time': scheduleT,
      };
      print(formData);
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.ORDER);
      final http.Response response =
          await http.post(url, body: json.encode(formData), headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ' + token
      });

      data = json.decode(response.body);
      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {
        'errors': 'error',
        'message': 'Something went wrong try again'
      };
      return data;
    }
  }

  Future<Map<String, dynamic>> requestOrder(
    String slat,
    String slong,
    String dlat,
    String dlong,
    String service,
  ) async {
    try {
      final Map<String, dynamic> formData = {
        's_latitude': slat,
        's_longitude': slong,
        'd_latitude': dlat,
        'd_longitude': dlong,
        'service_type': service,
        'payment_mode': 'CASH',
      };
      print(formData);
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.ORDER);
      final http.Response response =
          await http.post(url, body: json.encode(formData), headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ' + token
      });

      data = json.decode(response.body);
      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {
        'errors': 'error',
        'message': 'Something went wrong try again'
      };
      return data;
    }
  }

  Future<Map<String, dynamic>> cancelRequest(String requestID) async {
    try {
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL +
          AppEndPoints.CANCEL_ORDER +
          '?request_id=' +
          requestID);
      final http.Response response = await http.post(url, headers: {
        'Authorization': 'Bearer ' + token,
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
      });

      data = json.decode(response.body);

      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {
        'error': 'error',
        'message': 'Something went wrong try again'
      };
      return data;
    }
  }

  Future<List<Map<String, dynamic>>> getUpcomingTrips() async {
    try {
      List<Map<String, dynamic>> data = [];
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url1 = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.CHECK_ORDER);
      final http.Response response1 = await http.get(url1, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ' + token
      });

      print(url1);
      print(json.decode(response1.body)['data']);
      if (json.decode(response1.body)['data'] != null) {
        List<dynamic> _data1 = json.decode(response1.body)['data'];
        if (_data1.length > 0) {
          for (int i = 0; i < _data1.length; i++) {
            if (_data1[i]['status'] != 'COMPLETED') {
              data.add({
                'id': _data1[0]['id'],
                'booking_id': _data1[0]['booking_id'],
                'user_id': _data1[0]['user_id'],
                'estimated_fare': _data1[0]['estimated_fare'],
                'service_type_id': _data1[0]['service_type_id'],
                'before_image': _data1[0]['before_image'],
                'status': _data1[0]['status'],
                'cancelled_by': _data1[0]['cancelled_by'],
                'cancel_reason': _data1[0]['cancel_reason'],
                'payment_mode': _data1[0]['payment_mode'],
                'paid': _data1[0]['paid'],
                'is_track': _data1[0]['is_track'],
                'distance': _data1[0]['distance'],
                'travel_time': _data1[0]['travel_time'],
                'unit': _data1[0]['unit'],
                's_latitude': _data1[0]['s_latitude'],
                's_longitude': _data1[0]['s_longitude'],
                's_address': _data1[0]['s_address'],
                'd_address': _data1[0]['d_address'],
                'd_latitude': json.decode(_data1[0]['destination_log'])[0]
                    ['latitude'],
                'd_longitude': json.decode(_data1[0]['destination_log'])[0]
                    ['longitude'],
                'track_distance': _data1[0]['track_distance'],
                'track_latitude': _data1[0]['track_latitude'],
                'track_longitude': _data1[0]['track_longitude'],
                'is_drop_location': _data1[0]['is_drop_location'],
                'is_instant_ride': _data1[0]['is_instant_ride'],
                'is_dispute': _data1[0]['is_dispute'],
                'assigned_at': _data1[0]['assigned_at'],
                'schedule_at': _data1[0]['schedule_at'],
                'started_at': _data1[0]['started_at'],
                'finished_at': _data1[0]['finished_at'],
                'is_scheduled': _data1[0]['is_scheduled'],
                'user_rated': _data1[0]['user_rated'],
                'provider_rated': _data1[0]['provider_rated'],
                'route_key': _data1[0]['route_key'],
                'created_at': _data1[0]['created_at'],
                'updated_at': _data1[0]['updated_at'],
                'static_map': _data1[0]['static_map'],
                'service_type_name': _data1[0]['service_type']['name'],
                'service_type_provider': _data1[0]['service_type']
                    ['provider_name'],
                'service_type_image': _data1[0]['service_type']['image'],
                'service_type_marker': _data1[0]['service_type']['marker'],
                'service_type_fixed': _data1[0]['service_type']['fixed'],
                'service_type_description': _data1[0]['service_type']
                    ['description'],
                'service_type_price': _data1[0]['service_type']['price'],
                'after_image': _data1[0]['after_image']
              });

              if (_data1[i]['payment'] != null) {
                data[i]['payment_request_id'] =
                    _data1[0]['payment']['request_id'];
                data[i]['payment_fixed'] = _data1[0]['payment']['fixed'];
                data[i]['payment_distance'] = _data1[0]['payment']['distance'];
                data[i]['payment_time_price'] =
                    _data1[0]['payment']['time_price'];
                data[i]['payment_minute'] = _data1[0]['payment']['minute'];
                data[i]['payment_hour'] = _data1[0]['payment']['hour'];
                data[i]['payment_commission'] =
                    _data1[0]['payment']['commission'];
                data[i]['payment_commission_per'] =
                    _data1[0]['payment']['commission_per'];
                data[i]['payment_agent'] = _data1[0]['payment']['agent'];
                data[i]['payment_agent_per'] =
                    _data1[0]['payment']['agent_per'];
                data[i]['payment_discount'] = _data1[0]['payment']['discount'];
                data[i]['payment_dicount_per'] =
                    _data1[0]['payment']['discount_per'];
                data[i]['payment_tax'] = _data1[0]['payment']['tax'];
                data[i]['payment_tax_per'] = _data1[0]['payment']['tax_per'];
                data[i]['payment_cash'] = _data1[0]['payment']['cash'];
                data[i]['payment_round_of'] = _data1[0]['payment']['round_of'];
                data[i]['payment_peak_amount'] =
                    _data1[0]['payment']['peak_amount'];
                data[i]['payment_toll_charge'] =
                    _data1[0]['payment']['toll_charge'];
                data[i]['payment_peak_comm_amount'] =
                    _data1[0]['payment']['peak_comm_amount'];
                data[i]['payment_total_waiting_time'] =
                    _data1[0]['payment']['total_waiting_time'];
                data[i]['payment_waiting_amount'] =
                    _data1[0]['payment']['waiting_amount'];
                data[i]['payment_waiting_comm_amount'] =
                    _data1[0]['payment']['waiting_comm_amount'];
                data[i]['payment_tips'] = _data1[0]['payment']['tips'];
                data[i]['payment_total'] = _data1[0]['payment']['total'];
                data[i]['payment_payable'] = _data1[0]['payment']['payable'];
                data[i]['payment_provider_commission'] =
                    _data1[0]['payment']['provider_commission'];
                data[i]['payment_provider_pay'] =
                    _data1[0]['payment']['provider_pay'];
                data[i]['payment_id'] = _data1[0]['payment']['id'];
              }
            }
          }
        }
      }

      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.UPCOMING_TRIPS);
      final http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer ' + token});
      List<dynamic> _data = json.decode(response.body);
      if (_data.length > 0) {
        for (int i = 0; i < _data.length; i++) {
          data.add({
            'id': _data[i]['id'],
            'booking_id': _data[i]['booking_id'],
            'user_id': _data[i]['user_id'],
            'estimated_fare': _data[i]['estimated_fare'],
            'service_type_id': _data[i]['service_type_id'],
            'before_image': _data[i]['before_image'],
            'status': _data[i]['status'],
            'cancelled_by': _data[i]['cancelled_by'],
            'cancel_reason': _data[i]['cancel_reason'],
            'payment_mode': _data[i]['payment_mode'],
            'paid': _data[i]['paid'],
            'is_track': _data[i]['is_track'],
            'distance': _data[i]['distance'],
            'travel_time': _data[i]['travel_time'],
            'unit': _data[i]['unit'],
            's_latitude': _data[i]['s_latitude'],
            's_longitude': _data[i]['s_longitude'],
            's_address': _data[i]['s_address'],
            'd_address': _data[i]['d_address'],
            'd_latitude': _data[i]['d_latitude'],
            'd_longitude': _data[i]['d_longitude'],
            'track_distance': _data[i]['track_distance'],
            'track_latitude': _data[i]['track_latitude'],
            'track_longitude': _data[i]['track_longitude'],
            'is_drop_location': _data[i]['is_drop_location'],
            'is_instant_ride': _data[i]['is_instant_ride'],
            'is_dispute': _data[i]['is_dispute'],
            'assigned_at': _data[i]['assigned_at'],
            'schedule_at': _data[i]['schedule_at'],
            'started_at': _data[i]['started_at'],
            'finished_at': _data[i]['finished_at'],
            'is_scheduled': _data[i]['is_scheduled'],
            'user_rated': _data[i]['user_rated'],
            'provider_rated': _data[i]['provider_rated'],
            'route_key': _data[i]['route_key'],
            'created_at': _data[i]['created_at'],
            'updated_at': _data[i]['updated_at'],
            'static_map': _data[i]['static_map'],
            'service_type_name': _data[i]['service_type']['name'],
            'service_type_provider': _data[i]['service_type']['provider_name'],
            'service_type_image': _data[i]['service_type']['image'],
            'service_type_marker': _data[i]['service_type']['marker'],
            'service_type_fixed': _data[i]['service_type']['fixed'],
            'service_type_description': _data[i]['service_type']['description'],
            'service_type_price': _data[i]['service_type']['price'],
            'after_image': _data[i]['updated_at']
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

  Future<List<Map<String, dynamic>>> getTrips() async {
    try {
      List<Map<String, dynamic>> data = [];
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.USER_TRIPS);
      final http.Response response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      });
      List<dynamic> _data = json.decode(response.body);
      if (_data.length > 0) {
        for (int i = 0; i < _data.length; i++) {
          data.add({
            'id': _data[i]['id'],
            'booking_id': _data[i]['booking_id'],
            'user_id': _data[i]['user_id'],
            'estimated_fare': _data[i]['estimated_fare'],
            'service_type_id': _data[i]['service_type_id'],
            'before_image': _data[i]['before_image'],
            'status': _data[i]['status'],
            'cancelled_by': _data[i]['cancelled_by'],
            'cancel_reason': _data[i]['cancel_reason'],
            'payment_mode': _data[i]['payment_mode'],
            'paid': _data[i]['paid'],
            'is_track': _data[i]['is_track'],
            'distance': _data[i]['distance'],
            'travel_time': _data[i]['travel_time'],
            'unit': _data[i]['unit'],
            's_latitude': _data[i]['s_latitude'],
            's_longitude': _data[i]['s_longitude'],
            's_address': _data[i]['s_address'],
            'd_address': _data[i]['d_address'],
            'd_latitude': _data[i]['d_latitude'],
            'd_longitude': _data[i]['d_longitude'],
            'track_distance': _data[i]['track_distance'],
            'track_latitude': _data[i]['track_latitude'],
            'track_longitude': _data[i]['track_longitude'],
            'is_drop_location': _data[i]['is_drop_location'],
            'is_instant_ride': _data[i]['is_instant_ride'],
            'is_dispute': _data[i]['is_dispute'],
            'assigned_at': _data[i]['assigned_at'],
            'schedule_at': _data[i]['schedule_at'],
            'started_at': _data[i]['started_at'],
            'finished_at': _data[i]['finished_at'],
            'is_scheduled': _data[i]['is_scheduled'],
            'user_rated': _data[i]['user_rated'],
            'provider_rated': _data[i]['provider_rated'],
            'route_key': _data[i]['route_key'],
            'created_at': _data[i]['created_at'],
            'updated_at': _data[i]['updated_at'],
            'static_map': _data[i]['static_map'],
            'service_type_name': _data[i]['service_type']['name'],
            'payment_id': _data[i]['payment']['id'],
            'payment_request_id': _data[i]['payment']['request_id'],
            'payment_fixed': _data[i]['payment']['fixed'],
            'payment_distance': _data[i]['payment']['distance'],
            'payment_time_price': _data[i]['payment']['time_price'],
            'payment_minute': _data[i]['payment']['minute'],
            'payment_hour': _data[i]['payment']['hour'],
            'payment_commission': _data[i]['payment']['commission'],
            'payment_commission_per': _data[i]['payment']['commission_per'],
            'payment_agent': _data[i]['payment']['agent'],
            'payment_agent_per': _data[i]['payment']['agent_per'],
            'payment_discount': _data[i]['payment']['discount'],
            'payment_dicount_per': _data[i]['payment']['discount_per'],
            'payment_tax': _data[i]['payment']['tax'],
            'payment_tax_per': _data[i]['payment']['tax_per'],
            'payment_cash': _data[i]['payment']['cash'],
            'payment_round_of': _data[i]['payment']['round_of'],
            'payment_peak_amount': _data[i]['payment']['peak_amount'],
            'payment_toll_charge': _data[i]['payment']['toll_charge'],
            'payment_peak_comm_amount': _data[i]['payment']['peak_comm_amount'],
            'payment_total_waiting_time': _data[i]['payment']
                ['total_waiting_time'],
            'payment_waiting_amount': _data[i]['payment']['waiting_amount'],
            'payment_waiting_comm_amount': _data[i]['payment']
                ['waiting_comm_amount'],
            'payment_tips': _data[i]['payment']['tips'],
            'payment_total': _data[i]['payment']['total'],
            'payment_payable': _data[i]['payment']['payable'],
            'payment_provider_commission': _data[i]['payment']
                ['provider_commission'],
            'payment_provider_pay': _data[i]['payment']['provider_pay'],
            'service_type_provider': _data[i]['service_type']['provider_name'],
            'service_type_image': _data[i]['service_type']['image'],
            'service_type_marker': _data[i]['service_type']['marker'],
            'service_type_fixed': _data[i]['service_type']['fixed'],
            'service_type_description': _data[i]['service_type']['description'],
            'service_type_price': _data[i]['service_type']['price'],
            'after_image': _data[i]['updated_at']
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

  Future<Map<String, dynamic>> getRequest() async {
    try {
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.CHECK_ORDER);
      final http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer ' + token});

      if (json.decode(response.body)['data'] != null) {
        List<dynamic> _data = json.decode(response.body)['data'];
        print(_data);
        if (_data.length > 0) {
          print(json.decode(_data[0]['destination_log'])[0]);
          // for (int i = 0; i < _data.length; i++) {
          data = {
            'id': _data[0]['id'],
            'booking_id': _data[0]['booking_id'],
            'user_id': _data[0]['user_id'],
            'estimated_fare': _data[0]['estimated_fare'],
            'service_type_id': _data[0]['service_type_id'],
            'before_image': _data[0]['before_image'],
            'status': _data[0]['status'],
            'cancelled_by': _data[0]['cancelled_by'],
            'cancel_reason': _data[0]['cancel_reason'],
            'payment_mode': _data[0]['payment_mode'],
            'paid': _data[0]['paid'],
            'is_track': _data[0]['is_track'],
            'distance': _data[0]['distance'],
            'travel_time': _data[0]['travel_time'],
            'unit': _data[0]['unit'],
            's_latitude': _data[0]['s_latitude'],
            's_longitude': _data[0]['s_longitude'],
            's_address': _data[0]['s_address'],
            'd_address': _data[0]['d_address'],
            'd_latitude': json.decode(_data[0]['destination_log'])[0]
                ['latitude'],
            'd_longitude': json.decode(_data[0]['destination_log'])[0]
                ['longitude'],
            'track_distance': _data[0]['track_distance'],
            'track_latitude': _data[0]['track_latitude'],
            'track_longitude': _data[0]['track_longitude'],
            'is_drop_location': _data[0]['is_drop_location'],
            'is_instant_ride': _data[0]['is_instant_ride'],
            'is_dispute': _data[0]['is_dispute'],
            'assigned_at': _data[0]['assigned_at'],
            'schedule_at': _data[0]['schedule_at'],
            'started_at': _data[0]['started_at'],
            'finished_at': _data[0]['finished_at'],
            'is_scheduled': _data[0]['is_scheduled'],
            'user_rated': _data[0]['user_rated'],
            'provider_rated': _data[0]['provider_rated'],
            'route_key': _data[0]['route_key'],
            'created_at': _data[0]['created_at'],
            'updated_at': _data[0]['updated_at'],
            'static_map': _data[0]['static_map'],
            'service_type_name': _data[0]['service_type']['name'],
            'service_type_provider': _data[0]['service_type']['provider_name'],
            'service_type_image': _data[0]['service_type']['image'],
            'service_type_marker': _data[0]['service_type']['marker'],
            'service_type_fixed': _data[0]['service_type']['fixed'],
            'service_type_description': _data[0]['service_type']['description'],
            'service_type_price': _data[0]['service_type']['price'],
            'after_image': _data[0]['after_image']
          };

          if (_data[0]['payment'] != null) {
            data['payment_request_id'] = _data[0]['payment']['request_id'];
            data['payment_fixed'] = _data[0]['payment']['fixed'];
            data['payment_distance'] = _data[0]['payment']['distance'];
            data['payment_time_price'] = _data[0]['payment']['time_price'];
            data['payment_minute'] = _data[0]['payment']['minute'];
            data['payment_hour'] = _data[0]['payment']['hour'];
            data['payment_commission'] = _data[0]['payment']['commission'];
            data['payment_commission_per'] =
                _data[0]['payment']['commission_per'];
            data['payment_agent'] = _data[0]['payment']['agent'];
            data['payment_agent_per'] = _data[0]['payment']['agent_per'];
            data['payment_discount'] = _data[0]['payment']['discount'];
            data['payment_dicount_per'] = _data[0]['payment']['discount_per'];
            data['payment_tax'] = _data[0]['payment']['tax'];
            data['payment_tax_per'] = _data[0]['payment']['tax_per'];
            data['payment_cash'] = _data[0]['payment']['cash'];
            data['payment_round_of'] = _data[0]['payment']['round_of'];
            data['payment_peak_amount'] = _data[0]['payment']['peak_amount'];
            data['payment_toll_charge'] = _data[0]['payment']['toll_charge'];
            data['payment_peak_comm_amount'] =
                _data[0]['payment']['peak_comm_amount'];
            data['payment_total_waiting_time'] =
                _data[0]['payment']['total_waiting_time'];
            data['payment_waiting_amount'] =
                _data[0]['payment']['waiting_amount'];
            data['payment_waiting_comm_amount'] =
                _data[0]['payment']['waiting_comm_amount'];
            data['payment_tips'] = _data[0]['payment']['tips'];
            data['payment_total'] = _data[0]['payment']['total'];
            data['payment_payable'] = _data[0]['payment']['payable'];
            data['payment_provider_commission'] =
                _data[0]['payment']['provider_commission'];
            data['payment_provider_pay'] = _data[0]['payment']['provider_pay'];
            data['payment_id'] = _data[0]['payment']['id'];
          }
          // }
        }
      }

      return data;
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {};
      return data;
    }
  }

  Future<Map<String, dynamic>> rateTrip(
      String tripId, int rating, String comment) async {
    try {
      bool hasError = true;
      String message = 'Could not rate,try again';
      Map<String, dynamic> params = {
        'request_id': int.parse(tripId),
        'rating': rating,
        'comment': comment
      };
      Map<String, dynamic> data = {};
      SharedReferences references = new SharedReferences();
      String token = await references.getAccessToken();
      Uri url = Uri.parse(AppEndPoints.BASE_URL + AppEndPoints.SUBMIT_REVIEW_1)
          .replace(queryParameters: params);
      final http.Response response = await http.post(url, headers: {
        'Authorization': 'Bearer ' + token,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      });

      if (response.statusCode == 200) {
        hasError = false;
        message = "Thankyou for the review";
      }
      return {'success': !hasError, 'message': message};
    } catch (err) {
      print(err);
      Map<String, dynamic> data = {'error': 'Something went wrong try again'};
      return data;
    }
  }
}
