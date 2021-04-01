import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:connect_people/screens/board_detail/board_detail_screen.dart';
import 'dart:async';
import 'dart:convert';
import '../../../size_config.dart';
import '../../../constants.dart';
import '../../../models/Board.dart';

class Boards extends StatefulWidget {
  const Boards({Key key, @required this.categoryID}) : super(key: key);

  final int categoryID;

  @override
  _Boards createState() => _Boards();
}

class _Boards extends State<Boards> {
  Future<List<Board>> fetch(int categoryID) async {
    final response = await http
        .get(HOST_CORE + '/boards/categories/' + categoryID.toString());
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }

    var jsonData = jsonDecode(response.body)['data'] as List;
    List<Board> boards = jsonData.map((json) => Board.fromJson(json)).toList();

    return boards;
  }

  Widget _images(context, snapshot, index) {
    return Container(
        height: 189,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, BoardDetailScreen.routeName,
              arguments:
                  BoardDetailArguments(boardID: snapshot.data[index].ID)),
          child: Container(
            // padding: EdgeInsets.all(getProportionateScreenWidth(8)),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(snapshot.data[index].imageUrl),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(5.0),
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
        ));
  }

  Widget _content(context, snapshot, index) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 5.0),
      Text(
        snapshot.data[index].majorCategoryName,
        style: TextStyle(
            color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 10.0),
      Text(
        snapshot.data[index].title,
        style: TextStyle(
            color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 10.0),
      Text(
        snapshot.data[index].content,
        style: TextStyle(color: Colors.black, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 10.0),
      Container(
          child: Row(
        children: <Widget>[
          Container(
            child: SvgPicture.asset(
              "assets/icons/Heart Icon_2.svg",
              color: Colors.orange,
              height: getProportionateScreenWidth(9),
            ),
          ),
          Container(
            child: Text(
              " 98",
              style: TextStyle(color: Colors.black, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: FutureBuilder(
          future: fetch(widget.categoryID),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  // child: CupertinoActivityIndicator(),
                  child: Text("카테고리 내 게시글이 존재하지 않습니다."),
                ),
              );
            } else {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // SizedBox(height: 15.0),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 1.0,
                      ),
                      physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: 15.0, left: 6.0, right: 6.0, top: 15.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _images(context, snapshot, index),
                                _content(context, snapshot, index),
                              ]),
                        );
                      },
                    )
                  ]);
            }
          },
        ));
  }
}
