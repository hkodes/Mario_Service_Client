import 'package:flutter/material.dart';
import 'package:mario_service/repositories/order/order_repo.dart';
import 'package:mario_service/utils/snack_util.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/dashboard/dashboard.dart';
import 'package:mario_service/views/login_register/login_register.dart';

class OrderCompleted extends StatefulWidget {
  final requestId;
  // final OrderRequestEntity orderRequestEntity;

  OrderCompleted(this.requestId);
  // const OrderCompleted({Key key, @required this.orderRequestEntity})
  //     : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderCompletedState();
  }
}

class OrderCompletedState extends State<OrderCompleted> {
  // OrderConfirmBloc orderConfirmBloc = OrderConfirmBloc(
  //   orderConfirmUseCase: di(),
  //   orderServiceUseCase: di(),
  // );

  @override
  void initState() {
    // orderConfirmBloc.add(
    //   OrderEvent(
    //     orderRequestEntity: widget.orderRequestEntity,
    //   ),
    // );
    super.initState();
  }

  _onWillPop(BuildContext context) async {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xfffc6011),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.done,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Congratulations",
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 20,
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "We're finding you a service person. We'll\nnotify you when your schedule is\n confirmed.",
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 16,
                    color: const Color(0xff222223),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          BottomButton(
            title: "Cancel Booking",
            isCancel: true,
            enabled: true,
            isPositive: false,
            onTap: () => _cancelOrderNavigateToHomePage(context),
          ),
          SizedBox(
            height: 8,
          ),
          BottomButton(
            isCancel: false,
            title: "Back to home",
            enabled: true,
            isPositive: true,
            onTap: () => _navigateToHomePage(context),
          ),
        ],
      )),
    );
  }

  _navigateToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoardPage('')),
        (route) => false);
  }

  _cancelOrderNavigateToHomePage(BuildContext context) async {
    final OrderRepo _orderRepo = new OrderRepo();

    Map<String, dynamic> _cancel =
        await _orderRepo.cancelRequest(widget.requestId.toString());

    if (_cancel['error'] == 'Login to Continue.') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
      return;
    }
    showSnackError(context, "Canceling Order");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoardPage('')),
        (route) => false);
  }
}
