import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class RouteRequest {
  final LatLng myPosition;
  final LatLng providerPosition;

  RouteRequest({@required this.myPosition, @required this.providerPosition});
  @override
  String toString() {
    return myPosition.toString() + "\n" + providerPosition.toString();
  }
}
