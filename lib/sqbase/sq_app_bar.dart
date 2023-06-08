import 'package:flutter/material.dart';
import 'package:squikit/source_control.dart';

class SQAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度
  final Color backgroundColor; //设置导航栏背景的颜色
  final bool canBack;
  final Widget? leadingWidget;
  final Widget? middleWidget;
  final Widget? trailingWidget;
  final String title;
  final Color titleColor;
  final Function? onBack;


  SQAppBar({
    this.canBack = true,
    required this.title,
    this.contentHeight = 44,
    this.backgroundColor = Colors.white,
    this.trailingWidget,
    this.titleColor = Colors.black87,
    this.onBack,
    this.leadingWidget,
    this.middleWidget,
  }) : super();

  @override
  State<StatefulWidget> createState() {
    return SjbAppBarState();
  }

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

class SjbAppBarState extends State<SQAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: SafeArea(
        top: true,
        child: Container(
          height: widget.contentHeight,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (widget.canBack)
                Positioned(
                  left: 0,
                  child: GestureDetector(
                      child: _leftWidget(context),
                      onTap:(){
                        if (widget.onBack != null) {
                          widget.onBack!();
                        }else{
                          Navigator.pop(context);
                        }
                      }
                  ),
                ),
              _middleWidget(context),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: widget.trailingWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _leftWidget(context){
    if (widget.leadingWidget != null) {
      return widget.leadingWidget;
    }else{
      return Container(
        color: Colors.transparent,
        width: widget.contentHeight,
        height: widget.contentHeight,
        child: Center(
          child: Image.asset(SourceControl.getPath("assert/images/ico_nav_back44@2x.png"),width: 22,height: 22,color: widget.titleColor,),
        ),
      );
    }
  }

  _middleWidget(context){
    if (widget.middleWidget != null) {
      return widget.middleWidget;
    }else{
      return Container(
        margin: EdgeInsets.only(left: 40,right: 40),
        child: Text(
          widget.title,
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
            color: widget.titleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }
}
