import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mario_service/external_svg_resources/svg_resources.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/repositories/wallet/wallet_repo.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/login_register/login_register.dart';

class WalletPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletPageState();
  }
}

class WalletPageState extends State<WalletPage> {
  SharedReferences references = new SharedReferences();
  final WalletRepo _walletRepo = new WalletRepo();
  Map<String, dynamic> _wallet = {};
  bool isLoading = true;

  // WalletBloc walletBloc = WalletBloc(loadWalletUseCase: di());

  @override
  void initState() {
    // walletBloc.add(BLoadData());
    getWallet();
    super.initState();
  }

  getWallet() async {
    _wallet = await _walletRepo.getWalletInfo();

    if (_wallet['error'] == 'Login to Continue.') {
      await references.removeAccessToken();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
      return false;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : WalletInfo(this._wallet),
    );
  }
}

class WalletInfo extends StatelessWidget {
  final Map<String, dynamic> _wallet;

  WalletInfo(this._wallet);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: StripContainer(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // 'RS. 100',
                          'Rs. ${this._wallet['wallet_balance']} ',
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 45,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total balance',
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 11,
                            color: const Color(0xff000000),
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          this._wallet['wallet_transation'].length == 0
              ? ShowEmptyWallet()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return WalletItem(this._wallet['wallet_transation'][index]);
                  },
                  itemCount: this._wallet['wallet_transation'].length,
                )
        ],
      ),
    );
  }
}
// }

class WalletItem extends StatelessWidget {
  final Map<String, dynamic> walletTransation;

  WalletItem(this.walletTransation);

  @override
  Widget build(BuildContext context) {
    bool isPositive = false;
    if (double.parse(walletTransation['open_balance']) <
        double.parse(walletTransation['close_balance'])) {
      isPositive = false;
    } else
      isPositive = true;
    DateTime dateTime = walletTransation['created_at'];
    if (walletTransation['created_at'] == null) {
      dateTime = DateTime.now();
    } else {
      dateTime = walletTransation['created_at'];
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: StripContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isPositive ? "Received @" : "Used @",
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 18,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          walletTransation['transaction_alias'],
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 18,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(parseDisplayDate(dateTime)),
                  ],
                ),
              ),
              Text(
                isPositive ? "+" : "-" + walletTransation['amount'],
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 18,
                  color: isPositive
                      ? const Color(0xFF4FC166)
                      : const Color(0xfFFF8000),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowEmptyWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StripContainer(
      child: Column(
        children: [
          SvgPicture.string(
            empty_wallet,
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 2,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Look like there\'re no credits in your account, kindly purchase more to continue.',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 16,
              color: const Color(0xff9f9f9f),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Your wallet is empty!',
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 18,
              color: const Color(0xff000000),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
