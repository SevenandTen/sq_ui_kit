
import 'package:flutter/material.dart';

class SQBottomSheet extends StatefulWidget {
  final List<String> contentList ;
  final Color themeColor;
  final Color deleteColor;
  final String title;
  final int selectedIndex;
  final Function(int location)? callback;

  const SQBottomSheet({super.key,
    required this.contentList,
    this.themeColor = Colors.blue,
    this.deleteColor = Colors.black,
    this.title = "",  this.selectedIndex = -1, this.callback});

  @override
  State<StatefulWidget> createState() {
    return _SQBottomState();
  }

  static Future show({required BuildContext context ,
    required List<String> contentList,
    Color themeColor = Colors.blue,
    Color deleteColor = Colors.black,
    int selectedIndex = -1,
    String title = "",
    Function(int location)? callback,
  }) async {
    return  await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SQBottomSheet(
          title: title,
          contentList: contentList,
          themeColor: themeColor,
          deleteColor: deleteColor,
          selectedIndex: selectedIndex,
          callback: callback,
        );
      },
    );
  }

}

class _SQBottomState extends State<SQBottomSheet> {
  int selectedIndex = - 1;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.contentList.length;
    if(count > 4) {
      count = 4;
    }
    double height = count * 60 + 60 + 10 +  MediaQuery.of(context).padding.bottom;
    if(widget.title.isNotEmpty) {
      height = height + 40;
    }

    return Container(
      height: height,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(children: [
        Expanded(child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),

          child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
            if(widget.title.isNotEmpty)
              Container(height: 40,alignment: Alignment.center,child: Text(widget.title,style: const TextStyle(fontSize: 15,color: Colors.black38),),),
            Expanded(child:  ListView.builder(itemBuilder: (context,index) {
              return _getItemWidget(widget.contentList[index], index);
            },itemCount: widget.contentList.length,padding: EdgeInsets.zero, )),
          ],)

        )),
        const SizedBox(height: 10,),
        GestureDetector(
        onTap: () {
          Navigator.pop(context);
          if(widget.callback != null) {
            widget.callback!(-1);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          height: 60 ,
          alignment: Alignment.center,
          child:  Text("取消",style: TextStyle(color: widget.deleteColor,),),
        ),
      ),
      ],),

    );
  }


  Widget _getItemWidget(String text, int index) {
    return   GestureDetector(
      onTap: () {
        setState(() {

        });
        selectedIndex = index;
        Navigator.pop(context);
        if(widget.callback != null) {
          widget.callback!(selectedIndex);
        }
      },
      child: Container(
        color: Colors.transparent,
        height: 60 ,
        alignment: Alignment.center,
        child:  Text(text,style: TextStyle(color: index == selectedIndex ? widget.themeColor: Colors.black,),),
      ),
    );
  }


}