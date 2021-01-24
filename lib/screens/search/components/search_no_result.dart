import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';


class _SearchNoResultState extends State<SearchNoResult> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Text("no search")
    );
  }
}

class SearchNoResult extends StatefulWidget {
  const SearchNoResult({
    Key key,
  }) : super(key: key);

  @override
  _SearchNoResultState createState() => _SearchNoResultState();
}
