import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_people/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:connect_people/screens/board_detail/board_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import '../../../size_config.dart';
import '../../../constants.dart';
import '../../../models/Board.dart';

Future<List<Board>> fetchAll() async {
  var uri = HOST_LAMBDA + '/v1/board';
  final response = await http.get(Uri.parse(uri));
  if (response.statusCode != 200) {
    throw Exception("Fail to request API");
  }

  var jsonData = jsonDecode(response.body)['items'] as List;
  // for (var i in jsonData) {print(i);}
  List<Board> boards = jsonData.map((json) => Board.fromJson(json)).toList();

  return boards;
}

class _PopularProducts extends State<PopularProducts> {

  bool hasToken = false;

  Future<bool> _check() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      return false;
    }
    hasToken = true;
    return true;
  }

  Widget _images(context, snapshot, index) {
    return Container(
        height: 180,
        child: InkWell(
          onTap: () => {
            if (hasToken == false) {
              Navigator.pushNamed(context, SignInScreen.routeName)
            } else {
              Navigator.pushNamed(context, BoardDetailScreen.routeName, arguments: BoardDetailArguments(boardID: snapshot.data[index].ID))
            }
          },
          child: CachedNetworkImage(
            imageUrl: snapshot.data[index].imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2.0,
                    blurRadius: 5.0,
                    )
                ],
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ));
  }

  Widget _content(context, snapshot, index, rand) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        SizedBox(height: 5.0),
        Text(
          snapshot.data[index].majorCategoryName,
          style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10.0),
        Text(snapshot.data[index].title, 
          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10.0),
        Text(snapshot.data[index].content,
          style: TextStyle(color: Colors.black, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10.0),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                child: SvgPicture.asset("assets/icons/Heart Icon_2.svg", color: Colors.orange, height: getProportionateScreenWidth(9),
            ),
          ),
          Container(
            child: Text(" " + rand.toString(), style: TextStyle(color: Colors.black, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
      ))
    ]);
  }

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height - 340,
        // constraints: BoxConstraints.tightForFinite(height: 1000),
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: FutureBuilder(
          future: fetchAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            } else {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.55,
                            mainAxisSpacing: 1.0,
                            crossAxisSpacing: 1.0,
                    ),
                    // physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      int rand1 = Random().nextInt(16) + 5; // 랜덤 추천수
                      return Container(
                        padding: EdgeInsets.only(bottom: 15.0, left: 6.0, right: 6.0, top: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _images(context, snapshot, index),
                            _content(context, snapshot, index, rand1),
                            ]
                          ),
                        );
                      },
                    ))
                  ]
              );
            }
          },
        ));
  }
}

class PopularProducts extends StatefulWidget {
  @override
  _PopularProducts createState() => _PopularProducts();
}
