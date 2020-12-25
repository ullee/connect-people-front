import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../../size_config.dart';
import 'section_title.dart';


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

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      ID: json['ID'],
      brandName: json['brandName'],
      memberID:  json['memberID'],
      title:     json['title'],
      subTitle:  json['subTitle'],
      content:   json['content'],
      imageUrl:  json['imageUrl'],
      created:   json['created'],
    );
  }
}

Future<Board> fetchAll() async {
  final response = await http.get('http://52.79.191.174/boards');
  if (response.statusCode == 200) {
    return Board.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class PopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Board> board = fetchAll();
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "오늘의 파트너", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                demoProducts.length,
                (index) {
                  if (demoProducts[index].isPopular)
                    return ProductCard(product: demoProducts[index]);

                  return SizedBox
                      .shrink(); // here by default width and height is 0
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
