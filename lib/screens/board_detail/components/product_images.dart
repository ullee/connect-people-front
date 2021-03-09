import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../../models/BoardDetail.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.boardDetail,
  }) : super(key: key);

  final BoardDetail boardDetail;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300.0,
      child: Swiper(
        loop: false,
        itemCount: widget.boardDetail.imageUrls.length,
        scrollDirection: Axis.horizontal,
        pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            builder: FractionPaginationBuilder(
                color: Colors.grey, activeColor: Colors.blueGrey, fontSize: 10, activeFontSize: 10
            )
        ),
        itemBuilder: (context, index) {
          var image = widget.boardDetail.imageUrls[index];
          return Container(
            width: 300.0,
            height: 300.0,
            child: Image.network(image, fit: BoxFit.contain),
          );
        },
      )
    );
  }
}
