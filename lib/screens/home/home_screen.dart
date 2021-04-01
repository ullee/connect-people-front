// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:connect_people/screens/category/category_screen.dart';
import 'package:connect_people/screens/category_main/category_main_screen.dart';
import 'package:connect_people/screens/profile/profile_screen.dart';
import 'package:connect_people/screens/category_search/category_search_screen.dart';
import 'package:connect_people/size_config.dart';

import 'components/body.dart';
import 'components/WebViewContainer.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _selectIndex = 0;
  final List<Widget> _pages = [
    // Body(),
    WebViewContainer(
        "http://ec2-3-35-207-154.ap-northeast-2.compute.amazonaws.com:8080/main/list"),
    CategoryScreen(),
    CategorySearchScreen(),
    CategoryMainScreen(),
    ProfileScreen(),
  ];

  /*
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      "To test: long press link and then copy and click from a non-browser "
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      "is properly setup. Look at firebase_dynamic_links/README.md for more "
      "details.";
  */

  @override
  void initState() {
    super.initState();
    // this.initDynamicLinks();
  }

  /*
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      print(deepLink);

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    print(deepLink);

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://cplab.page.link',
      link: Uri.parse('https://cplab.page.link/login_success'),
      androidParameters: AndroidParameters(
        packageName: 'com.ullee.connect_people',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: _pages[_selectIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        onTap: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("홈", style: TextStyle(fontSize: 12))),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration),
              title: Text("글쓰기", style: TextStyle(fontSize: 12))),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("검색", style: TextStyle(fontSize: 12))),
          BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              title: Text("카테고리", style: TextStyle(fontSize: 12))),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text("내정보", style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
