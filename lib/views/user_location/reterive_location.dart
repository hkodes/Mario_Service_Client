import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/dashboard/dashboard.dart';
import 'package:mario_service/views/user_location/address_search.dart';
import 'package:mario_service/views/user_location/open_map.dart';
import 'package:mario_service/views/user_location/places_search.dart';
import 'package:uuid/uuid.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';

class UserLocationUpdatePage extends StatefulWidget {
  final Map<String, dynamic> userSavedLocation;

  final String addressName;
  // final Function(UserAddressEntity userAddressEntity) param2;
  UserLocationUpdatePage(this.userSavedLocation, this.addressName);
  @override
  State<StatefulWidget> createState() {
    return UserLocationUpdatePageState();
  }
}

class UserLocationUpdatePageState extends State<UserLocationUpdatePage> {
  // UserLocationBloc userLocationBloc = UserLocationBloc(
  //   updateUserAddressUseCase: di(),
  // );
  // UserSavedLocation userSavedLocation;
  Map<String, dynamic> userSavedLocation = {};
  final _controller = TextEditingController();
  // String _addressStringEntity = '';
  // //saved result;
  // AddressStringEntity _addressStringEntity;

  @override
  void initState() {
    userSavedLocation = widget.userSavedLocation;
    super.initState();
  }

  @override
  void dispose() {
    // userLocationBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set your Address"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            StripContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      readOnly: true,
                      onTap: () async {
                        // generate a new token here
                        final sessionToken = Uuid().v4();
                        final Suggestion result = await showSearch(
                            context: context,
                            delegate: AddressSearch(sessionToken));
                        // This will change the text displayed in the TextField
                        if (result != null) {
                          final placeDetails =
                              await PlaceApiProvider(sessionToken)
                                  .getPlaceDetailFromId(result.placeId);
                          // setState(() {
                          //   _controller.text = result.description;

                          //   print(placeDetails.streetNumber);
                          //   print(placeDetails.street);
                          //   print(placeDetails.city);
                          //   print(placeDetails.zipCode);
                          // });
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            _popWithValue(
                                context,
                                result.description,
                                placeDetails.estimatedLatLng.latitude,
                                placeDetails.estimatedLatLng.longitude);
                            // }
                            // _popWithValue(
                            //     context,
                            //     UserAddressEntity(
                            //         addressName: result.description,
                            //         latLng: placeDetails.estimatedLatLng));
                          });
                        }
                      },
                      decoration: InputDecoration(
                        // icon: Container(
                        //   width: 10,
                        //   height: 10,
                        //   child: Icon(
                        //     Icons.home,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        hintText: "Enter your shipping address",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                      ),
                    ),
                    // CustomSingleSearchField(
                    //   textEditingController: _controller,
                    //   hint: "Search...",
                    //   iconData: Icons.search,
                    //   function: (String text) => _search(text, context),
                    // ),
                  ],
                ),
              ),
            ),
            AddressItem(
              iconData: Icons.pin_drop,
              title: 'Set On Map',
              onTap: () => _setOnMapClick(context, widget.addressName),
            ),
            if (widget.addressName == null)
              Container()
            else
              SizedBox(
                height: 68,
                child: Row(
                  children: [
                    Expanded(
                      child: AddressItem(
                        iconData: Icons.save_outlined,
                        title: widget.addressName,
                        onTap: () => {},
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        return _popWithValue(
                            context, widget.addressName, null, null);
                      },
                      // _popWithValue(
                      //     context,
                      //     UserAddressEntity(
                      //         addressName: _addressStringEntity.addressName,
                      //         latLng: _addressStringEntity.latLng)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.done),
                      ),
                    )
                  ],
                ),
              ),
            SizedBox(
              height: 8,
            ),
            StripContainer(
              child: Column(
                children: [
                  SelectionCard(
                    title: userSavedLocation['home'].length == 0
                        ? "Set Home address"
                        : 'Home address',
                    // svgIcon: payment,
                    iconData: Icons.home_outlined,
                    onTap: () =>
                        _addLocation(context, widget.addressName, 'home'),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return AddressItem(
                        iconData: Icons.location_searching,
                        title: userSavedLocation['home'][index]['address'],
                        onTap: () {
                          return _popWithValue(
                              context,
                              userSavedLocation['home'][index]['address'],
                              double.parse(
                                  userSavedLocation['home'][index]['latitude']),
                              double.parse(userSavedLocation['home'][index]
                                  ['longitude']));
                        },
                        // {
                        //   return _popWithValue(
                        //       context,
                        //       UserAddressEntity(
                        //           latLng: LatLng(
                        //             double.parse(
                        //                 userSavedLocation.home[index].latitude),
                        //             double.parse(
                        //               userSavedLocation.home[index].longitude,
                        //             ),
                        //           ),
                        //           addressName:
                        //               userSavedLocation.home[index].address));
                        // },
                      );
                    },
                    itemCount: userSavedLocation['home'].length,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            StripContainer(
              child: Column(
                children: [
                  SelectionCard(
                    title: userSavedLocation['work'].length == 0
                        ? "Set Work address"
                        : 'Work address',
                    // svgIcon: payment,
                    iconData: Icons.work_outline,
                    onTap: () =>
                        _addLocation(context, widget.addressName, 'work'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AddressItem(
                        iconData: Icons.location_searching,
                        title: userSavedLocation['work'][index]['address'],
                        onTap: () {
                          return _popWithValue(
                              context,
                              userSavedLocation['work'][index]['address'],
                              double.parse(
                                  userSavedLocation['work'][index]['latitude']),
                              double.parse(userSavedLocation['work'][index]
                                  ['longitude']));
                        },
                      );
                    },
                    itemCount: userSavedLocation['work'].length,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            StripContainer(
              child: Column(
                children: [
                  SelectionCard(
                    title: userSavedLocation['work'].length == 0
                        ? "Set Other address"
                        : 'Other address',
                    // svgIcon: payment,
                    iconData: Icons.add,
                    onTap: () =>
                        _addLocation(context, widget.addressName, 'others'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AddressItem(
                        iconData: Icons.location_searching,
                        title: userSavedLocation['others'][index]['address'],
                        onTap: () {
                          return _popWithValue(
                              context,
                              userSavedLocation['others'][index]['address'],
                              double.parse(userSavedLocation['others'][index]
                                  ['latitude']),
                              double.parse(userSavedLocation['others'][index]
                                  ['longitude']));
                        },
                      );
                    },
                    itemCount: userSavedLocation['others'].length,
                  )
                ],
              ),
            ),
            StripContainer(
              child: Column(
                children: [
                  SelectionCard(
                    title: 'Recent',
                    // svgIcon: payment,
                    iconData: CupertinoIcons.location_fill,
                    onTap: () {},
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AddressItem(
                        iconData: Icons.location_searching,
                        title: userSavedLocation['others'][index]['address'],
                        onTap: () => null,
                      );
                    },
                    itemCount: userSavedLocation['others'].length,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_search(String text, BuildContext context) {
  print(text);
}

_setOnMapClick(BuildContext context, String addressName) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => OpenMapPage(addressName, '')));
}

_popWithValue(
    BuildContext context, String address, double lat, double long) async {
  if (lat != null || long != null) {
    final SharedReferences _sharedReferences = new SharedReferences();
    await _sharedReferences.setLatLng(lat, long);
  }

  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashBoardPage(address)),
      (route) => false);
}

_addLocation(BuildContext context, String addressName, String addressType) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OpenMapPage(addressName, addressType)));
}

class AddressItemTitle extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Map Function() onTap;

  const AddressItemTitle(
      {Key key,
      @required this.iconData,
      @required this.title,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StripContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          iconData,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
