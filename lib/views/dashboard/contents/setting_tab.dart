import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/change_password/change_password.dart';
import 'package:mario_service/views/get_discounts/get_discounts.dart';
import 'package:mario_service/views/login_register/login_register.dart';
import 'package:mario_service/views/notifications/notifications.dart';
import 'package:mario_service/views/policies/policies.dart';
import 'package:mario_service/views/profile/profile.dart';
import 'package:mario_service/views/promo_code/promo_code.dart';
import 'package:mario_service/views/wallet/wallet.dart';

class SettingTab extends StatelessWidget {
  final Map<String, dynamic> userModel;
  SettingTab(this.userModel);
  @override
  Widget build(BuildContext context) {
    return ProfilePage(this.userModel);
  }
}

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userModel;
  ProfilePage(this.userModel);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StripContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(150.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: this.userModel['picture'] ?? "",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 75,
                          ),
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getFullName(this.userModel['first_name'],
                            this.userModel['last_name']),
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 16,
                          color: const Color(0xff2a2a2b),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        this.userModel['email'],
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 11,
                          color: const Color(0xff7c7d7e),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        this.userModel['mobile'],
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 11,
                          color: const Color(0xff7c7d7e),
                          fontWeight: FontWeight.w500,
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
            height: 6,
          ),
          SettingOptions(
            title: "ACCOUNT",
            listOfTiles: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                    title: 'Profile',
                    // svgIcon: payment,
                    iconData: Icons.person,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(this.userModel)))),
              ),
              // context.router.push(Profile())),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                    title: 'Report Issue',
                    // svgIcon: notification,
                    iconData: Icons.report_problem,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()))),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                    title: 'Notifications',
                    // svgIcon: notification,
                    iconData: Icons.notifications,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()))),
              ),
              // context.router.push(NotificationRoute()),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                  title: 'Wallet',
                  // svgIcon: notification,
                  iconData: Icons.account_balance_wallet,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WalletPage())),
                  //  context.router.push(WalletRoute()),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                    title: 'Password',
                    // svgIcon: notification,
                    iconData: Icons.lock_clock,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()))
                    // context.router.push(ChangePasswordRoute()),
                    ),
              ),
            ],
          ),
          SettingOptions(
            title: "OFFERS",
            listOfTiles: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                  title: 'Promo',
                  // svgIcon: payment,
                  iconData: Icons.local_offer,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PromoCodePage())),
                  // context.router.push(PromoCodeRoute()),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                  title: 'Get Discount',
                  // svgIcon: payment,
                  iconData: Icons.credit_card,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GetDiscount(
                              discountCode: this.userModel['referral_text']))),
                  // context.router.push(
                  //   GetDiscount(discountCode: userDetailModel.referralText),
                  // ),
                ),
              ),
            ],
          ),
          SettingOptions(
            title: "HELP & LEGAL",
            listOfTiles: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                  title: 'Help',
                  // svgIcon: payment,
                  iconData: Icons.call,
                  onTap: () => null,
                  // context.router.push(HelpRoute()),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                  title: 'Policies',
                  // svgIcon: notification,
                  iconData: Icons.policy_rounded,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Policies())),
                  // context.router.push(Policies()),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepOrangeAccent,
                ),
                child: SelectionCard(
                  title: 'Logout',
                  // svgIcon: payment,
                  iconData: Icons.logout,
                  onTap: () => logout(context),
                  // BlocProvider.of<AuthenticationBloc>(context)
                  //     .add(LogOutUser()),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  logout(BuildContext context) async {
    final SharedReferences _references = new SharedReferences();
    await _references.removeAccessToken();
    await _references.removeUserId();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginRegisterPage()),
        (route) => false);
  }
}

class SettingOptions extends StatelessWidget {
  final String title;
  final List<Widget> listOfTiles;

  const SettingOptions({Key key, this.title, this.listOfTiles})
      : assert(listOfTiles != null && listOfTiles.length != 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: StripContainer(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title == null
                  ? Container()
                  : Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 11,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
              title == null ? Container() : SizedBox(height: 8),
              Column(
                  children: listOfTiles.map((v) {
                return Column(
                  children: [
                    v,
                    SizedBox(
                      height: 6,
                    )
                  ],
                );
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
