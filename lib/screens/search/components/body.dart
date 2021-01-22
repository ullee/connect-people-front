import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'header.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    @required this.categoryIDs
  }) : super(key: key);

  final List<int> categoryIDs;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Header(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
