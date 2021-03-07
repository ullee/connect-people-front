import 'package:flutter/material.dart';

import 'components/body.dart';

class _HomeSearchState extends State<HomeSearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('검색')
      ),
      body: Body(),
    );
  }
}

class HomeSearchScreen extends StatefulWidget {
  static String routeName = "/home_search";

  @override
  _HomeSearchState createState() => _HomeSearchState();
}
