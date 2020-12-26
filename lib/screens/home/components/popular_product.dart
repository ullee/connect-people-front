import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../../size_config.dart';
import 'section_title.dart';

import 'package:json_annotation/json_annotation.dart';
part 'popular_product.g.dart';

@JsonSerializable()
class Board {
  final int ID;
  final String brandName;
  final int memberID;
  final String title;
  final String subTitle;
  final String content;
  final String imageUrl;
  final String created;
  Board({this.ID, this.brandName, this.memberID, this.title, this.subTitle, this.content, this.imageUrl, this.created});
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}

Future<List<Board>> fetchAll() async {
  final response = await http.get('http://52.79.191.174/boards');
  if (response.statusCode != 200) {
    throw Exception("Fail to request API");
  }

  var jsonData = jsonDecode(response.body)['data'] as List;
  List<Board> boards = jsonData.map((json) => Board.fromJson(json)).toList();

  print(boards);

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
                          leading: Image.network(snapshot.data[index].imageUrl, width: 52, height: 50,),
                          title: Text(snapshot.data[index].title ?? ""),
                          subtitle: Text(snapshot.data[index].subTitle ?? ""),
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
