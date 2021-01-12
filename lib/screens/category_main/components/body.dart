import 'package:connect_people/models/Category.dart';
import 'package:connect_people/screens/category_main/components/medium_depth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:connect_people/size_config.dart';
import 'package:connect_people/constants.dart';

class Body extends StatefulWidget {
  @override
  _BodySate createState() => _BodySate();
}

Future<List<Category>> fetch() async {
  final response = await http.get(HOST_CORE + '/categories/major');
  if (response.statusCode != 200) {
    throw Exception("Fail to request API");
  }

  var jsonData = jsonDecode(response.body)['data'] as List;
  List<Category> categories = jsonData.map((json) => Category.fromJson(json)).toList();

  return categories;
}

class _BodySate extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: FutureBuilder(
            future: fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              } else {
                return Column(
                  children: <Widget>[
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var icon = Icons.airline_seat_recline_normal_outlined;
                        if (index == 1) {
                          icon = Icons.accessibility;
                        } else if (index == 2) {
                          icon = Icons.agriculture;
                        } else if (index == 3) {
                          icon = Icons.airplanemode_active_outlined;
                        }
                        return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MediumDepth(parentID: snapshot.data[index].ID))),
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                                semanticContainer: true,
                                elevation: 5,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(icon),
                                    SizedBox(height: 10.0),
                                    Text(snapshot.data[index].name ?? ""),
                                  ],
                                ),
                            )
                        );
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MediumDepth(parentID: snapshot.data[index].ID))),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(icon),
                                SizedBox(height: 10.0),
                                Text(snapshot.data[index].name ?? ""),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    ),
                  ],
                );
              }
            }),
      )
    );
  }
}
