import 'dart:math';

import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int rand1 = Random().nextInt(9); // 총 등록건수 @TODO:추후 실제 카운팅으로 변경
    int rand2 = Random().nextInt(9); // 신규 등록건수 @TODO:추후 실제 카운팅으로 변경

    // Future<Post> post = fetchPost();
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "총 등록건수 :",
                style: TextStyle(color: Colors.black, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "신규등록건수 :",
                style: TextStyle(color: Colors.black, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "***" + rand1.toString(),
                style: TextStyle(color: Colors.black, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "**" + rand2.toString(),
                style: TextStyle(color: Colors.black, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          /*
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 3,
            press: () {},
          ),
          */
        ],
      ),
    );
  }
}
