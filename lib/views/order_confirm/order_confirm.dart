import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mario_service/repositories/order/order_repo.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/main.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:mario_service/views/order_completed/order_complete.dart';

class OrderConfirmPage extends StatefulWidget {
  final String serviceId;
  final LatLng serviceProviderLocation, serviceReceiverLocation;
  final DateTime orderDate, orderTime;
  final Map<String, dynamic> _fares;

  const OrderConfirmPage(
      this.serviceId,
      this.serviceProviderLocation,
      this.serviceReceiverLocation,
      this.orderDate,
      this.orderTime,
      this._fares);

  @override
  State<StatefulWidget> createState() {
    return OrderConfirmPageState();
  }
}

class OrderConfirmPageState extends State<OrderConfirmPage> {
  bool isScheduled;
  Map<String, dynamic> _fares = {};
  String address = '';
  DateTime orderDate, orderTime;

  @override
  void initState() {
    _fares = widget._fares;
    if (widget.orderDate == null && widget.orderTime == null) {
      isScheduled = false;
      orderDate = DateTime.now();
      orderTime = DateTime.now();
    } else {
      isScheduled = true;
      orderDate = widget.orderDate;
      orderTime = widget.orderTime;
    }
    if (_fares['error'] != null) {
      showSnackError(context, _fares['error']);
      Future.delayed(
          Duration(
            seconds: 2,
          ), () {
        if (_fares['error'] == 'Login to Continue.') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginRegisterPage()));
        } else {
          Navigator.pop(context);
        }
      });
    }
    _getLocation();

    super.initState();
  }

  void _getLocation() async {
    final coordinates = new Coordinates(widget.serviceReceiverLocation.latitude,
        widget.serviceReceiverLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      address = first.addressLine;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: StripContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      isScheduled ? "Scheduled" : "Order Now",
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
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(isScheduled
                                        ? "Schedule Date"
                                        : "Order Date"),
                                    Text(isScheduled
                                        ? "Schedule Time"
                                        : "Order Time")
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderDate.day.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        fontSize: 20,
                                        color: const Color(0xff4a4b4d),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      parseHoursAMPM(orderTime),
                                      style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        fontSize: 20,
                                        color: const Color(0xff4a4b4d),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(parseDisplayDateYear(orderDate)),
                                    Text(parseDisplayDateYear(orderDate))
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: StripContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.delivery_dining,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Location",
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
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(address),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: StripContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_offer,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Promo",
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
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            CustomTextField(
                              hint: "PromoCode",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: StripContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Additional Info",
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
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            CustomTextField(
                              hint: "Written here...",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: StripContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 14,
                              color: const Color(0xff4a4b4d),
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Rs." + _fares['estimated_fare'].toString(),
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 14,
                              color: const Color(0xfffc6011),
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: PositiveButton(
                        onTap: () =>
                            _pay(context, _fares, orderDate, orderTime),
                        text: "Place order",
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget edit(void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            Icons.edit,
            color: MyApp.primary_color,
            size: 16,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            "Edit",
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 13,
              color: const Color(0xfffc6011),
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  _pay(BuildContext context, Map<String, dynamic> orderConfirmEntity,
      DateTime orderDate, DateTime orderTime) async {
    showSnackError(context, 'Only Code for now');
    _modalBottomSheetMenu(context, orderConfirmEntity);
  }

  void _modalBottomSheetMenu(
    BuildContext context2,
    Map<String, dynamic> orderConfirmEntity,
  ) {
    showModalBottomSheet(
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
          print(parseDate(orderDate));
          print(parseTime2(orderTime));
          // OrderRequestEntity orderRequestEntity = OrderRequestEntity(
          //   sLatitude:
          //       orderConfirmEntity.coordinatesProvider.latitude.toString(),
          //   sLongitude:
          //       orderConfirmEntity.coordinatesProvider.longitude.toString(),
          //   dLatitude: orderConfirmEntity.coordinatesMine.latitude.toString(),
          //   dLongitude: orderConfirmEntity.coordinatesMine.longitude.toString(),
          //   serviceType:
          //       orderConfirmEntity.fareResponseModel.serviceType.toString(),
          //   useWallet: null,
          //   paymentMode: "CASH",
          //   scheduleDate: parseDate(orderDate),
          //   scheduleTime: parseTime2(orderTime),
          // );
          int total = orderConfirmEntity['estimated_fare'] +
              orderConfirmEntity['base_price'] +
              orderConfirmEntity['tax_price'];
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
                            child: StripContainer(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      orderConfirmEntity['service']['name'],
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
                            child: StripContainer(
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
                                      orderConfirmEntity['distance']
                                              .toString() +
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
                          StripContainer(
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
                                    "${orderConfirmEntity['time'] ?? parseDisplayDate(DateTime.now())}",
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
                            child: StripContainer(
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
                                            "Base Price",
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
                                          orderConfirmEntity['base_price']
                                              .toString(),
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
                          StripContainer(
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
                                    "Rs." +
                                        orderConfirmEntity['tax_price']
                                            .toString(),
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
                          StripContainer(
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
                                          "Estimated Fare",
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
                                        orderConfirmEntity['estimated_fare']
                                            .toString(),
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
                          StripContainer(
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
                                    "Rs." + total.toString(),
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
                    child: StripContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _confirmSubmit(context2,
                              parseDate(orderDate), parseTime2(orderTime)),
                          child: Text("Confirm"),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  _confirmSubmit(BuildContext context2, String date, String time) async {
    final OrderRepo _orderRepo = new OrderRepo();
    Map<String, dynamic> _orders = await _orderRepo.scheduleOrder(
        widget.serviceReceiverLocation.latitude.toString(),
        widget.serviceReceiverLocation.longitude.toString(),
        widget.serviceProviderLocation.latitude.toString(),
        widget.serviceProviderLocation.longitude.toString(),
        widget.serviceId,
        date,
        time);

    if (_orders['error'] == 'Login to Continue.') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
      return;
    }
    if (_orders['errors'] != null) {
      showSnackError(context2, _orders['message']);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderCompleted(_orders['request_id'])));
    }
  }
}

class CustomTextField extends StatelessWidget {
  final textEditingController;
  final String hint;
  final bool obscure;
  final FormFieldValidator<String> validator;
  final int minLine;

  const CustomTextField({
    Key key,
    this.textEditingController,
    this.hint,
    this.validator,
    this.obscure = false,
    this.minLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      obscureText: obscure,
      validator: validator,
      minLines: minLine,
      keyboardType: TextInputType.multiline,
      controller: textEditingController,
      style: TextStyle(
        fontFamily: 'Metropolis',
        fontSize: 14,
        color: const Color(0xff636565),
      ),
      decoration: new InputDecoration(
        focusColor: Colors.green,
        enabledBorder: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        focusedBorder: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        errorBorder: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        border: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        filled: true,
        hintStyle: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 14,
          color: const Color(0xffb6b7b7),
        ),
        hintText: hint,
        fillColor: const Color(0xfff2f2f2),
      ),
    );
  }
}
