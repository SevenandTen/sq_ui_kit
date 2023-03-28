

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SQCarNumberPicker {

  static void showCarNumberPicker({
    required BuildContext context,
    String? carNumber,
    Function(String number)? callBack }){
    assert(context != null);

    showModalBottomSheet(context: context, backgroundColor: Colors.transparent,builder: (context) {
      return WYCarNumberView(carNumber: carNumber,callBack: callBack,);
    });
  }

  static List<String> provinceList = [
    "京","津","冀","鲁","晋","蒙","辽","吉","黑",
    "沪","苏","浙","皖","闽","赣","豫","鄂","湘",
    "粤","桂","渝","川","贵","云","藏","陕","甘",
    "青","琼","新","宁","港","澳","台",];

  static List<String> noSupportProvinceList = ["港","澳","台",];

  static List<String> charList = [
    "1","2","3","4","5","6","7","8","9","0",
    "A","B","C","D","E","F","G","H","J","K",
    "L","M","N","P","Q","R","S","T","U","V",
    "W","X","Y","Z",
  ];

}


class WYCarNumberView extends StatefulWidget {
  final Function(String number)? callBack;
  final String? carNumber;

  const WYCarNumberView({Key? key, this.callBack, this.carNumber}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return WYCarNumberState();
  }

}

class WYCarNumberState extends State<WYCarNumberView> {
  Color unableColor =  Color(0xFFB4F1D6);
  Color ableColor = Color(0xFF01D28E);

  bool isNew = false;
  int step = 0;
  String zero = "";
  String one = "";
  String two = "";
  String three = "";
  String four = "";
  String five = "";
  String six = "";
  String seven = "";
  @override
  void initState() {
    super.initState();
    if(widget.carNumber != null && widget.carNumber!.isNotEmpty) {
      List<String> list = widget.carNumber!.split("");
      for(int i = 0 ; i < list.length ; i ++ ) {
        if(i == 0 ){
          zero = list[i];
        }else if(i == 1) {
          one = list[i];
        }else if(i == 2) {
          two = list[i];
        }else if(i == 3) {
          three = list[i];
        }else if(i == 4) {
          four = list[i];
        }else if(i == 5) {
          five = list[i];
        }else if(i == 6) {
          six = list[i];
        }else if(i == 7) {
          seven = list[i];
        }
      }
      if(widget.carNumber!.length == 8) {
        isNew = true;
      }
      step = widget.carNumber!.length - 1;

    }
  }

  @override
  Widget build(BuildContext context) {
    double someWidth = (MediaQuery.of(context).size.width -  60 )  / 10.0 ;
    double someHeight = 42;
    List<String> charList = [zero,one,two,three,four,five,six,seven];
    List<Widget> list = [];
    list.add(Spacer());
    for(int i = 0 ; i < charList.length ; i ++) {
      if(i != 7 || (i == 7 && isNew == true))  {
        list.add(
          WYCarNumberItemView(height: someHeight, width: someWidth,text: charList[i],selected: step == i,callBack: () {
              step = i ;
              setState(() {

              });
          },),
        );
      }
      if(i == 1) {
        list.add(SizedBox(width: 30,));
      }else if(i == 6 && isNew == true) {
        list.add(SizedBox(width: 8,));
      }else if( i != 7) {
        list.add(SizedBox(width: 8,));
      }

    }
    list.add(Spacer());

    bool sure = _canSure();

   return Container(
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24)),
     ),
     child: Column(mainAxisSize: MainAxisSize.min,children: [
       Container(
         height: 50,
         color: Colors.transparent,
         child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
            SizedBox(width: 60,),
            Spacer(),
            Text("输入车牌号",style: TextStyle(fontSize: 16,color: Color(0xFF333333)),),
            Spacer(),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                if(sure && widget.callBack != null) {
                  widget.callBack!(_getCarNumber());
                }
              },
              child:  Container(
                color: Colors.transparent,
                height: 50,
                width: 60,
                alignment: Alignment.center,
                child: Text("确定",style: TextStyle(color: sure ? ableColor : unableColor,fontSize: 15 ),),

              ),
            ),

         ],),
       ),
       Container(color: Color(0xFFE9E9E9),height: 0.5,),
       SizedBox(height: 33,),
       Row(crossAxisAlignment: CrossAxisAlignment.center,children: list,),
       SizedBox(height: 12,),
       Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
         Spacer(),
         GestureDetector(
           onTap: (){
            isNew = ! isNew;
            if(isNew == true) {
              if(step == 6 && six.isNotEmpty) {
                step = 7;
              }
            }else {
              if(step == 7) {
                step = 6;
              }
            }
            setState(() {

            });
           },
           child: Container(
             color: Colors.transparent,
             child: Row(children: [
               Image.asset( isNew ? "assets/btn_xz_pre@2x.png" : "assets/btn_xz_nor@2x.png",width: 20,height: 20,),
               SizedBox(width: 7,),
               Text("新能源车",style: TextStyle(color: Color(0xFF01D28E),fontSize: 15),),
               SizedBox(width: 12,),
             ],),
           ),
         ),
       ],),
       SizedBox(height: 18,),
       WYCarNumberInputView(step: step,isNew: isNew,callBack: (text){
         if(text == "-1") {
           if(step == 0) {
               zero = "";
           }else if(step == 1) {
               one = "";
               step = step - 1;
           }else if(step == 2) {
               two = "";
               step = step - 1;
           }else if(step == 3) {
               three = "";
               step = step - 1;
           }else if(step == 4) {
               four = "";
               step = step - 1;
           }else if(step == 5) {
               five = "";
               step = step - 1;
           }else if(step == 6) {
               six = "";
               step = step - 1;
           }else if(step == 7) {
             seven = "";
             step = step - 1;
           }
         }else {
           if(step == 0) {
             zero = text;
             step = step + 1;
           }else if(step == 1) {
             one = text;
             step = step + 1;

           }else if(step == 2) {
             two = text;
             step = step + 1;
           }else if(step == 3) {
             three = text;
             step = step + 1;
           }else if(step == 4) {
             four = text;
             step = step + 1;
           }else if(step == 5) {
             five = text;
             step = step + 1;
           }else if(step == 6) {
             six = text;
             if(isNew) {
               step = step + 1;
             }

           }else if(step == 7) {
             seven = text;

           }
         }
         setState(() {

         });


       },),
       SizedBox(height: MediaQuery.of(context).padding.bottom,),

     ],),
   );
  }


  bool _canSure() {
    if(isNew == true) {
      return zero.isNotEmpty && one.isNotEmpty && two.isNotEmpty && three.isNotEmpty && four.isNotEmpty && five.isNotEmpty && six.isNotEmpty && seven.isNotEmpty;
    }else {
      return  zero.isNotEmpty && one.isNotEmpty && two.isNotEmpty && three.isNotEmpty && four.isNotEmpty && five.isNotEmpty && six.isNotEmpty;
    }
  }

  String _getCarNumber() {
    if(isNew) {
      return zero + one + two + three + four + five + six + seven;
    }else {
      return  zero + one + two + three + four + five + six;
    }
  }

}


class WYCarNumberItemView extends StatelessWidget {
  final double height;
  final double width;
  final bool selected;
  final String text;
  final Function? callBack;

  const WYCarNumberItemView({Key? key, required this.height, required this.width, this.selected = false, this.text = "", this.callBack}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: (){
      if(callBack != null) {
        callBack!();
      }
     },
     child: Container(
       height: height,
       width: width,
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.all(Radius.circular(5)),
         border: Border.all(color: selected ? Color(0xFF01D28E) : Color(0xFFAAAAAA),width: 0.5),
       ),
       alignment: Alignment.center,
       child: Text(text,style: TextStyle(fontSize: 16,color: Color(0xFF333333)),),
     ),
   );
  }
  
}




class WYCarNumberInputView extends StatelessWidget {
  final int step;
  final Function(String text)? callBack;
  final bool isNew;

  const WYCarNumberInputView({Key? key, this.step = 0, this.callBack, this.isNew = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double someWidth = (MediaQuery.of(context).size.width -  60 )  / 10.0 ;
    double someHeight = 42;

    List<Widget> list = [];

      for(int i = 0 ; i < 4 ; i ++) {
        List<Widget> subList = [];
        subList.add(Spacer());
        if(step == 0) {
          for(int j = 0 ; j < 9 ; j ++) {
            int location = i * 9 + j ;
            if(location < SQCarNumberPicker.provinceList.length) {
              String char = SQCarNumberPicker.provinceList[location];
              subList.add(WYCarNumberInputItemView(
                width: someWidth,
                height: someHeight,
                inputType: 1,
                unable:SQCarNumberPicker.noSupportProvinceList.contains(char),
                char: char,
                callBack: () {
                  if(callBack != null) {
                    callBack!(char);
                  }
                },
              ));
              if( j != 8) {
                subList.add(SizedBox(width: 6,));
              }
            }else if(location == SQCarNumberPicker.provinceList.length) {
              subList.add(WYCarNumberInputBackBtn(width: someWidth * 2 + 6, height: someHeight,callBack: (){
                if(callBack != null) {
                  callBack!("-1");
                }
              },));
            }

          }
        }else {
          for(int j = 0 ; j < 10 ; j ++) {
            int location = i * 10 + j ;
            if(location < SQCarNumberPicker.charList.length) {
              String char = SQCarNumberPicker.charList[location];
              subList.add(WYCarNumberInputItemView(
                width: someWidth,
                height: someHeight,
                inputType: 2,
                unable: (step == 1 && location < 10),
                char: char,
                callBack: () {
                  if(callBack != null) {
                    callBack!(char);
                  }
                },
              ));
              if( j != 9) {
                subList.add(SizedBox(width: 6,));
              }
            }else if(location == SQCarNumberPicker.charList.length) {
              subList.add(WYCarNumberInputItemView(
                width: someWidth * 2 + 6,
                height: someHeight,
                inputType: 2,
                unable: (step < 6 || (step == 6 && isNew == true)),
                char: "挂",
                callBack: () {
                  if(callBack != null) {
                    callBack!("挂");
                  }
                },
              ));
              subList.add(SizedBox(width: 6,));
              subList.add(WYCarNumberInputBackBtn(width: someWidth * 2 + 6, height: someHeight,callBack: (){
                if(callBack != null) {
                  callBack!("-1");
                }
              },));
            }

          }
        }

        subList.add(Spacer());
        list.add(Row(crossAxisAlignment: CrossAxisAlignment.center,children: subList,));
        list.add(SizedBox(height: 12,));
      }



    return Container(
        child: Column(children: list,),
    );
  }

}



class WYCarNumberInputItemView extends StatefulWidget {
  final double width;
  final double height;
  // 1为省 2 为 数字字母;
  final int inputType;
  final bool unable;
  final String char;
  final Function? callBack;

  const WYCarNumberInputItemView({Key? key, this.inputType = 2, required this.width, required this.height, this.unable = true, this.char = "", this.callBack}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return WYCarNumberInputItemState();
  }

}

class WYCarNumberInputItemState extends State<WYCarNumberInputItemView> {

  bool selected = false;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: (){
          if(widget.unable != true && widget.callBack != null) {
            widget.callBack!();
          }
        },
        onTapUp: (_) {
          selected = false;
          setState(() {

          });
        },
        onTapDown: (_) {
          selected = true;
          setState(() {

          });
        },
        onTapCancel: () {
          selected = false;
          setState(() {

          });
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: _getDecoration(),
          alignment: Alignment.center,
          child: Text(widget.char,style: _getStyle(),),


        ),
      );
  }

  TextStyle _getStyle() {
    if(widget.inputType == 1) {
      if(widget.unable == true) {
        return TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: Color(0x66333333));
      }else {
        return TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: selected ? Colors.white : Color(0xFF333333));
      }
    }else {
        if(widget.unable == true ) {
          return TextStyle(fontSize: 16,color:  Color(0xFF666666));
        }else {
          return TextStyle(fontSize: 16,color: selected ? Colors.white : Color(0xFF333333));
        }
    }

  }

  Decoration _getDecoration() {
    if(widget.inputType == 1) {
      if(widget.unable == true) {
        return BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Color(0x66D5D5D5),width: 0.5),
        );
      }else {
        return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Color(0xFFD5D5D5),width: selected ? 0 : 0.5),
          color: selected ? Color(0xFF01D28E) : Colors.white,
        );
      }
    }else {
        if(widget.unable == true) {
          return BoxDecoration(
            color: Color(0xFFF1F2F3),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Color(0xFFD5D5D5),width: 0.5),
          );
        }else {
          return BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Color(0xFFD5D5D5),width: selected ? 0 : 0.5),
            color: selected ? Color(0xFF01D28E) : Colors.white,
          );
        }
    }
  }



}


class WYCarNumberInputBackBtn extends StatefulWidget {
  final double width;
  final double height;
  final Function? callBack;

  const WYCarNumberInputBackBtn({Key? key, this.callBack, required this.width, required this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WYCarNumberInputBackState();
  }

}


class WYCarNumberInputBackState extends State<WYCarNumberInputBackBtn> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.callBack != null) {
          widget.callBack!();
        }
      },
      onTapUp: (_) {
        selected = false;
        setState(() {

        });
      },
      onTapDown: (_) {
        selected = true;
        setState(() {

        });
      },
      onTapCancel: () {
        selected = false;
        setState(() {

        });
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: selected ? Color(0x59000000) : Color(0xFFC7CCD2),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Color(0xFFD5D5D5),width: 0.5),
        ),
        alignment: Alignment.center,
        child: Image.asset("assets/icon_back@2x.png",width: 22.5,height: 16,),

      ),
    );
  }



}
