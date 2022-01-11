import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mario_service/imported/text_field.dart';
import 'package:mario_service/repositories/firebase_response/firebase_response.dart';
import 'package:mario_service/repositories/order/order_repo.dart';
import 'package:mario_service/repositories/promo_code/promo_code_repo.dart';
import 'package:mario_service/repositories/providers/provider_repo.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/utils/form_util.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:mario_service/views/schedule_service/book_later.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
// import 'package:mario_service/views/map_order/bottom_ui.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mario_service/views/dashboard/dashboard.dart';

import 'package:wakelock/wakelock.dart';

class MapOrder extends StatefulWidget {
  final Map<String, dynamic> serviceCategoryModelList;
  final bool fromHistory;

  final Map<String, dynamic> status;

  const MapOrder(this.serviceCategoryModelList, this.fromHistory, this.status);

  @override
  State<MapOrder> createState() => MapSampleState();
}

class MapSampleState extends State<MapOrder> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final SharedReferences _sharedReferences = new SharedReferences();
  final ProvidersRepo _providerRepo = new ProvidersRepo();
  final StopWatchTimer _stopwatchTimer = new StopWatchTimer();
  final OrderRepo _orderRepo = new OrderRepo();
  List<Map<String, dynamic>> _providersInfo = [];
  LatLng _serviceLatlng = LatLng(0.0, 0.0);
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController googleMapController;
  //*List of Marker each representing a unique vendor
  Set<Marker> markers = {};
  bool _isHours = true;
  bool addedMarker = false;

  bool _isPressed = false;
  //*Polilines for ios
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<String, dynamic> serviceCategoryModelList;
  Map<String, dynamic> _tripInfo = {};
  bool isLoaded = false;
  bool isHistory = false;
  int serviceId = 0;

  final TextEditingController _commentEditingController =
      TextEditingController(text: "");

  bool _isRating = false;
  double rating = 0.0;

//latlng
  String latitude, longitude;

  static final CameraPosition _kGoogleComplex = CameraPosition(
    target: LatLng(27.7272, 86.3250),
    zoom: 20,
  );
  bool isLoading = false;

  bool enabled = true;
  String _mapStyle;
  BitmapDescriptor pinProviderIcon, pinUserIcon;
  StreamSubscription<Event> updates;
  LatLng updatedValue;

  @override
  void initState() {
    isHistory = widget.fromHistory;
    _tripInfo = widget.status;
    print('trip info ${widget.status}');
    getProviders();
    super.initState();
    Wakelock.enable();

    // mapBloc.listenToPushNotification();
    if (widget.serviceCategoryModelList != null)
      serviceCategoryModelList = widget.serviceCategoryModelList;

    if (!isHistory) {
      serviceId = serviceCategoryModelList['id'];
    } else {
      serviceId = int.parse(serviceCategoryModelList['service_type_id']);
    }

    print(serviceCategoryModelList);

    //*Load Custom Map Style theme
    rootBundle.loadString('assets/google_map_style.txt').then((string) {
      _mapStyle = string;
    });

    //*Load Custom pointer
    setCustomMapPin().then((value) {
      // if (serviceCategoryModelList != null)
      //   mapBloc.add(LoadAllServiceProviderList(
      //       serviceId: serviceCategoryModelList.parentId));
      // else {
      //   mapBloc.add(ProviderUpdateEvent());
    });
  }

  getProviders() async {
    _serviceLatlng = await _sharedReferences.getLatLng();
    _providersInfo = await _providerRepo.getProviders();

    print('this is providers info: $_providersInfo');
  }

  //* set custom pointer for service providerLocation
  Future<void> setCustomMapPin() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icon/google_map_icon.png', 100);
    final Uint8List markerIcon2 = await getBytesFromAsset(
      'assets/icon/icon.png',
      100,
    );
    pinProviderIcon = BitmapDescriptor.fromBytes(markerIcon);
    pinUserIcon = BitmapDescriptor.fromBytes(markerIcon2);
    return;
  }

  @override
  void dispose() {
    super.dispose();
    // mapBloc.close();
    Wakelock.disable();
    _stopwatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (mounted) {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      print("2Value  from notification ");
      if (value != null) {
        print("2Value  from notification $value");
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;

      FirebaseResponse firebaseResponse;
      try {
        firebaseResponse = FirebaseResponse.fromJson(message.data);
      } catch (e) {
        print(e);
        firebaseResponse = FirebaseResponse(message: "New Request");
      }

      print("$notification");
      // print("$android");
      print(firebaseResponse.message);

      // showSnack(context, "${firebaseResponse.message}");
      if (firebaseResponse.message == "Your trip was accepted by a partner") {
        showSnackSuccess(context, firebaseResponse.message);
        getTrips(context);

        // if(BlocProvider.of<HomePageContentBloc>(context).homePageContents.isAvailable)
        // BlocProvider.of<NewOrderBloc>(context).add(BLoadData());

      } else if (firebaseResponse.message ==
          'Provider arrived at the location') {
        showSnackSuccess(context, firebaseResponse.message);
        getTrips(context);
      } else if (firebaseResponse.message == 'Request Started') {
        showSnackSuccess(context, firebaseResponse.message);
        getTrips(context);
      } else if (firebaseResponse.message == ('Request completed')) {
        showSnackSuccess(context, firebaseResponse.message);
        getTrips(context);
      } else if (firebaseResponse.message.contains('Request completed')) {
        showSnackSuccess(context, firebaseResponse.message);
        getTrips(context);
      } else {
        getTrips(context);
      }
      // else {
      //   if (mounted) {
      //     showSnackError(context, firebaseResponse.message);

      //     Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => DashBoardPage('')),
      //         (route) => false);
      //   }
      // }
      // // AndroidNotification android = message.notification.android;
      print("FirebaseMessaging.onMessage.listen");

      print("FirebaseMessaging.onMessage.listen");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("irebaseMessaging.onMessageOpenedApp.listen");
      print('A new onMessageOpenedApp event was published! $message');
      print("irebaseMessaging.onMessageOpenedApp.listen");
    });
    // }

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _kGoogleComplex,
                    markers: markers,
                    polylines: Set<Polyline>.of(polylines.values),
                    onMapCreated: (GoogleMapController controller) {
                      googleMapController = controller;
                      _controller.complete(controller);
                      controller.setMapStyle(_mapStyle);
                      updateCameraPosition(controller);
                    },
                    onCameraIdle: () {
                      if (!isLoaded) {
                        if (_tripInfo.length == 0) {
                          _modalBottomSheetMenu(
                              context, serviceCategoryModelList);
                        } else {
                          if (_tripInfo['status'] == 'DROPPED') {
                            showPaymentInfo(context, _tripInfo);
                          } else if (_tripInfo['status'] == 'COMPLETED') {
                            showRatingModal(context, _tripInfo);
                          } else {
                            if (_tripInfo['status'] == 'STARTED' &&
                                !(addedMarker)) {
                              _addMarker(_tripInfo);
                            }
                            showAcceptedInfo(context, _tripInfo);
                          }
                        }

                        setState(() {
                          isLoaded = true;
                        });
                      }
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getTrips(BuildContext context) async {
    Navigator.pop(context);
    Map<String, dynamic> _info = await _orderRepo.getRequest();
    // Navigator.of(context, rootNavigator: true).pop('dialog');

    print(_info);
    if (_info.length > 0) {
      // print(_tripInfo);
      setState(() {
        _tripInfo = _info;
        if (_info['status'] == 'STARTED') {
          _addMarker(_info);
        } else if (_info['status'] == 'ARRIVED') {
          _updateMarker(_info);
        }

        // stopTimer();
        switch (_info['status']) {
          case 'PICKEDUP':
            _stopwatchTimer.onExecute.add(StopWatchExecute.start);
            // setState(() {
            // });
            break;
          case 'DROPPED':
            _stopwatchTimer.onExecute.add(StopWatchExecute.stop);

            break;
        }
      });

      if (_info['status'] == 'DROPPED') {
        Navigator.pop(context);
        showPaymentInfo(context, _info);
      } else if (_info['status'] == 'COMPLETED') {
        Navigator.pop(context);
        showRatingModal(context, _info);
      } else {
        Navigator.pop(context);
        showAcceptedInfo(context, _info);
      }

      setState(() {
        isLoaded = true;
      });
    }
  }

  void showRatingModal(BuildContext context, Map<String, dynamic> _info) async {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        enableDrag: false,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        // set this to true
        builder: (context) {
          return WillPopScope(
            onWillPop: () => _onWillPop(context),
            child: DraggableScrollableSheet(
              expand: false,
              maxChildSize: .3,
              minChildSize: .3,
              initialChildSize: .3,
              builder: (_, controller) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Please Rate the trip",
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 19,
                          color: const Color(0xff4a4b4d),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Center(
                                child: RatingBar.builder(
                                  initialRating: 0.0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rate) {
                                    setState(() {
                                      rating = rate;
                                    });
                                  },
                                ),
                              ),
                            ),
                            CustomTextField(
                                hint: "Comment",
                                textEditingController:
                                    _commentEditingController,
                                validator: (String text) {
                                  if (text.length == 0) {
                                    return 'Please enter the text';
                                  }
                                  return null;
                                }),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: _isRating
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: () =>
                                          _rateTrip(context, rating, _info),
                                      child: Text("Provide Review"),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }).then((value) {
      setState(() {
        isLoaded = false;
      });
    });
  }

  _rateTrip(
      BuildContext context, double rating, Map<String, dynamic> info) async {
    setState(() {
      _isRating = true;
    });
    final OrderRepo _order = new OrderRepo();
    if (_commentEditingController.text.isEmpty) {
      showSnackError(context, 'Please Provide valid comment');
      setState(() {
        _isRating = false;
      });

      return false;
    }
    Map<String, dynamic> _info = await _order.rateTrip(
        info['id'].toString(), rating.round(), _commentEditingController.text);

    setState(() {
      _isRating = false;
    });
    if (_info['error'] != null) {
      showSnackError(context, _info['error']);
    } else if (_info['errors'] != null) {
      showSnackError(context, _info['message']);
    } else {
      Navigator.pop(context);
      showSnackSuccess(context, _info['message']);
      Future.delayed(
          Duration(
            seconds: 3,
          ), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashBoardPage('')),
            (route) => false);
      });
    }
  }

  _updateMarker(Map<String, dynamic> _info) {
    final marker = markers.first;
    Marker _marker = Marker(
      markerId: marker.markerId,
      onTap: () {
        print("tapped");
      },
      position: LatLng(double.parse(_info['s_latitude']),
          double.parse(_info['s_longitude'])),
      icon: marker.icon,
      infoWindow: InfoWindow(title: 'Provider'),
    );

    setState(() {
      //the marker is identified by the markerId and not with the index of the list
      markers.add(_marker);
      polylines = {};
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(double.parse(_info['s_latitude']),
                double.parse(_info['s_longitude'])),
            zoom: 18,
          ),
        ),
      );
    });
  }

  updateCameraPosition(GoogleMapController _controller) async {
    LatLng target = await _sharedReferences.getLatLng();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: 18,
        ),
      ),
    );
  }

  void _addMarker(
    Map<String, dynamic> serviceProviderModel,
  ) async {
    print(serviceProviderModel);
    setState(() {
      isLoaded = true;
      addedMarker = true;
      // markers = {};
      // serviceProviderModel.forEach((element) {
      markers.add(Marker(
        markerId: MarkerId(
          'provider_id',
        ),
        position: LatLng(double.parse(serviceProviderModel['d_latitude']),
            double.parse(serviceProviderModel['d_longitude'])),
        icon: pinProviderIcon,
        draggable: false,
        onTap: () => null,
        infoWindow: new InfoWindow(title: "Provider"),
      ));

      markers.add(
        Marker(
            markerId: MarkerId(
              'service_id',
            ),
            position: LatLng(double.parse(serviceProviderModel['s_latitude']),
                double.parse(serviceProviderModel['s_longitude'])),
            icon: pinUserIcon,
            draggable: false,
            infoWindow: new InfoWindow(title: "Service"),
            onTap: () {}),
      );

      _getPolyline(serviceProviderModel);

      List<LatLng> latLngList = [];
      // serviceProviderModel.forEach((element) {
      latLngList.add(LatLng(double.parse(serviceProviderModel['d_latitude']),
          double.parse(serviceProviderModel['d_longitude'])));

      latLngList.add(LatLng(double.parse(serviceProviderModel['s_latitude']),
          double.parse(serviceProviderModel['s_longitude'])));
      // });

      googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(boundsFromLatLngList(latLngList), 52),
      );
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 10);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(Map<String, dynamic> _result) {
    List<PointLatLng> result =
        polylinePoints.decodePolyline(_result['route_key']);
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        print(point);
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  void _modalBottomSheetMenu(
    BuildContext context,
    serviceCategoryModel,
  ) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        enableDrag: false,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        // set this to true
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            maxChildSize: .4,
            minChildSize: .2,
            initialChildSize: .4,
            builder: (_, controller) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.grey.shade200,
                                                  child: CachedNetworkImage(
                                                    imageUrl: isHistory
                                                        ? serviceCategoryModel[
                                                            'service_type_image']
                                                        : serviceCategoryModel[
                                                            'image'],
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(
                                                      Icons.error,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    isHistory
                                                        ? serviceCategoryModel[
                                                            'service_type_name']
                                                        : serviceCategoryModel[
                                                            'name'],
                                                    style: TextStyle(
                                                      fontFamily: 'Metropolis',
                                                      fontSize: 16,
                                                      color: const Color(
                                                          0xff4a4b4d),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  _providersInfo.length > 0
                                                      ? RatingBar.builder(
                                                          itemSize: 10,
                                                          initialRating:
                                                              double.parse(
                                                                  _providersInfo[
                                                                          0][
                                                                      'rating']),
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemPadding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          onRatingUpdate:
                                                              (rating) {
                                                            print(rating);
                                                          },
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .blueGrey)),
                                                onPressed: _isPressed
                                                    ? null
                                                    : () {
                                                        goToCoupons(context);
                                                      },
                                                child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child:
                                                        Text('View Coupons')))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    CustomTextField(
                                      hint: "Comments (optional)",
                                      obscure: true,
                                      textEditingController:
                                          _oldPasswordController,
                                      validator: (String text) =>
                                          FormUtils.validatePassword(
                                              text, context),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.monetization_on,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Payment Mode",
                                              style: TextStyle(
                                                fontFamily: 'Metropolis',
                                                fontSize: 14,
                                                color: const Color(0xff4a4b4d),
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'CASH',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _providersInfo.length == 0
                                    ? showSnackError(
                                        context, 'No Providers Found')
                                    : enabled
                                        ? _navigateToSchedulePage(
                                            context,
                                            serviceId,
                                            _serviceLatlng,
                                            _providersInfo[0]['latitude'],
                                            _providersInfo[0]['longitude'],
                                            true)
                                        : null,
                                child: Text("Book Later"),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _providersInfo.length == 0
                                    ? showSnackError(
                                        context, 'No Providers Found')
                                    : enabled
                                        ? _navigateToSchedulePage(
                                            context,
                                            serviceId,
                                            _serviceLatlng,
                                            _providersInfo[0]['latitude'],
                                            _providersInfo[0]['longitude'],
                                            false)
                                        : null,
                                // _orderNow(context2, state.data),
                                child: enabled
                                    ? Text("Instant Booking")
                                    : Text("Searching"),
                              ),
                            ),
                          ],
                        )
                        // },
                        // bloc: mapBloc,
                        ),
                  ),
                ],
              );
            },
          );
        });
  }

  _navigateToSchedulePage(
      BuildContext context2,
      int id,
      LatLng serviceReceiverLocation,
      String lat,
      String long,
      bool isScheduled) async {
    LatLng serviceProviderLocation =
        LatLng(double.parse(lat), double.parse(long));

    if (isScheduled) {
      Navigator.push(
          context2,
          MaterialPageRoute(
              builder: (context) => BookLater(
                  serviceCategoryModelList,
                  id.toString(),
                  serviceProviderLocation,
                  serviceReceiverLocation)));
    } else {
      final OrderRepo _orderRepo = new OrderRepo();
      setState(() {
        enabled = false;
      });

      Map<String, dynamic> _result = await _orderRepo.requestOrder(
          serviceReceiverLocation.latitude.toString(),
          serviceReceiverLocation.longitude.toString(),
          lat,
          long,
          id.toString());

      if (_result['errors'] != null) {
        Navigator.pop(context2);
        showSnackError(context2, _result['message']);
        setState(() {
          enabled = true;
        });
      } else if (_result['error'] != null) {
        showSnackError(context2, _result['error']);
        if (_result['error'] == 'Login to Continue') {
          await _sharedReferences.removeAccessToken();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginRegisterPage()),
              (route) => false);
        }
        setState(() {
          enabled = true;
        });
      } else {
        showDialog(
            context: context2,
            barrierDismissible: false,
            builder: (BuildContext context2) {
              return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                      child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Searching',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ]))));
            });
      }
    }
  }

  void showAcceptedInfo(BuildContext context, Map<String, dynamic> tripInfo) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        enableDrag: false,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        // set this to true
        builder: (context) {
          return WillPopScope(
              onWillPop: () => _onWillPop(context),
              child: DraggableScrollableSheet(
                expand: false,
                maxChildSize: .4,
                minChildSize: .2,
                initialChildSize: .4,
                builder: (_, controller) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    child: Container(
                                                      width: 60,
                                                      height: 60,
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: CachedNetworkImage(
                                                        imageUrl: tripInfo[
                                                            'service_type_image'],
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        tripInfo[
                                                            'service_type_name'],
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Metropolis',
                                                          fontSize: 16,
                                                          color: const Color(
                                                              0xff4a4b4d),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      _providersInfo.length > 0
                                                          ? RatingBar.builder(
                                                              itemSize: 10,
                                                              initialRating:
                                                                  double.parse(
                                                                      _providersInfo[
                                                                              0]
                                                                          [
                                                                          'rating']),
                                                              minRating: 1,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemPadding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4.0),
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {
                                                                print(rating);
                                                              },
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blueGrey)),
                                                    onPressed: _isPressed
                                                        ? null
                                                        : () {
                                                            goToCoupons(
                                                                context);
                                                          },
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                            'View Coupons')))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.monetization_on,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Base Price",
                                                  style: TextStyle(
                                                    fontFamily: 'Metropolis',
                                                    fontSize: 14,
                                                    color:
                                                        const Color(0xff4a4b4d),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('Rs. ' +
                                                    tripInfo[
                                                            'service_type_price']
                                                        .toString())
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.monetization_on,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Fixed Price",
                                                  style: TextStyle(
                                                    fontFamily: 'Metropolis',
                                                    fontSize: 14,
                                                    color:
                                                        const Color(0xff4a4b4d),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('Rs. ' +
                                                    _tripInfo[
                                                            'service_type_fixed']
                                                        .toString())
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.monetization_on,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Payment Mode",
                                                  style: TextStyle(
                                                    fontFamily: 'Metropolis',
                                                    fontSize: 14,
                                                    color:
                                                        const Color(0xff4a4b4d),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'CASH',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: tripInfo['status'] == 'PICKEDUP'
                                ? Row(children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () => {},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.grey[400])),

                                          // _orderNow(context2, state.data),
                                          child: Text("Service Started")),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: StreamBuilder<int>(
                                          stream: _stopwatchTimer.rawTime,
                                          initialData:
                                              _stopwatchTimer.rawTime.value,
                                          builder: (context, snapshot) {
                                            final value = snapshot.data;
                                            final displayTime =
                                                StopWatchTimer.getDisplayTime(
                                                    value,
                                                    hours: _isHours);

                                            return Text(
                                              displayTime,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          }),
                                    ),
                                  ])
                                : Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => cancelRequest(
                                              context, tripInfo['id']),
                                          child: Text("Cancel"),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.grey[400])),
                                          onPressed: () => {},
                                          child: Text(tripInfo['status']),
                                        ),
                                      ),
                                    ],
                                  )
                            // },
                            // bloc: mapBloc,
                            ),
                      ),
                    ],
                  );
                },
              ));
        }).then((value) {
      setState(() {
        isLoaded = false;
      });
    });
  }

  void showPaymentInfo(
      BuildContext context, Map<String, dynamic> tripInfo) async {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        enableDrag: false,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        // set this to true
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            maxChildSize: .5,
            minChildSize: .2,
            initialChildSize: .5,
            builder: (_, controller) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      tripInfo['service_type_provider'],
                                      style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        fontSize: 18,
                                        color: const Color(0xff4a4b4d),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.directions_bike,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Distance",
                                            style: TextStyle(
                                              fontFamily: 'Metropolis',
                                              fontSize: 14,
                                              color: const Color(0xff4a4b4d),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      tripInfo['payment_distance'].toString() +
                                          " KM",
                                      style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        fontSize: 14,
                                        color: const Color(0xff4a4b4d),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.lock_clock,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Time",
                                          style: TextStyle(
                                            fontFamily: 'Metropolis',
                                            fontSize: 14,
                                            color: const Color(0xff4a4b4d),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    tripInfo['payment_hour'] + 'hrs' ??
                                        parseDisplayDate(DateTime.now()),
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 14,
                                      color: const Color(0xff4a4b4d),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.monetization_on,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Fixed Price",
                                            style: TextStyle(
                                              fontFamily: 'Metropolis',
                                              fontSize: 14,
                                              color: const Color(0xff4a4b4d),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Rs.' +
                                          tripInfo['payment_fixed'].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        fontSize: 14,
                                        color: const Color(0xff4a4b4d),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.monetization_on,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Tax Price",
                                          style: TextStyle(
                                            fontFamily: 'Metropolis',
                                            fontSize: 14,
                                            color: const Color(0xff4a4b4d),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Rs." + tripInfo['payment_tax'].toString(),
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 14,
                                      color: const Color(0xff4a4b4d),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.monetization_on,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Tips",
                                          style: TextStyle(
                                            fontFamily: 'Metropolis',
                                            fontSize: 14,
                                            color: const Color(0xff4a4b4d),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Rs." + tripInfo['payment_tips'].toString(),
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 14,
                                      color: const Color(0xff4a4b4d),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.monetization_on,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Total",
                                          style: TextStyle(
                                            fontFamily: 'Metropolis',
                                            fontSize: 14,
                                            color: const Color(0xff4a4b4d),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Rs." +
                                        tripInfo['payment_provider_pay']
                                            .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 18,
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => null,
                          // Navigator.pop(context);
                          // showRatingModal(context, tripInfo),
                          child: Text("Pay"),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }).then((value) {
      setState(() {
        isLoaded = false;
      });
    });
  }

  cancelRequest(BuildContext context, int tripInfo) async {
    final OrderRepo _orderRepo = new OrderRepo();
    Widget cancelButton = ElevatedButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("YES"),
      onPressed: () async {
        Map<String, dynamic> _cancel =
            await _orderRepo.cancelRequest(tripInfo.toString());
        showSnackError(context, "Canceling Order");

        if (_cancel['error'] == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashBoardPage('')),
              (route) => false);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Mario Service"),
      content: Text("Are you sure to cancel the trip?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onWillPop(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("YES"),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashBoardPage('')),
            (route) => false);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Mario Service"),
      content: Text("Are you sure to exit?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void goToCoupons(BuildContext context2) async {
    setState(() {
      _isPressed = true;
    });

    print('here');
    final PromoCodeRepo _promo = new PromoCodeRepo();

    List<Map<String, dynamic>> _promos = await _promo.getUserPromo();

    if (_promos.length > 0) {
      showPromoModal(context2, _promos);
    } else {
      showSnackError(context2, 'No coupons available');
    }

    setState(() {
      _isPressed = false;
    });
  }

  void showPromoModal(
      BuildContext context3, List<Map<String, dynamic>> promos) {
    showModalBottomSheet(
        isDismissible: false,
        context: context3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        enableDrag: false,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        // set this to true
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            minChildSize: .3,
            initialChildSize: .3,
            builder: (_, controller) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: StripContainer(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.card_giftcard,
                                size: 16,
                              ),
                              Text(
                                promos[index]['percentage'],
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 14,
                                  color: const Color(0xff4a4b4d),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Expanded(
                                  child: Text(
                                "% discount",
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 14,
                                  color: const Color(0xff4a4b4d),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              )),
                              InkWell(
                                onTap: () => copyToClipBoard(
                                    promos[index]['promo_code'], context),
                                child: Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () => copyToClipBoard(
                                    promos[index]['promo_code'], context),
                                child: Text(
                                  promos[index]['promo_code'],
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 24,
                                    color: const Color(0xff4a4b4d),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                "valid until: ",
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 12,
                                  color: const Color(0xff4a4b4d),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Expanded(
                                child: Text(
                                  parseDisplayDate(DateTime.parse(
                                      promos[index]['expiration'])),
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 12,
                                    color: const Color(0xff4a4b4d),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  );
                },
                itemCount: promos.length,
              );
            },
          );
        });
  }
}
