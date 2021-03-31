import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'boards.dart';

class Body extends StatefulWidget {
  const Body({Key key, @required this.categoryID}) : super(key: key);

  final int categoryID;

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
            Boards(categoryID: widget.categoryID)
          ],
        ),
      ),
    );
  }
}
