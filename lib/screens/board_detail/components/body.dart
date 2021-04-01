import 'package:connect_people/screens/sign_in/sign_in_screen.dart';
import 'package:connect_people/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connect_people/models/BoardDetail.dart';
import 'package:connect_people/constants.dart';
import 'product_description.dart';
import 'product_images.dart';
import 'dart:convert';

class Body extends StatefulWidget {
  final int boardID;

  const Body({Key key, @required this.boardID}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<BoardDetail> fetch() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') == null) {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }

    final response = await http.get(
        HOST_CORE + '/boards/${widget.boardID}/detail',
        headers: {'token': prefs.getString('token')});
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }

    Map jsonResult = json.decode(response.body)['result'];
    Map jsonData = json.decode(response.body)['data'];

    if (jsonResult != null && jsonResult['code'] != 1) {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }

    return BoardDetail.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BoardDetail>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                ProductImages(boardDetail: snapshot.data),
                Container(
                  margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                  padding:
                      EdgeInsets.only(top: getProportionateScreenWidth(20)),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      ProductDescription(
                        boardDetail: snapshot.data,
                        pressOnSeeMore: () {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container(
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
        });
  }
}
