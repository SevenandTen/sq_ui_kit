

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SQAlert extends StatelessWidget {
  final String title; //标题
  final String content; //内容
  final String cancelText; //按钮文案
  final String okText; //按钮文案
  final Color buttonColor; //按钮颜色
  final Function(int index)? callback; //按钮点击事件

  static show(
      BuildContext context,
      String content, {
        String title = "",
        String okText = "确定",
        String cancelText = "",
        Color buttonColor = const Color(0xFF3169F3),
        Function(int index)? callback,
      }) {

    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          child: SQAlert(
            content,
            title: title,
            okText: okText,
            cancelText: cancelText,
            buttonColor: buttonColor,
            callback: callback,
          ),
          onWillPop: () async {
            return false;
          },
        );
      },
    );
  }

  SQAlert(
      this.content, {
        this.title = "",
        this.okText = "确定",
        this.cancelText = "",
        this.buttonColor = const Color(0xFF01D28E),
        this.callback,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 55,
                padding: EdgeInsets.only(left: 20, top: 32, right: 20, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //标题
                    if (title.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Color(0xffaaaaaa)),
                          maxLines: null,
                        ),
                      ),
                    //内容
                    Text(
                      content,
                      style: TextStyle(fontSize: 16, color: Color(0xff333333)),
                    ),
                    SizedBox(height: 32),
                    //按钮
                    _getBtnWidget(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///按钮
  Widget _getBtnWidget(BuildContext context) {
    return Container(
      height: 44,
      child: Row(
        children: [
          if (cancelText.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (callback != null) {
                  callback!(0);
                }
              },
              child: Container(
                height: 44,
                alignment: Alignment.center,
                width: (MediaQuery.of(context).size.width - 107) / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.0, color: buttonColor),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(
                  cancelText,
                  style: TextStyle(fontSize: 18, color: buttonColor),
                ),
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (callback != null) {
                  callback!(1);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 44,
                margin: EdgeInsets.only(left: cancelText.isEmpty ? 0 : 12),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(
                  okText,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}