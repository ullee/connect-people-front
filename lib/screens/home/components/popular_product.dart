import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/board_detail/board_detail_screen.dart';
import 'dart:async';
import 'dart:convert';

import '../../../size_config.dart';
import '../../../constants.dart';
import 'section_title.dart';
import '../../../models/Board.dart';

Future<List<Board>> fetchAll() async {
  final response = await http.get(HOST_CORE + '/boards');
  if (response.statusCode != 200) {
    throw Exception("Fail to request API");
  }

  var jsonData = jsonDecode(response.body)['data'] as List;
  List<Board> boards = jsonData.map((json) => Board.fromJson(json)).toList();

  return boards;
}

class _PopularProducts extends State<PopularProducts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: FutureBuilder(
          future: fetchAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    child: SectionTitle(title: "오늘의 파트너", press: () {}),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(snapshot.data[index].imageUrl, width: 52, height: 50),
                          title: Text(snapshot.data[index].title ?? ""),
                          subtitle: Text(
                              snapshot.data[index].subTitle + "\n" + snapshot.data[index].content ?? "",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis
                          ),
                          isThreeLine: true,
                          dense: true,
                          onTap: () => Navigator.pushNamed(
                            context,
                            BoardDetailScreen.routeName,
                            arguments: BoardDetailArguments(boardID: snapshot.data[index].ID)
                          ),
                        );
                    }
                  )
                ],
              );
            }
          },
        )
    );
  }
}

class PopularProducts extends StatefulWidget {
  @override
  _PopularProducts createState() => _PopularProducts();
}
