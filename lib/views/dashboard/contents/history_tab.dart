import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mario_service/external_svg_resources/svg_resources.dart';
import 'package:mario_service/repositories/order/order_repo.dart';
import 'package:mario_service/utils/common_fun.dart';
// import 'package:service_mario/data/model/trips/up_coming_trips.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/common/empty_widget.dart';
import 'package:mario_service/views/trip_detail/trip_detail.dart';

// import 'package:service_mario/presentation/features/trip_history/trip_history_bloc.dart';
// import 'package:service_mario/presentation/features/upcoming_trips/upcoming_trips_bloc.dart';

class HistoryTab extends StatelessWidget {
  final List<Map<String, dynamic>> _ongoingTrip;
  final List<Map<String, dynamic>> _pastTrip;

  HistoryTab(this._ongoingTrip, this._pastTrip);
  @override
  Widget build(BuildContext context) {
    return StackOver(this._ongoingTrip, this._pastTrip);
  }
}

class StackOver extends StatefulWidget {
  final List<Map<String, dynamic>> _ongoingTrip;
  final List<Map<String, dynamic>> _pastTrip;

  StackOver(this._ongoingTrip, this._pastTrip);
  @override
  _StackOverState createState() => _StackOverState();
}

class _StackOverState extends State<StackOver>
    with SingleTickerProviderStateMixin {
  final OrderRepo _orderRepo = new OrderRepo();

  List<Map<String, dynamic>> _ongoingTrip = [];
  List<Map<String, dynamic>> _pastTrip = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _isLoading = false;
  TabController _tabController;

  @override
  void initState() {
    _ongoingTrip = widget._ongoingTrip;
    _pastTrip = widget._pastTrip;

    print(_ongoingTrip);
    print(_pastTrip);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  getTripDetails() async {
    _ongoingTrip = await _orderRepo.getUpcomingTrips();
    _pastTrip = await _orderRepo.getTrips();

    if (_pastTrip.length > 0 && _ongoingTrip.length > 0) {
      if (_pastTrip[0]['error'] == 'Login to Continue.' ||
          _ongoingTrip[0]['error'] == 'Login to Continue.') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginRegisterPage()),
            (route) => false);
        return;
      }
    }
    // print(_ongoingTrip);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    getTripDetails();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

    // BlocProvider.of<TripHistoryBloc>(context).add(RefreshDataEvent());
    // BlocProvider.of<UpcomingTripsBloc>(context).add(RefreshEvent());
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // give the tab bar a height [can change er
                  //
                  // hheight to preferred height]
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        color: Colors.deepOrangeAccent,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          text: 'On Going',
                        ),

                        // second tab [you can add an icon using the icon property]
                        Tab(
                          text: 'Past',
                        ),
                      ],
                    ),
                  ),
                  // tab bar view here
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // first tab bar view widget
                        UpComingTripView(_ongoingTrip),

                        // second tab bar view widget
                        CompletedTripView(_pastTrip),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class CompletedTripView extends StatelessWidget {
  final List<Map<String, dynamic>> _past;

  CompletedTripView(this._past);
  @override
  Widget build(BuildContext context) {
    return UpComingTripContent(
      isOngoing: false,
      upcomingTripModel: this._past,
    );
  }
}

class UpComingTripView extends StatelessWidget {
  final List<Map<String, dynamic>> _upcoming;

  UpComingTripView(this._upcoming);

  @override
  Widget build(BuildContext context) {
    return UpComingTripContent(
      isOngoing: true,
      upcomingTripModel: this._upcoming,
    );
  }
}

class UpComingTripContent extends StatefulWidget {
  final List<Map<String, dynamic>> upcomingTripModel;
  final bool isOngoing;

  UpComingTripContent(
      {@required this.upcomingTripModel, @required this.isOngoing})
      : assert(upcomingTripModel != null);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpComingTripContentState();
  }
}

class UpComingTripContentState extends State<UpComingTripContent> {
  // final OrderRepo _orderRepo = new OrderRepo();
  List<Map<String, dynamic>> tripModel = [];
  bool isOngoing;

  @override
  void initState() {
    tripModel = widget.upcomingTripModel;
    isOngoing = widget.isOngoing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Expanded(
          child: tripModel.length == 0
              ? EmptyOrder()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  // itemCount: upcomingTripModel.length,
                  itemCount: tripModel.length,
                  itemBuilder: (context, index) {
                    return UpComingTripItem(tripModel[index], widget.isOngoing);
                  },
                ),
        ),
      ],
    );
  }
}

class UpComingTripItem extends StatelessWidget {
  final Map<String, dynamic> upComingTripModel;
  final bool isOngoing;

  UpComingTripItem(this.upComingTripModel, this.isOngoing);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () => _gotoDetail(context, upComingTripModel, isOngoing),
        child: StripContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(upComingTripModel['service_type_name']),
                    ),
                    Text(
                      upComingTripModel['created_at'] == null
                          ? ""
                          : parseDisplayDate(
                              DateTime.parse(upComingTripModel['created_at'])),
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 11,
                        color: const Color(0xffb6b7b7),
                        height: 1,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                upComingTripModel['service_type_description'] == null
                    ? Container()
                    : Text(upComingTripModel['service_type_description'] ?? ""),
                Divider(),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(42.0),
                      child: CachedNetworkImage(
                        imageUrl: upComingTripModel['service_type_image'],
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  upComingTripModel['service_type_provider'],
                                ),
                                _getStatusView(upComingTripModel['status']),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SvgPicture.string(
                                  start_orange,
                                  width: 11,
                                  height: 11,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  upComingTripModel['user_rated'],
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 11,
                                    color: const Color(0xfffc6011),
                                  ),
                                  textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    isOngoing
                                        ? 'Rs.' +
                                            ((double.parse(upComingTripModel[
                                                            'service_type_price']))
                                                        .round() +
                                                    int.parse(upComingTripModel[
                                                        'service_type_fixed']))
                                                .toString()
                                        : 'Rs.' +
                                            upComingTripModel[
                                                'payment_provider_pay'],
                                    // ',
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 12,
                                      color: const Color(0xffb6b7b7),
                                      height: 1.6,
                                    ),
                                    textHeightBehavior: TextHeightBehavior(
                                        applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getStatusColor(String status) {
    if (status == "SCHEDULED") {
      return Colors.green.shade400;
    } else
      return Colors.red;
  }

  Widget _getStatusView(String status) {
    return Container(
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          status,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 11,
            color: const Color(0xffffffff),
          ),
          textHeightBehavior:
              TextHeightBehavior(applyHeightToFirstAscent: false),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _gotoDetail(BuildContext context, Map<String, dynamic> upComingTripModel,
      bool isOngOing) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TripDetail(
                upComingTripModel: upComingTripModel, isOngoing: isOngOing)));
  }
}
