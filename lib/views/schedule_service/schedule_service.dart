import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mario_service/repositories/estimated_fare/estimated_fare_repo.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/imported/date_picker/lib/date_picker_timeline.dart';
import 'package:mario_service/imported/date_picker/lib/extra/style.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:mario_service/views/order_confirm/order_confirm.dart';

class ScheduleServicePage extends StatefulWidget {
  final int providerNo;
  final String serviceId;
  final LatLng serviceProviderLocation, serviceReceiverLocation;

  ScheduleServicePage(this.providerNo, this.serviceId,
      this.serviceProviderLocation, this.serviceReceiverLocation);

  @override
  State<StatefulWidget> createState() {
    return ScheduleServicePageState();
  }
}

class ScheduleServicePageState extends State<ScheduleServicePage> {
  final FaresRepo _faresRepo = new FaresRepo();
  Map<String, dynamic> _fares = {};
  int providerNo;
  String serviceId;
  DateTime selectedDate = DateTime.now();
  bool _isLoading = true;

  DateTime selectedTime = DateTime.now();
  List<DateTime> listOfDate;

  DateTime defaultTime;

  @override
  void initState() {
    getFares();
    providerNo = widget.providerNo;
    listOfDate = [
      selectedTime,
      selectedTime.add(Duration(minutes: 5)),
      selectedTime.add(Duration(minutes: 10)),
      selectedTime.add(Duration(minutes: 15)),
      selectedTime.add(Duration(minutes: 20)),
      selectedTime.add(Duration(minutes: 25)),
      selectedTime.add(Duration(minutes: 30)),
      selectedTime.add(Duration(minutes: 35)),
      selectedTime.add(Duration(minutes: 40)),
      selectedTime.add(Duration(minutes: 45)),
      selectedTime.add(Duration(minutes: 50)),
      selectedTime.add(Duration(minutes: 55)),
      selectedTime.add(Duration(minutes: 60)),
      selectedTime.add(Duration(minutes: 65)),
      selectedTime.add(Duration(minutes: 70)),
      selectedTime.add(Duration(minutes: 75)),
      selectedTime.add(Duration(minutes: 80)),
      selectedTime.add(Duration(minutes: 85)),
      selectedTime.add(Duration(minutes: 90)),
      selectedTime.add(Duration(minutes: 95)),
      selectedTime.add(Duration(minutes: 100)),
      selectedTime.add(Duration(minutes: 105)),
      selectedTime.add(Duration(minutes: 110)),
      selectedTime.add(Duration(minutes: 115)),
    ];
    serviceId = widget.serviceId;
    defaultTime = DateTime.now();
    super.initState();
  }

  getFares() async {
    _fares = await _faresRepo.getFare(
        widget.serviceReceiverLocation,
        widget.serviceProviderLocation.latitude.toString(),
        widget.serviceProviderLocation.longitude.toString(),
        widget.serviceId);

    if (_fares['error'] == 'Login to Continue.') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
      return false;
    }

    setState(() {
      _isLoading = false;
    });
    print(_fares);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Service"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StripContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "When would you like your server?",
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 14,
                                    color: const Color(0xff4a4b4d),
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                  textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                DatePicker(
                                  DateTime.now(),
                                  initialSelectedDate: DateTime.now(),
                                  selectionColor: const Color(0xfff5c0a5),
                                  selectedTextColor:
                                      Theme.of(context).primaryColor,
                                  deactivatedColor: Colors.grey,
                                  width: 45.0,
                                  onDateChange: (date) {
                                    // New date selected
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                )
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
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "When would you like your server?",
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 14,
                                    color: const Color(0xff4a4b4d),
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                  textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                GridView.count(
                                  childAspectRatio: 4.0,
                                  crossAxisCount: 2,

                                  padding: EdgeInsets.all(5.0),
                                  children: <Widget>[
                                    timeClock(
                                      selectedTime == listOfDate[0],
                                      listOfDate[0],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[1],
                                      listOfDate[1],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[2],
                                      listOfDate[2],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[3],
                                      listOfDate[3],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[4],
                                      listOfDate[4],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[5],
                                      listOfDate[5],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[6],
                                      listOfDate[6],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[7],
                                      listOfDate[7],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[8],
                                      listOfDate[8],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[9],
                                      listOfDate[9],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[10],
                                      listOfDate[10],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[11],
                                      listOfDate[11],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[12],
                                      listOfDate[12],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[13],
                                      listOfDate[13],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[14],
                                      listOfDate[14],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[15],
                                      listOfDate[15],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[16],
                                      listOfDate[16],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[17],
                                      listOfDate[17],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[18],
                                      listOfDate[18],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[19],
                                      listOfDate[19],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[20],
                                      listOfDate[20],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[21],
                                      listOfDate[21],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[22],
                                      listOfDate[22],
                                    ),
                                    timeClock(
                                      selectedTime == listOfDate[23],
                                      listOfDate[23],
                                    ),
                                  ],
                                  shrinkWrap: true,
                                  // todo comment this out and check the result
                                  physics: ClampingScrollPhysics(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BottomButton(
                  title: "Continue",
                  enabled: (selectedTime != null && selectedDate != null)
                      ? true
                      : false,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderConfirmPage(
                              widget.serviceId,
                              widget.serviceProviderLocation,
                              widget.serviceReceiverLocation,
                              selectedDate,
                              selectedTime,
                              _fares))),
                  // context.router.push(
                  //   OrderConfirmRoute(
                  //     serviceId: widget.serviceId,
                  //     serviceReceiverLocation: widget.serviceReceiverLocation,
                  //     serviceProviderLocation: widget.serviceProviderLocation,
                  //     orderDate: selectedDate,
                  //     orderTime: selectedTime,
                  //   ),
                  // ),
                  isPositive: true,
                ),
              ],
            ),
    );
  }

  timeClock(bool bool, DateTime dateTime) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTime = dateTime;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: bool ? const Color(0xfff5c0a5) : const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1c4cbcfc),
                offset: Offset(0, 3),
                blurRadius: 11,
              ),
            ],
          ),
          child: Center(
            child: Text(
              parseHoursAMPM(
                dateTime,
              ),
              style: bool
                  ? defaultDayTextStyle.copyWith(
                      color: Theme.of(context).primaryColor)
                  : defaultDayTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
