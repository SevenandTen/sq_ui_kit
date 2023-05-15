import 'package:flutter/material.dart';

import '../source_control.dart';

class SQSelectedBtn extends StatelessWidget {
  final bool selected;

  const SQSelectedBtn({super.key, required this.selected});
  @override
  Widget build(BuildContext context) {
    String imageName = "assert/images/btn_xz_nor@2x.png";
    if(selected) {
      imageName = "assert/images/btn_xz_pre@2x.png";
    }
    return Image.asset(SourceControl.getPath(imageName),width: 20,height: 20,);

  }



}
