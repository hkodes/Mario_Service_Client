import 'package:flutter/material.dart';
import 'package:mario_service/repositories/promo_code/promo_code_repo.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/login_register/login_register.dart';

class PromoCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PromoCodePgeState();
  }
}

class PromoCodePgeState extends State<PromoCodePage> {
  SharedReferences references = new SharedReferences();
  final PromoCodeRepo _promoCodeRepo = new PromoCodeRepo();
  List<Map<String, dynamic>> _allPromo = [];
  bool isLoading = true;
  @override
  void initState() {
    getAllPromo();
    super.initState();
  }

  getAllPromo() async {
    _allPromo = await _promoCodeRepo.getUserPromo();
    if (_allPromo[0]['error'] == 'Login to Continue.') {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Promo Code"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : PromoCodeListing(this._allPromo));
  }
}

class PromoCodeListing extends StatelessWidget {
  final List<Map<String, dynamic>> _allPromo;

  PromoCodeListing(this._allPromo);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StripContainer(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 16,
                    ),
                    Text(
                      this._allPromo[index]['percentage'],
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 14,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                        child: Text(
                      "% discount",
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 14,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    )),
                    InkWell(
                      onTap: () => copyToClipBoard(
                          this._allPromo[index]['promo_code'], context),
                      child: Icon(
                        Icons.copy,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      this._allPromo[index]['promo_code'],
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 24,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      "valid until: ",
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 12,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        parseDisplayDate(DateTime.parse(
                            this._allPromo[index]['expiration'])),
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 12,
                          color: const Color(0xff4a4b4d),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        );
      },
      itemCount: this._allPromo.length,
    );
  }
}
