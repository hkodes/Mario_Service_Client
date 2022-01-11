import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mario_service/repositories/banners/banners.dart';
import 'package:mario_service/repositories/location/user_location.dart';
import 'package:mario_service/repositories/order/order_repo.dart';
import 'package:mario_service/repositories/services/services_repo.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/imported/package/navigation_bar/curved_navigation_bar.dart';
import 'package:mario_service/views/dashboard/contents/history_tab.dart';
import 'package:mario_service/views/dashboard/contents/home_tab.dart';
import 'package:mario_service/views/dashboard/contents/setting_tab.dart';
import 'package:mario_service/repositories/users/user_repo.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class DashBoardPage extends StatefulWidget {
  final address;
  DashBoardPage(this.address);
  @override
  State<StatefulWidget> createState() {
    return DashBoardPageState();
  }
}

class DashBoardPageState extends State<DashBoardPage> {
  int _page = 0;
  String currentLocation = '';
  GlobalKey _bottomNavigationKey = GlobalKey();
  final UserLocationRepo _userLocationRepo = new UserLocationRepo();
  final BannersRepo _bannersRepo = new BannersRepo();
  final ServicesRepo _servicesRepo = new ServicesRepo();
  final UserRepo userRepo = new UserRepo();
  final SharedReferences references = new SharedReferences();
  final OrderRepo _orderRepo = new OrderRepo();

  List<Map<String, dynamic>> _ongoingTrip = [];
  List<Map<String, dynamic>> _pastTrip = [];

  Map<String, dynamic> _userDetails = {};
  Map<String, dynamic> location = {};
  List<Map<String, dynamic>> _banners = [];
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;

  // UserDetailBloc userDetailBloc = UserDetailBloc(
  //   editUserDetailUseCase: di(),
  //   getUserDetailUseCase: di(),
  // );

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    _userDetails = await userRepo.getUserDetail();
    if (_userDetails['sucess'] == null) {
      await references.setUserId((_userDetails['id']));
    }

    if (_userDetails['error'] == 'Login to Continue.') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
      return;
    }

    location = await _userLocationRepo.getUsersLocation();
    _banners = await _bannersRepo.getBanners();
    _services = await _servicesRepo.getServices();

    _ongoingTrip = await _orderRepo.getUpcomingTrips();
    _pastTrip = await _orderRepo.getTrips();

    String address = widget.address;

    String loc = '';
    if (address != '') {
      loc = address;
    } else {
      Map<String, dynamic> _locationData = await references.getLocation();
      // print(await _sharedReferences.getLatLng());
      if (_locationData.length == 0) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        // debugPrint('location: ${position.latitude}');
        final coordinates =
            new Coordinates(position.latitude, position.longitude);
        await references.setLatLng(position.latitude, position.longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;

        loc = first.addressLine;
      } else {
        LatLng position = await references.getLatLng();
        final coordinates =
            new Coordinates(position.latitude, position.longitude);
        await references.setLatLng(position.latitude, position.longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;

        loc = first.addressLine;
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      currentLocation = loc;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          getTitle(_page),
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 20,
            color: const Color(0xff4a4b4d),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.deepOrangeAccent,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.reorder),
            title: Text("Order History"),
            selectedColor: Colors.deepOrangeAccent,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
            selectedColor: Colors.deepOrangeAccent,
          ),

          /// Profile
        ],
      ),

      body: SafeArea(
        child: _getTab(_page),
      ),
    );
  }

  _getTab(int page) {
    if (page == 1) {
      return _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : HistoryTab(_ongoingTrip, _pastTrip);
    } else if (page == 2) {
      return _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SettingTab(_userDetails);
    } else if (page == 0) {
      return _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : HomePage(currentLocation, location, _banners, _services);
    }
  }

  String getTitle(int page) {
    if (page == 1) {
      return 'Order History';
    } else if (page == 2) {
      return 'Settings';
    } else if (page == 0) {
      return "Good ${greeting()}!";
    }
    return "Hello";
  }
}
