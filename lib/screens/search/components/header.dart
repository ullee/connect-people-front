import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'search_field.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(),
        ],
      ),
    );
  }
}
