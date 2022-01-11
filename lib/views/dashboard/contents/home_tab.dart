import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mario_service/external_svg_resources/svg_resources.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/views/category_listing/category_listing.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:mario_service/views/map_order/map_order.dart';
import 'package:mario_service/views/user_location/reterive_location.dart';

class HomePage extends StatefulWidget {
  final String location;
  final Map<String, dynamic> locations;
  final List<Map<String, dynamic>> _banners;
  final List<Map<String, dynamic>> _services;

  HomePage(this.location, this.locations, this._banners, this._services);
  @override
  State<StatefulWidget> createState() {
    return HomePageContentViewState();
  }
}

class HomePageContentViewState extends State<HomePage> {
  String currentLocation = '';
  final SharedReferences references = new SharedReferences();
  Map<String, dynamic> location = {};
  List<Map<String, dynamic>> _banners = [];
  List<Map<String, dynamic>> _services = [];
  @override
  void initState() {
    currentLocation = widget.location;
    location = widget.locations;
    checkLogin();
    _banners = widget._banners;
    _services = widget._services;

    super.initState();
  }

  checkLogin() async {
    if (location['error'] == 'Login to Continue.') {
      await references.removeAccessToken();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int pageIndex = 0;
    bool isLocationHome = false;
    bool isLocationOffice = false;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.077,
            width: MediaQuery.of(context).size.width * 0.97,
            padding: EdgeInsets.only(left: 5, top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.deepOrangeAccent,
            ),
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserLocationUpdatePage(location, currentLocation))),
              // _navigateToLocation(
              //     homePageContents.userSavedLocation,
              //     context,
              //     (UserAddressEntity userAddressEntity) =>
              //         _setAddress(userAddressEntity)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Current Delivery Location',
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      currentLocation,
                      // location.addressName,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 11,
                        color: Colors.white,
                        height: 1.8,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
          StripContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                location['home'].length == 0
                    ? Container()
                    : InkWell(
                        onTap: () => {},
                        child: LocationSelection(
                          isLocationHome,
                          location['home'][0]['address'],
                          Icons.home,
                          "Home",
                        ),
                      ),
                location['work'].length == 0
                    ? Container()
                    : LocationSelection(
                        isLocationOffice,
                        location['work'][0]['address'],
                        Icons.local_convenience_store,
                        "Office",
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.97,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.deepOrangeAccent, width: 1),
              color: Colors.white,
            ),
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      onPageChanged: (index, ex) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      enlargeCenterPage: true,
                      height: 200.0,
                      autoPlay: true,
                      reverse: false,
                      viewportFraction: 1.0),
                  items: _banners.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return BannerItem(
                          imageUrl: i['url'],
                          onTap: () {},
                        );
                      },
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _banners.map((url) {
                    int index = _banners.indexOf(url);
                    return Container(
                      width: 5.0,
                      height: 5.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pageIndex == index
                            ? Colors.deepOrangeAccent
                            : Colors.deepOrange,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: TitleCard(
              onTap: () => {},
              title: "Popular Service Provider",
            ),
          ),
          SizedBox(
            height: 7,
          ),
          StripContainer(
            child: SizedBox(
              height: 150,
              child: _services.length == 0
                  ? Container(
                      child: Center(child: Text('No Services Found')),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        return CategoryIcon(
                          imageUrl: _services[index]['image'],
                          text: _services[index]['name'],
                          price: _services[index]['price'],
                          onTap: () => {
                            if (_services[index]['children'].length == 0)
                              {_navigateToLocation(context, _services[index])}
                            else
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryListingPage(
                                          _services[index]['name'],
                                          _services[index]['children'])))
                          },
                        );
                      },
                    ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          StripContainer(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                //    ListView.builder(
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //    itemCount: homePageContents.serviceProviderModel.length < 3
                //         ? homePageContents.serviceProviderModel.length
                //       : 3,
                //      itemBuilder: (context, index) {
                //        return PopularItem(
                //          imageUrl:
                //              homePageContents.serviceProviderModel[index].avatar,
                //      serviceName: homePageContents
                //              .serviceProviderModel[index].firstName +
                //        " " +
                //      homePageContents
                //        .serviceProviderModel[index].firstName,
                //  rating:
                //   homePageContents.serviceProviderModel[index].rating,
                // location:
                //     homePageContents.serviceProviderModel[index].address,
                //       ratingCount:
                //           homePageContents.serviceProviderModel[index].rating +
                //               "k",
                //     );
                //   },
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 18,
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  _navigateToLocation(BuildContext context, Map<String, dynamic> services) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MapOrder(services, false, {})));
  }
}

class LocationSelection extends StatelessWidget {
  final bool isActive;
  final String address;
  final IconData iconData;
  final String type;

  LocationSelection(this.isActive, this.address, this.iconData, this.type);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            type,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 14,
              color: const Color(0xff4a4b4d),
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        isActive ? Colors.primaries[0] : Colors.grey.shade300,
                    width: 1,
                  ),
                  right: BorderSide(
                    color:
                        isActive ? Colors.primaries[0] : Colors.grey.shade300,
                    width: 1,
                  ),
                  left: BorderSide(
                    color:
                        isActive ? Colors.primaries[0] : Colors.grey.shade300,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color:
                        isActive ? Colors.primaries[0] : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99.0),
                      child: Container(
                        width: 35,
                        height: 35,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Icon(
                            iconData,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      address,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 12,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w100,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BannerItem extends StatelessWidget {
  final Function() onTap;
  final String imageUrl;

  const BannerItem({Key key, this.onTap, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: MediaQuery.of(context).size.width - 16,
      height: MediaQuery.of(context).size.width * .3,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

class RecentItem extends StatelessWidget {
  final String imageUrl;
  final String serviceName;
  final String rating;
  final String location;
  final String ratingCount;
  final String serviceType;

  const RecentItem(
      {Key key,
      this.imageUrl,
      this.serviceName,
      this.serviceType,
      this.rating,
      this.location,
      this.ratingCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: MediaQuery.of(context).size.width * .4,
            height: MediaQuery.of(context).size.width * .3,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(
            width: 6,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceName,
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 18,
                  color: const Color(0xff4a4b4d),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Text(
                    '$serviceType',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 12,
                      color: const Color(0xffb6b7b7),
                      height: 1.6666666666666667,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.circle,
                    size: 6,
                    color: const Color(0xfffc6011),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '$location',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 12,
                      color: const Color(0xffb6b7b7),
                      height: 1.6,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
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
                    rating,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 11,
                      color: const Color(0xfffc6011),
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '($ratingCount ratings)',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 12,
                      color: const Color(0xffb6b7b7),
                      height: 1.6666666666666667,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MostPopularItem extends StatelessWidget {
  final String imageUrl;
  final String serviceName;
  final String rating;
  final String location;
  final String ratingCount;
  final String serviceType;

  const MostPopularItem(
      {Key key,
      this.imageUrl,
      this.serviceName,
      this.serviceType,
      this.rating,
      this.location,
      this.ratingCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width * .4,
          //   height: MediaQuery.of(context).size.width * .3,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10.0),
          //     image: DecorationImage(
          //       image: NetworkImage(imageUrl),
          //       fit: BoxFit.fitWidth,
          //     ),
          //   ),
          // ),
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: MediaQuery.of(context).size.width * .4,
            height: MediaQuery.of(context).size.width * .3,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            serviceName,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 18,
              color: const Color(0xff4a4b4d),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Text(
                '$serviceType',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 12,
                  color: const Color(0xffb6b7b7),
                  height: 1.6,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 4,
              ),
              Icon(
                Icons.circle,
                size: 6,
                color: const Color(0xfffc6011),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                '$location',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 12,
                  color: const Color(0xffb6b7b7),
                  height: 1.6,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PopularItem extends StatelessWidget {
  final String imageUrl;
  final String serviceName;
  final String rating;
  final String location;
  final String ratingCount;

  const PopularItem(
      {Key key,
      this.imageUrl,
      this.serviceName,
      this.rating,
      this.location,
      this.ratingCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl ?? "",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * .6,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            serviceName,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 16,
              color: const Color(0xff4a4b4d),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                    rating,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 11,
                      color: const Color(0xfffc6011),
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '($ratingCount ratings)',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 12,
                      color: const Color(0xffb6b7b7),
                      height: 1.6,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 11,
                    color: const Color(0xfffc6011),
                  ),
                  Text(
                    location,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 12,
                      color: const Color(0xffb6b7b7),
                      height: 1.6,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class TitleCard extends StatelessWidget {
  final String title;
  final Function() onTap;

  const TitleCard({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 20,
              color: const Color(0xff4a4b4d),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
          // InkWell(
          //   onTap: onTap,
          //   child: Text(
          //     "View all",
          //     style: TextStyle(
          //       fontFamily: 'Metropolis',
          //       fontSize: 13,
          //       color: const Color(0xfffc6011),
          //       fontWeight: FontWeight.w500,
          //     ),
          //     textAlign: TextAlign.right,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String imageUrl;
  final String price;
  final String text;
  final Function() onTap;

  const CategoryIcon({
    Key key,
    this.imageUrl,
    this.text,
    this.onTap,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.077,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.deepOrangeAccent, width: 1.5),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.deepOrangeAccent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.4285714285714286,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 6,
                // ),
                // Text(
                //   'Rs. $price',
                //   style: TextStyle(
                //     fontFamily: 'Metropolis',
                //     fontSize: 10,
                //     color: const Color(0xffb6b7b7),
                //     height: 1.7,
                //   ),
                //   textHeightBehavior:
                //       TextHeightBehavior(applyHeightToFirstAscent: false),
                //   textAlign: TextAlign.left,
                // ),
              ],
            ),
          ),
        ));
  }
}
