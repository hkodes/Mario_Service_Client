import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mario_service/external_svg_resources/svg_resources.dart';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/common/base.dart';
import 'package:share/share.dart';

class GetDiscount extends StatefulWidget {
  final String discountCode;

  const GetDiscount({Key key, this.discountCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GetDiscountState();
  }
}

class GetDiscountState extends State<GetDiscount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Share"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: StripContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.string(
                            share_svg,
                            height: MediaQuery.of(context).size.width * .7,
                            width: MediaQuery.of(context).size.width * .7,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            "Invite a friend and get a discount on your next order",
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 15,
                              color: const Color(0xff4a4b4d),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            "Use the code",
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 12,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    widget.discountCode,
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      fontSize: 12,
                                      color: const Color(0xff4a4b4d),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => copyToClipBoard(
                                    widget.discountCode, context),
                                child: Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BottomButton(
              onTap: () => Share.share(
                'Use the code ${widget.discountCode} to use my referral code, while downing the app from ${AppConstants.APP_STORE_LINK}',
              ),
              title: "Share",
              enabled: true,
              isPositive: true,
            )
          ],
        ));
  }
}
