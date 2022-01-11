import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/repositories/order/order_repo.dart';
import 'package:mario_service/views/dashboard/dashboard.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:mario_service/views/map_order/map_order.dart';

class TripDetail extends StatefulWidget {
  final Map<String, dynamic> upComingTripModel;
  final bool isOngoing;

  const TripDetail({Key key, @required this.upComingTripModel, this.isOngoing})
      : assert(upComingTripModel != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TripDetailState();
  }
}

class TripDetailState extends State<TripDetail> {
  Map<String, dynamic> upComingTripDetailModel = {};
  bool _isLoading = true;
  String serviceAddress = '';
  String deliveryAddress = '';
  @override
  void initState() {
    upComingTripDetailModel = widget.upComingTripModel;
    serviceAddress = widget.upComingTripModel['s_address'];
    deliveryAddress = widget.upComingTripModel['d_address'];

    if (serviceAddress == '' || deliveryAddress == '') {
      _loadLocation();
    } else {
      _isLoading = false;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadLocation() async {
    final coordinates1 = new Coordinates(
        double.parse(widget.upComingTripModel['s_latitude']),
        double.parse(widget.upComingTripModel['s_longitude']));
    var addresses1 =
        await Geocoder.local.findAddressesFromCoordinates(coordinates1);

    final coordinates2 = new Coordinates(
        double.parse(widget.upComingTripModel['d_latitude']),
        double.parse(widget.upComingTripModel['d_longitude']));
    var addresses2 =
        await Geocoder.local.findAddressesFromCoordinates(coordinates2);
    var first = addresses1.first;
    var second = addresses2.first;

    setState(() {
      serviceAddress = first.addressLine;
      deliveryAddress = second.addressLine;
      _isLoading = false;
    });
  }

  // mapBloc.add(RetrieveAddressEvent(latLng: cameraPosition.target));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Trip Detail"),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : TripDetailContent(
                upComingTripDetailModel: upComingTripDetailModel,
                isOngoing: widget.isOngoing,
                serviceAddress: serviceAddress,
                deliveryAddress: deliveryAddress,
              ));
  }
}

class TripDetailContent extends StatelessWidget {
  final Map<String, dynamic> upComingTripDetailModel;
  final String serviceAddress;
  final String deliveryAddress;
  final bool isOngoing;

  const TripDetailContent(
      {Key key,
      this.upComingTripDetailModel,
      this.isOngoing,
      this.serviceAddress,
      this.deliveryAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                StripContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Trip ID",
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 11,
                                color: const Color(0xff4a4b4d),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              upComingTripDetailModel['booking_id'].toString(),
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 14,
                                color: const Color(0xff4a4b4d),
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () => copyToClipBoard(
                              upComingTripDetailModel['booking_id'].toString(),
                              context),
                          child: Icon(
                            Icons.copy,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                StripContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Trip Detail",
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 14,
                                color: const Color(0xff4a4b4d),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text("From"),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          serviceAddress,
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 12,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Icon(Icons.trending_down_rounded),
                        SizedBox(
                          height: 8,
                        ),
                        Text("To"),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          deliveryAddress,
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 12,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                StripContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Trip Cost",
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 14,
                                color: const Color(0xff4a4b4d),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Payment Mode"),
                            Text(
                              upComingTripDetailModel['payment_mode'],
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 12,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cost"),
                            Text(
                              isOngoing
                                  ? 'Rs.' +
                                      ((double.parse(upComingTripDetailModel[
                                                      'service_type_price']))
                                                  .round() +
                                              int.parse(upComingTripDetailModel[
                                                  'service_type_fixed']))
                                          .toString()
                                  : 'Rs.' +
                                      upComingTripDetailModel[
                                          'payment_provider_pay'],
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 12,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                StripContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service Provider",
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 14,
                                color: const Color(0xff4a4b4d),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(150.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: upComingTripDetailModel[
                                            'service_type_image'] ??
                                        "",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      size: 50,
                                    ),
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                upComingTripDetailModel['service_type_name'],
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 14,
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  upComingTripDetailModel['status'],
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 11,
                                    color: const Color(0xff000000),
                                  ),
                                  textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 8,
                ),
                isOngoing && upComingTripDetailModel['is_scheduled'] == 'NO'
                    ? StripContainer(
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                size: 24,
                                color: Colors.blue,
                              ),
                              Text(
                                "VIEW IN MAP",
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          onPressed: () => goToMap(context),
                          // _navigateToDispute(
                          //     context,
                          //     upComingTripDetailModel.providerId,
                          //     upComingTripDetailModel.user.id.toString(),
                          //     upComingTripDetailModel.bookingId),
                        ),
                      )
                    : Container(),
                isOngoing
                    ? StripContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectionCard(
                            title: 'Cancel Order',
                            // svgIcon: payment,
                            iconData: Icons.cancel_outlined,
                            onTap: () => cancelRequest(
                                context, upComingTripDetailModel['id']),
                          ),
                        ),
                      )
                    : Container(),
                // StripContainer(
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: SelectionCard(
                //           title: 'Request Again',
                //           // svgIcon: payment,
                //           iconData: Icons.favorite_border,
                //           onTap: () {
                //             showSnackLoading(context, "Todo....");
                //           }),
                //     ),
                //   ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        StripContainer(
          child: TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dangerous,
                  size: 24,
                  color: Colors.red,
                ),
                Text(
                  "Create Dispute",
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onPressed: () => null,
            // _navigateToDispute(
            //     context,
            //     upComingTripDetailModel.providerId,
            //     upComingTripDetailModel.user.id.toString(),
            //     upComingTripDetailModel.bookingId),
          ),
        )
      ],
    );
  }

  cancelRequest(BuildContext context, int requestId) async {
    bool cancelling = false;

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
        Map<String, dynamic> _success =
            await _orderRepo.cancelRequest(requestId.toString());
        if (_success['message'] != null) {
          if (_success['error'] == null) {
            showSnackError(context, _success['message']);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => DashBoardPage('')),
                (route) => false);
          } else {
            showSnackError(context, 'Cannot cancel request');
          }
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

  goToMap(BuildContext context) async {
    showSnackLoading(context, 'Initalizing map');
    print(upComingTripDetailModel);

    final OrderRepo _orderRepo = new OrderRepo();
    Map<String, dynamic> _trips = await _orderRepo.getRequest();

    if (_trips['error'] == 'Token has expired') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
      return false;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MapOrder(upComingTripDetailModel, true, _trips)));

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             MapOrder()));
  }

  // _navigateToDispute(BuildContext context, String providerId, String userId,
  //     String bookingId) {
  //   context.router.push(ReportIssueRoute(
  //       providerId: providerId, requestId: bookingId, userId: userId));
  // }
}
