import 'package:connect_people/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connect_people/models/NoticeDetail.dart';
import 'package:connect_people/constants.dart';
import 'dart:convert';

import 'notice_description.dart';

class Body extends StatefulWidget {
  final int notice_id;

  const Body({Key key, @required this.notice_id}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  Future<NoticeDetail> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(HOST_LAMBDA + '/dev/v1/notice/${widget.notice_id}',
        headers: {'token': prefs.getString('token')});
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }

    Map jsonData = json.decode(response.body);

    return NoticeDetail.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NoticeDetail>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                  padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                  // width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      NoticeDescription(
                        noticeDetail: snapshot.data,
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
