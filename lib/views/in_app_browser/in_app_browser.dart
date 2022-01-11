import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppBrowserExampleScreen extends StatefulWidget {
  final MyInAppBrowser browser = new MyInAppBrowser();
  final String url;

  InAppBrowserExampleScreen({Key key, @required this.url})
      : assert(url != null),
        super(key: key);

  @override
  _InAppBrowserExampleScreenState createState() =>
      new _InAppBrowserExampleScreenState();
}

class _InAppBrowserExampleScreenState extends State<InAppBrowserExampleScreen> {
  PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          widget.browser.webViewController.reload();
        } else if (Platform.isIOS) {
          widget.browser.webViewController.loadUrl(
              urlRequest: URLRequest(
                  url: await widget.browser.webViewController.getUrl()));
        }
      },
    );
    widget.browser.pullToRefreshController = pullToRefreshController;
    _loadInApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "InAppBrowser",
      )),
      body: Container(),
      // body: Center(
      //   child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         ElevatedButton(
      //             onPressed: () async {
      //               await widget.browser.openUrlRequest(
      //                   urlRequest: URLRequest(
      //                       url: Uri.parse(widget.url ?? "https://google.com")),
      //                   options: InAppBrowserClassOptions(
      //                       inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      //                           crossPlatform: InAppWebViewOptions(
      //                     useShouldOverrideUrlLoading: true,
      //                     useOnLoadResource: true,
      //                   ))));
      //             },
      //             child: Text("Open In-App Browser")),
      //         Container(height: 40),
      //         ElevatedButton(
      //             onPressed: () async {
      //               await InAppBrowser.openWithSystemBrowser(
      //                   url: Uri.parse(widget.url ?? "https://google.com"));
      //             },
      //             child: Text("Open System Browser")),
      //       ]),
      // ),
    );
  }

  Future<void> _loadInApp() async {
    await widget.browser.openUrlRequest(
      urlRequest: URLRequest(
        url: Uri.parse(widget.url ?? "https://google.com"),
      ),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: false,
            javaScriptEnabled: true,
          ),
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser(
      {int windowId, UnmodifiableListView<UserScript> initialUserScripts})
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  @override
  Future onBrowserCreated() async {}

  @override
  Future onLoadStart(url) async {}

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {}

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(response) {}

  @override
  void onConsoleMessage(consoleMessage) {}
}
