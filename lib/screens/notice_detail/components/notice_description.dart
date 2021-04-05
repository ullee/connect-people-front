import 'package:flutter/material.dart';
import 'package:connect_people/models/NoticeDetail.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../size_config.dart';

class NoticeDescription extends StatelessWidget {
  const NoticeDescription({
    Key key,
    @required this.noticeDetail,
    this.pressOnSeeMore,
  }) : super(key: key);

  final NoticeDetail noticeDetail;
  final GestureTapCallback pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(noticeDetail.title, style: Theme.of(context).textTheme.headline6),
        ),
        Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(64)),
          child: Text(noticeDetail.created, style: TextStyle(color: Colors.grey, fontSize: 12), maxLines: 3),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: Linkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            text: noticeDetail.content,
          ),
        )
      ],
    );
  }
}
