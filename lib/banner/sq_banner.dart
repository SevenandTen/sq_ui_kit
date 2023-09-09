


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SQBanner extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double itemHeight;
  final double itemWidth;
  final bool autoplay;
  final Color dotActColor;
  final Color dotDefaultColor;

  const SQBanner({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.itemHeight,
    required this.itemWidth,
    this.autoplay = true,
    this.dotDefaultColor = Colors.white,
    this.dotActColor = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: itemCount,
      autoplay: autoplay && itemCount > 1,
      duration: 500,
      autoplayDelay: 2000,
      itemBuilder: itemBuilder,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      layout: SwiperLayout.CUSTOM,
      customLayoutOption: CustomLayoutOption(
        startIndex: -1,
        stateCount: 3,
      ).addTranslate([
        Offset(-itemWidth, 0.0),
        Offset(0.0, 0.0),
        Offset(itemWidth, 0.0)
      ]),
      pagination: SwiperPagination(
        margin: EdgeInsets.only(top: itemHeight - 20),
        builder: DotSwiperPaginationBuilder(color: dotDefaultColor, activeColor: dotActColor),
      ),
    );
  }
}