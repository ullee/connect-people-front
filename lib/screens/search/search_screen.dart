import 'package:flutter/material.dart';

import 'components/body.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = "/search";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('검색')),
          automaticallyImplyLeading: false
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Body(),
      ),
    );
  }
}
