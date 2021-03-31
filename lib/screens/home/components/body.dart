import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'home_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';

class Body extends StatelessWidget {
  final aKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
              child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              HomeHeader(),
              // LayoutBuilder(builder: (context, constraints) {
              //   if (aKey.currentContext != null) {
              //     return Text('Max height: ${aKey.currentContext.size.height}');
              //   }
              //   return Text('dd');
              // }),
            ],
          )),
          Container(
              child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              HomeBanner(),
              // LayoutBuilder(builder: (context, constraints) {
              //   final box = context.findRenderObject() as RenderBox;
              //   return Text('Max height: ${box.size.height}');
              // }),
            ],
          )),
          Container(
              child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              PopularProducts(),
              // LayoutBuilder(builder: (context, constraints) {
              //   final box = context.findRenderObject() as RenderBox;
              //   return Text('Max height: ${box.size.height}');
              // }),
            ],
          )),
        ],
      ),
    );
  }
}
