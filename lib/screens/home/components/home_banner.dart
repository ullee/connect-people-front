import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../../models/Banners.dart';
import '../../../size_config.dart';
import '../../../constants.dart';

class HomeBanner extends StatefulWidget {
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {

  Future<List<Banners>> fetch() async {
    final response = await http.get(HOST_CORE + '/banners');
    if (response.statusCode != 200) {
      throw Exception("Fail to request banners API");
    }

    var jsonData = jsonDecode(response.body)['data'] as List;
    List<Banners> banners = jsonData.map((json) => Banners.fromJson(json)).toList();
    return banners;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                width: double.infinity,
                height: 130.0,
                child: Swiper(
                  autoplay: true,
                  autoplayDelay: 5000,
                  loop: true,
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomRight,
                      builder: FractionPaginationBuilder(
                          color: Colors.grey, activeColor: Colors.blueGrey, fontSize: 10, activeFontSize: 10
                      )
                  ),
                  itemBuilder: (context, index) {
                    return Image.network(snapshot.data[index].imageUrl, fit: BoxFit.cover);
                  },
                )
            );
          } else {
            return Container(
                width: double.infinity,
                margin: EdgeInsets.all(getProportionateScreenWidth(0)),
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenWidth(20),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  // borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text.rich(
                    TextSpan(style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(text: "Connect People\n"), TextSpan(text: "내일의 광고 주인공은 당신입니다.", style: TextStyle(fontSize: getProportionateScreenWidth(22), fontWeight: FontWeight.bold,),),
                      ],
                    ),
                  ),
                )
            );
          }
        },
    );
  }
}
