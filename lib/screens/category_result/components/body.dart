import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'boards.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Boards()
          ],
        ),
      ),
    );
  }
}
