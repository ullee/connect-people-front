import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

Future<Post> fetchPost() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Post> post = fetchPost();
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*
          FutureBuilder<Post>(
              future: post,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("로그인이 필요합니다.");
                } else {
                  return TextButton.icon(
                      onPressed: null,
                      icon: IconBtnWithCounter(
                        svgSrc: "assets/icons/Log out.svg",
                        press: () => Navigator.pushNamed(context, SignInScreen.routeName),
                      ),
                      label: Text(snapshot.data.userId.toString())
                  );
                }
              }
          ),
          */
          SearchField(),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 3,
            press: () {},
          ),
        ],
      ),
    );
  }
}
