import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mario_service/repositories/order/order_repo.dart';
import 'package:mario_service/repositories/providers/provider_repo.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:mario_service/views/schedule_service/schedule_service.dart';

class BookLater extends StatefulWidget {
  final Map<String, dynamic> serviceCategoryModelList;
  final String serviceId;

  final LatLng serviceProviderLocation, serviceReceiverLocation;

  BookLater(this.serviceCategoryModelList, this.serviceId,
      this.serviceProviderLocation, this.serviceReceiverLocation);

  @override
  _BookLaterState createState() => _BookLaterState();
}

class _BookLaterState extends State<BookLater> {
  final SharedReferences _sharedReferences = new SharedReferences();
  final ProvidersRepo _providerRepo = new ProvidersRepo();
  Map<String, dynamic> serviceCategoryModelList;
  int providerNo;

  List<Map<String, dynamic>> _providersInfo = [];
  LatLng _serviceLatlng = LatLng(0.0, 0.0);

  @override
  void initState() {
    getProviders();
    if (widget.serviceCategoryModelList != null) {
      serviceCategoryModelList = widget.serviceCategoryModelList;
    }
    print('this is service category modal list: $serviceCategoryModelList');

    // mapBloc.listenToPushNotification();
  }

  getProviders() async {
    _serviceLatlng = await _sharedReferences.getLatLng();
    _providersInfo = await _providerRepo.getProviders();

    print('this is providers info: $_providersInfo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 2),
                  child: TextFormField(
                    decoration: new InputDecoration(
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: "Search Providers",
                    ),
                  ),
                ),
              )),
        ),
        backgroundColor: Colors.white,
        body: _providersInfo.length > 0
            ? ListView.builder(
                itemCount: _providersInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          providerNo = index;
                        });

                        _navigateToSchedulePage(
                            context,
                            index,
                            0,
                            _serviceLatlng,
                            _providersInfo[0]['latitude'],
                            _providersInfo[0]['longitude'],
                            true);
                      },
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.97,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.deepOrangeAccent, width: 1),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey.shade200,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              serviceCategoryModelList['image'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Name: ${_providersInfo[index]['first_name'] + ' ' + _providersInfo[index]['last_name']}",
                                        style: TextStyle(
                                            fontFamily: 'Metropolis',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "Email: ${_providersInfo[index]['email']}",
                                        style: TextStyle(
                                            fontFamily: 'Metropolis',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "Gender: ${_providersInfo[index]['gender']}",
                                        style: TextStyle(
                                            fontFamily: 'Metropolis',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(children: [
                                        Text(
                                          "Rating: ",
                                          style: TextStyle(
                                              fontFamily: 'Metropolis',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        _providersInfo.length > 0
                                            ? RatingBar.builder(
                                                itemSize: 10,
                                                initialRating: double.parse(
                                                    _providersInfo[0]
                                                        ['rating']),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              )
                                            : Container(),
                                      ]),
                                      Row(
                                        children: [
                                          Text(
                                            "Status: ",
                                            style: TextStyle(
                                                fontFamily: 'Metropolis',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.deepOrangeAccent),
                                            child: Text(
                                              _providersInfo[index]['status'],
                                              style: TextStyle(
                                                  fontFamily: 'Metropolis',
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  )
                                ],
                              ))));
                })
            : Center(
                child: Text(
                  "No providers found",
                  style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ));
  }

  _navigateToSchedulePage(
      BuildContext context2,
      int providerNo,
      int id,
      LatLng serviceReceiverLocation,
      String lat,
      String long,
      bool isScheduled) async {
    bool enabled = true;
    LatLng serviceProviderLocation =
        LatLng(double.parse(lat), double.parse(long));

    if (isScheduled) {
      Navigator.push(
          context2,
          MaterialPageRoute(
              builder: (context) => ScheduleServicePage(
                  providerNo,
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
}
