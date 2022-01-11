import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mario_service/external_svg_resources/svg_resources.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/login_register/login_register.dart';

class Carousel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CarouselState();
  }
}

class CarouselState extends State<Carousel> {
  SharedReferences shared = new SharedReferences();
  final CarouselControllerImpl carouselControllerImpl =
      CarouselControllerImpl();
  int currentIndex = 0;
  List<CarouselObject> listOfImage = [
    CarouselObject(
        imageString: carousle_item_11,
        titleString: "Find Service",
        subTitleString:
            'Discover the best service from over 1,000\n restaurants and fast delivery to your doorstep'),
    CarouselObject(
        imageString: carousle_item_12,
        titleString: "Fast Delivery",
        subTitleString:
            'Fast service delivery to your home,\n office wherever you are'),
    CarouselObject(
        imageString: carousle_item_13,
        titleString: "Live Tracking",
        subTitleString:
            'Real time tracking of your food on the app \nonce you placed the order'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                enlargeCenterPage: true,
                reverse: false,
                enableInfiniteScroll: false,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  currentIndex = index;
                  setState(() {});
                  return;
                },
              ),
              carouselController: carouselControllerImpl,
              items: listOfImage.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return StripContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.string(i.imageString),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentIndex == 0 ? _showDot(true) : _showDot(false),
              currentIndex == 1 ? _showDot(true) : _showDot(false),
              currentIndex == 2 ? _showDot(true) : _showDot(false),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            listOfImage[currentIndex].titleString,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 28,
              color: const Color(0xff4a4b4d),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            listOfImage[currentIndex].subTitleString,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 13,
              color: const Color(0xff7c7d7e),
              fontWeight: FontWeight.w500,
              height: 1.4615384615384615,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 25,
          ),
          PositiveButton(
            text: currentIndex == 2 ? "Done" : "Next",
            onTap: () {
              setState(() {
                if (currentIndex == 2) {
                  // context.router.popUntil((route) => route.isFirst);
                  // context.router.replace(LoginRoute());
                  goToLogin(context);
                } else
                  carouselControllerImpl.nextPage();
              });
              return;
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  goToLogin(BuildContext context) {
    shared.setPrefernce();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginRegisterPage()));
  }

  _showDot(bool bool) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 5,
        height: 5,
        color: bool ? Colors.orange : Colors.grey,
      ),
    );
  }
}

class CarouselObject {
  final String imageString;
  final String titleString;
  final String subTitleString;

  CarouselObject({
    @required this.imageString,
    @required this.titleString,
    @required this.subTitleString,
  })  : assert(imageString != null),
        assert(titleString != null),
        assert(subTitleString != null);
}
