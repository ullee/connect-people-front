import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/models/Profile.dart';

import 'package:shop_app/constants.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<Profile> _fetch() async {
    final response = await http.get(HOST_CORE + '/me?memberID=1');
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }
    Map jsonData = json.decode(response.body)['data'];
    return Profile.fromJson(jsonData);
  }

  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    ProfilePic(),
                    SizedBox(height: 20),
                    Text(snapshot.data.name ?? "-"),
                    Text(snapshot.data.loginId ?? "-"),
                    Text(snapshot.data.phone ?? "-"),
                    Row(
                      children: [
                        Text("마케팅 정보 수신 동의"),
                        Switch(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value;
                            });
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text("버전정보"),
                        Text("V1.0.0"),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ],
                ));
          } else {
            return Container(
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
        });
  }
}
