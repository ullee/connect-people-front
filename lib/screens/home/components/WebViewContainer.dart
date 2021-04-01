import 'package:connect_people/screens/home/home_screen.dart';
import 'package:connect_people/size_config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home_banner.dart';
import 'home_header.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // 강제로 홈화면 이동시키기
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
                child: Column(
              children: [
                HomeHeader(),
              ],
            )),
            SizedBox(height: getProportionateScreenHeight(20)),
            Container(
                child: Column(
              children: [
                HomeBanner(),
              ],
            )),
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ));
  }
}
