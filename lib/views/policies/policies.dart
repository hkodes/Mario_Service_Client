import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mario_service/resources/app_constants.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/in_app_browser/in_app_browser.dart';

class Policies extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PoliciesState();
  }
}

class PoliciesState extends State<Policies> {
  final MyInAppBrowser browser = new MyInAppBrowser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Policies"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () => _loadInApp(AppConstants.URL_TERMS_AND_CONDITION),
            child: StripContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Terms and Conditions",
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 14,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () => _loadInApp(AppConstants.URL_POLICY),
            child: StripContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Policies",
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 14,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadInApp(String url) async {
    await browser.openUrlRequest(
      urlRequest: URLRequest(
        url: Uri.parse(url ?? "https://google.com"),
      ),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              useOnLoadResource: false,
              javaScriptEnabled: true,
              disableContextMenu: true),
        ),
      ),
    );
  }
}
