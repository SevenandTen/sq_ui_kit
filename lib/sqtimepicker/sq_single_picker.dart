

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SQSinglePicker {


  static void show({
    required BuildContext context ,
    required List<String> content,
    Function(int index)? callBack,
    Color themColor = const Color(0xFF01D28E),
  }) {
    showModalBottomSheet(context: context, backgroundColor:  Colors.transparent,builder: (context) {
      return _SQSingleSelectView(content: content,callBack: callBack,themColor: themColor,);
    });
  }


}


class _SQSingleSelectView extends StatefulWidget {
  final Function(int index)? callBack;
  final List<String> content;
  final Color themColor;

  const _SQSingleSelectView({Key? key, this.callBack, required this.content, required this.themColor}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SQSingleSelectState();
  }

}

class _SQSingleSelectState extends State<_SQSingleSelectView> {

  FixedExtentScrollController controller = FixedExtentScrollController();

  double itemHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24)),
      ),
      child:  Column(children: [
        Container(
          height: 48,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
            const SizedBox(width: 16,),
            _getBtnWithIndex(0),
           const Spacer(),
            _getBtnWithIndex(1),
           const SizedBox(width: 16,),
          ],),
        ),

        Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
          Expanded(child: Container(
            alignment: Alignment.center,
            child: CupertinoPicker.builder(
              selectionOverlay: Container(
              ),
              backgroundColor: Colors.white,
              itemExtent: itemHeight,
              scrollController: controller,
              onSelectedItemChanged: (index) {

              },
              childCount: widget.content.length,
              itemBuilder: (context,index) {
                String text = widget.content[index];
                return Text(text,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color:  Color(0xFF333333)  ) ,);
              },
            ),
          ) )
        ],)),


        SizedBox(height:MediaQuery.of(context).padding.bottom ,),
      ],),
    );

  }



  Widget _getBtnWithIndex(int index) {
    String title = index == 0 ? "取消" : "确定";

    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
        if(index == 1 && widget.callBack != null) {
          widget.callBack!(controller.selectedItem);
        }
      },
      child: Container(
        height: 48,width: 60,color: Colors.transparent,
        alignment: index == 0 ? Alignment.centerLeft : Alignment.centerRight,
        child: Text(title,style: TextStyle(fontSize: 15,color: index == 0 ? Color(0xFFAAAAAA) : widget.themColor),),
      ),
    );

  }

}
