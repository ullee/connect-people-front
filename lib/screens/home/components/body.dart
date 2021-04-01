import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'home_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
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
          // SizedBox(height: getProportionateScreenHeight(20)),
          Container(
              child: Column(
            children: [
              PopularProducts(),
            ],
          )),
        ],
      ),
    );
  }
}
