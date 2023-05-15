


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squikit/source_control.dart';

class SQTimePicker  {
  // ignore: non_constant_identifier_names
  static int YYMM = 1;  /// 年月
  // ignore: non_constant_identifier_names
  static int YYMMDD = 2; /// 年月日
  // ignore: non_constant_identifier_names
  static int YYMMDDHH = 3; /// 年月日时间
  // ignore: non_constant_identifier_names
  static int YYMMDDHHmm = 4; ///年月日 时分钟
// ignore: non_constant_identifier_names

  static void showTimePicker({
      required BuildContext context ,
      int timeType = 1,
      int? beginYear,
      int? endYear,
      DateTime? nowDate,
      bool hasLongTime = false,
      Function(int startTime,int endTime)? callBack
  }) {
    DateTime now = DateTime.now();
    beginYear ??= now.year - 100;
    endYear ??= now.year + 100;
    assert(beginYear < endYear);
      showModalBottomSheet(context: context, backgroundColor:  Colors.transparent,builder: (context) {
        return SQTimeSelectView(timeType: timeType,beginYear: beginYear,endYear: endYear,hasLongTime: hasLongTime,currentDate:nowDate,callBack: callBack,);
      });

  }
  static void showTimeSelector({
    required BuildContext context ,
    bool supportAnyDay = false ,
    Function(int startTime,int endTime)? callBack
  }) {

    Navigator.push(context, CupertinoPageRoute(builder: (context){
      return SQDateSelectView(callBack: callBack,type: supportAnyDay == true ? 2 : 1,);
    }) );
  }

}


class SQTimeSelectView extends StatefulWidget {
  final Function(int startTime , int endTime)? callBack;
  final int? timeType;
  final bool? hasLongTime;
  final int? beginYear;
  final int? endYear;
  final DateTime? currentDate;

  const SQTimeSelectView({Key? key, this.callBack, this.timeType, this.hasLongTime, this.beginYear, this.endYear, this.currentDate}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SQTimeSelectState();
  }

}

class SQTimeSelectState extends State<SQTimeSelectView> {

  FixedExtentScrollController yearController = FixedExtentScrollController();
  FixedExtentScrollController monthController = FixedExtentScrollController();
  FixedExtentScrollController dayController = FixedExtentScrollController();
  FixedExtentScrollController timeController = FixedExtentScrollController();
  FixedExtentScrollController minController = FixedExtentScrollController();
  GlobalKey dayKey = GlobalKey();

  int? beginYear;
  int? endYear;

  int? currentYear;
  int? currentMonth;
  int? currentDay;
  int? currentTime;
  int? currentMinute;

  double itemHeight = 50;

  int count = 0;

  @override
  void initState() {
    super.initState();
    if(widget.beginYear != null && widget.beginYear != 0) {
      beginYear = widget.beginYear;
    }else {
      beginYear = 1900;
    }
    if(widget.endYear != null && widget.endYear != 0) {
      endYear = widget.endYear;
    }else {
      endYear = 3000;
    }
    DateTime now = DateTime.now();
    if(widget.currentDate != null) {
      now = widget.currentDate!;
    }
    currentYear = now.year;
    currentMonth = now.month;
    currentDay = now.day;
    currentTime = now.hour;
    currentMinute = now.minute;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      yearController.jumpToItem(currentYear! - beginYear!);
      monthController.jumpToItem(currentMonth! - 1);
      if(widget.timeType! >= 2) {
        dayController.jumpToItem(currentDay! - 1);
        if(widget.timeType! >= 3) {
          timeController.jumpToItem(currentTime! );
          if(widget.timeType! >= 4) {
            minController.jumpToItem(currentMinute! );
          }
        }
      }


    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _getContentHeight(),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24)),
      ),
      child:  Column(children: [
        Container(
          height: 48,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
            SizedBox(width: 16,),
            _getBtnWithIndex(0),
            Spacer(),
            _getBtnWithIndex(1),
            SizedBox(width: 16,),
          ],),


        ),

        Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
          _getContentWidget(0),
          _getContentWidget(1),
          if(widget.timeType! >= 2)
            _getContentWidget(2),
          if(widget.timeType! >= 3)
            _getContentWidget(3),
          if(widget.timeType! >= 4)
            _getContentWidget(4),
        ],)),

        if(widget.hasLongTime == true)
          Container(height: 5,color: const Color(0xFFE9E9E9) ,),
        if(widget.hasLongTime == true)
         GestureDetector(
           onTap: (){
              Navigator.pop(context);
              if(widget.callBack != null) {
                widget.callBack!(-1,-1);
              }
           },
           child:  Container(height: 50,color: Colors.transparent,child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: const [
             Spacer(),
             Text("长期有效",style: TextStyle(fontSize: 18,color: Color(0xFF333333)),),
             Spacer(),
           ],),),
         ),

        SizedBox(height:MediaQuery.of(context).padding.bottom ,),
      ],),
    );
  }


  double _getContentHeight() {
    if(widget.hasLongTime == true) {
      return 260 + 50 + 5 +  MediaQuery.of(context).padding.bottom;
    }
    return 260 + MediaQuery.of(context).padding.bottom;
  }

  Widget _getBtnWithIndex(int index) {
    String title = index == 0 ? "取消" : "确定";

    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
        if(index == 1 && widget.callBack != null) {
          DateTime? beginDate ;
          DateTime? endTime;
          if(widget.timeType == 1) {
            beginDate = DateTime(currentYear!,currentMonth!,1,0,0,0);
            endTime = DateTime(currentYear!,currentMonth!,_getDayCount(),23,59,59);
          }else if(widget.timeType == 2) {
            beginDate = DateTime(currentYear!,currentMonth!,currentDay!,0,0,0);
            endTime = DateTime(currentYear!,currentMonth!,currentDay!,23,59,59);
          }else if(widget.timeType == 3) {
            beginDate = DateTime(currentYear!,currentMonth!,currentDay!,currentTime!,0,0);
            endTime = DateTime(currentYear!,currentMonth!,currentDay!,currentTime!,59,59);
          }else if(widget.timeType == 4) {
            beginDate = DateTime(currentYear!,currentMonth!,currentDay!,currentTime!,currentMinute!,0);
            endTime = DateTime(currentYear!,currentMonth!,currentDay!,currentTime!,currentMinute!,59);
          }
          widget.callBack!(beginDate!.millisecondsSinceEpoch,endTime!.millisecondsSinceEpoch);

        }else {

        }
      },
      child: Container(
        height: 48,width: 60,color: Colors.transparent,
        alignment: index == 0 ? Alignment.centerLeft : Alignment.centerRight,
        child: Text(title,style: TextStyle(fontSize: 15,color: index == 0 ? Color(0xFFAAAAAA) : Color(0xFF01D28E)),),
      ),
    );

  }

  int _getDayCount() {

    switch(currentMonth) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2 :
        if(currentYear! % 4 == 0  && currentYear! % 100 != 0) {
          return 29;
        }else if(currentYear! % 400 == 0) {
          return 29;
        }else {
          return 28;
        }
      default :
        return 0 ;

    }
  }

  int _getChildCount(int location) {
    if(location == 0) {
      return endYear! - beginYear!;
      
    }else if(location == 1) {
      return 12;
    }else if(location == 2) {
      return _getDayCount();
    }else if(location == 3) {
      return 24;
    }else if(location == 4) {
      return 60;
    }else {
      return 0;
    }
  }


  Widget _getContentWidget(int location) {
    List list = [yearController,monthController,dayController,timeController,minController];

    return Expanded(child: Container(
      alignment: Alignment.center,
      child: CupertinoPicker.builder(
        selectionOverlay: Container(

        ),
        backgroundColor: Colors.white,
        itemExtent: itemHeight,
        scrollController: list[location],
        onSelectedItemChanged: (index) {
          if(location == 0) {
            currentYear = beginYear! + index;
            if(currentMonth == 2 && widget.timeType! >= 2) {
              int totalDay = _getDayCount();
              int locationDay = currentDay!;
              if(locationDay > totalDay) {
                dayController.jumpToItem(totalDay - 1);
                setState(() {

                });
              }
              else {
                count ++;
                setState(() {

                });
                dayController.jumpToItem(locationDay - 1);
              }

            }

          }else if(location == 1) {
            currentMonth = index + 1;
            if(widget.timeType! >= 2) {
              int totalDay = _getDayCount();
              int locationDay = currentDay!;
              if(locationDay > totalDay) {
                dayController.jumpToItem(totalDay - 1);
                setState(() {

                });
              }else {
                count ++;
                setState(() {

                });
                dayController.jumpToItem(locationDay - 1);

              }

            }

          }else if(location == 2) {
            currentDay = index + 1;
          }else if(location == 3) {
            currentTime = index;
          }else if(location == 4) {
            currentMinute = index;
          }


        },
        childCount: _getChildCount(location),
        itemBuilder: (context,index) {
          String text = "";
          if(location == 0) {
            text = "${beginYear! + index}年";
          }else if(location == 1) {
            text = "${index + 1}月";

          }else if(location == 2) {
            text = "${index + 1}日";
          }else if(location == 3) {
            text = "$index时";
          }else if(location == 4) {
            text = "$index分";
          }
          if(count % 2 == 0 ) {
            return Container(child: Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color:  Color(0xFF333333)  ) ,),);
          }else {
            return Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color:  Color(0xFF333333)  ) ,);
          }

        },



      ),
    ) );

  }

}

class SQDateSelectView extends StatefulWidget {
  final Function(int startTime , int endTime)? callBack;
  final int type ; // 1为不跨月 2 为跨月
  final int beginYear;

  const SQDateSelectView({Key? key, this.callBack, this.type = 1, this.beginYear = 2015,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    if(type == 1) {
      return  WYDateSelectState();
    }
    return WYCalendarSelectState();
  }


}

class WYDateSelectState extends State<SQDateSelectView> {
  PageController pageController = PageController(viewportFraction: 0.2);
  int? currentYear;
  int? currentMonth;
  int? nowYear;
  List<int> timeList = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    currentYear = now.year;
    nowYear = now.year;
    currentMonth = now.month;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      pageController.jumpToPage((100) * 12 + currentMonth! - 1);
    });

  }

  @override
  Widget build(BuildContext context) {

    double someSize = (MediaQuery.of(context).size.width ) / 5.0;

    List<int> someTimeList = [];
    if(timeList.length == 2) {
      int first = timeList.first;
      int last = timeList.last;
      if(first <= last) {
        someTimeList.add(first);
        someTimeList.add(last);
      }else {
        someTimeList.add(last);
        someTimeList.add(first);
      }
    }else if(timeList.length == 1) {
      someTimeList.add(timeList.first);
    }

    return Scaffold(body: Container(
      color: Colors.white,
      child: Column(children: [
        SizedBox(height: MediaQuery.of(context).padding.top,),
        Container(
            height: 44,
            child: Stack(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                _getNavigatorBtn(0,someTimeList),
                Spacer(),
                _getNavigatorBtn(1,someTimeList),
              ],) ,
              Center(child: Text("选择日期",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color:Color(0xFF333333) ),),),
            ],)
        ),
        Container(
          height: 38,
          color: Color(0xFFF6F7FB),
          child: _getTimeChildWidget(someTimeList),
        ),
        Container(
          height: 92,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Color(0x0F000000),offset: Offset(0,1.5),spreadRadius: 0,blurRadius: 2.5)],
          ),
          child: Column(children: [
              SizedBox(height:16 ,),
              Text("$currentYear年",style: TextStyle(fontSize:18,fontWeight: FontWeight.w600,color: Color(0xFF333333),),),
              Expanded(child: PageView.builder(itemBuilder: (context ,index) {
                double location = index / 12;
                bool flag = false;
                TextStyle style =  TextStyle(fontSize: 18,color: Color(0xFFAAAAAA));
                if(currentYear == nowYear! - 100 + location.toInt() && currentMonth == index % 12 + 1 ) {
                 flag = true;
                 style =  TextStyle(fontSize: 22,color: Color(0xFF333333),fontWeight: FontWeight.w600);
                }
                return GestureDetector(
                  onTap: (){
                    if(!flag) {
                      pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.linear);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: someSize,
                    alignment: Alignment.center,
                    child: Text("${(index % 12 )+ 1}月",style:style,),
                  ),
                );
              },
                // physics: AlwaysScrollableScrollPhysics(),
                itemCount: 200 * 12,
                controller: pageController,
                onPageChanged: (index) {
                  double location = index / 12;
                  currentYear = nowYear! - 100 + location.toInt();
                  currentMonth = index % 12 + 1;
                  setState(() {

                  });
                },
              )),
          ],),
        ),
        _getWeekWidget(),
        WYMonthItemView(year: currentYear,month: currentMonth,timeList: someTimeList,action: (timeStamp) {
          if(timeList.length != 0) {
            DateTime first = DateTime.fromMillisecondsSinceEpoch(timeList.first);
            if(first.year != currentYear || first.month != currentMonth) {
              timeList.clear();
            }
          }
          if(timeList.length == 2) {
            if(timeStamp > someTimeList.last) {
              timeList.remove(someTimeList.first);
            }
            if(timeStamp < someTimeList.last && someTimeList.first != timeStamp) {
              timeList.clear();
            }
          }else if(timeList.length == 1) {
            if(timeStamp < someTimeList.first && someTimeList.first != timeStamp) {
              timeList.clear();
            }
          }



          if(timeList.contains(timeStamp)) {
            timeList.remove(timeStamp);
          }else {
            if(timeList.length == 2 ) {
              timeList.removeAt(0);
              timeList.add(timeStamp);
            }else {
              timeList.add(timeStamp);
            }
          }

          setState(() {

          });

        },),



      ],),
    ),);

  }

  Widget _getTimeChildWidget(List list ) {

    if(list.isEmpty) {
      String year = currentYear.toString();
      String month = currentMonth.toString();
      if(currentMonth! < 10) {
        month = "0" + month;
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
        Spacer(),
        Text(year + "-" + month,style: TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),),
        Spacer(),
      ],);
      return Text(year + "-" + month,style: TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),);
    }else  {
      DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(list.first);
      String year = dateTime1.year.toString();
      String month = dateTime1.month.toString();
      String day1 = dateTime1.day.toString();
      if(dateTime1.month < 10) {
        month = "0" + month;
      }
      if(dateTime1.day < 10) {
        day1 = "0" + day1;
      }
      if(list.length == 1) {
      ///assets/ico_hyxq_arrived@2x.png
        return Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
          Spacer(),
          Text(year + "-" + month + "-" + day1,style: TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),),
          Spacer(),
        ],);
      }else {
        DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(list.last);
        String day2 = dateTime2.day.toString();
        if(dateTime2.day < 10) {
          day2 = "0" + day2;
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
          Spacer(),
          Text(year + "-" + month + "-" + day1,style: TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),),
          SizedBox(width: 28,),
          Image.asset(SourceControl.getPath("assert/images/ico_hyxq_arrived@2x.png"),height: 20,width: 20,),
          SizedBox(width: 28,),
          Text(year + "-" + month + "-" + day2,style: TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),),
          Spacer(),
        ],);



      }

    }
  }
  
  
  Widget _getNavigatorBtn(int index,List someTimeList) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
        if(index == 1 ){
          if(widget.callBack != null && someTimeList.length != 0) {
            DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(someTimeList.first);
            DateTime begin = DateTime(dateTime1.year,dateTime1.month,dateTime1.day,0,0,0);
            DateTime end = DateTime(dateTime1.year,dateTime1.month,dateTime1.day,23,59,59);
            if(someTimeList.length == 2) {
              DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(someTimeList.last);
              end = DateTime(dateTime2.year,dateTime2.month,dateTime2.day,23,59,59);
            }
            widget.callBack!(begin.millisecondsSinceEpoch,end.millisecondsSinceEpoch);
          }
        }
      },
      child: Container(
        height: 44,color: Colors.transparent,alignment: Alignment.center,
        padding: EdgeInsets.only(left: 12,right: 12),
        child: Text(index == 0 ? "取消" : "确定",style: TextStyle(fontSize: 15,color: index == 0 ? Color(0xFF333333) : Color(0xFF01D28E)),),),
    );
  }

  Widget _getWeekWidget() {
    double someSize = (MediaQuery.of(context).size.width - 20) / 7.0;
    List list = ["一","二","三","四","五","六","日",];
    List<Widget> widgetList = [];
    widgetList.add(SizedBox(width: 10,));
    list.forEach((element) {
      widgetList.add(Expanded(child: Container(
        height: someSize,
        alignment: Alignment.center,
        child: Text(element,style: TextStyle(fontSize: 13,color: Color(0xFFAAAAAA)),),
      )));
    });

    widgetList.add(SizedBox(width: 10,));
    return Row(crossAxisAlignment: CrossAxisAlignment.center,children: widgetList,);
  }

}

class WYCalendarSelectState extends State<SQDateSelectView> {
  
  ScrollController scrollController = ScrollController();

  int? currentYear;
  int? currentMonth;
  int? nowYear;
  List<int> timeList = [];
   int? spaceYear;
   int beginYear = 2015;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    currentYear = now.year;
    nowYear = now.year;
    currentMonth = now.month;
    if(widget.beginYear != null) {
      beginYear = widget.beginYear;
    }
    spaceYear = nowYear! - beginYear;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {

      double offset = MediaQuery.of(context).padding.bottom ;
      double someSize = (MediaQuery.of(context).size.width - 20) / 7.0;
      for(int i = 1 ; i <= 6 ; i ++) {
        int month = currentMonth! + i ;
        if(month > 12) {
          DateTime dateTime = DateTime(currentYear! + 1,month - 12,1);
          int total = _getDayCount(month - 12, currentYear! + 1) + dateTime.weekday - 1 + 6;
          int row = total ~/ 7;
          offset = offset + 32 + 30 + 30 + 16 +  (someSize + 8) * row;
        }else {
          DateTime dateTime = DateTime(currentYear!,month,1);
          int total = _getDayCount(month, currentYear!) + dateTime.weekday - 1 + 6;
          int row = total ~/ 7;
          offset = offset + 32 + 30 + 30 + 16 +  (someSize + 8) * row;
        }
      }

      scrollController.jumpTo(offset - 60);
    });
  }

  int _getDayCount(int month ,int year) {
    switch(month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2 :
        if(year % 4 == 0  && year % 100 != 0) {
          return 29;
        }else if(year % 400 == 0) {
          return 29;
        }else {
          return 28;
        }
        break;
      default :
        return 0 ;
    }
  }

  @override
  Widget build(BuildContext context) {

    List<int> someTimeList = [];
    if(timeList.length == 2) {
      int first = timeList.first;
      int last = timeList.last;
      if(first <= last) {
        someTimeList.add(first);
        someTimeList.add(last);
      }else {
        someTimeList.add(last);
        someTimeList.add(first);
      }
    }else if(timeList.length == 1) {
      someTimeList.add(timeList.first);
    }

    return Scaffold(body: Container(
      color: Colors.white,
      child: Column(children: [
        SizedBox(height: MediaQuery.of(context).padding.top,),
        Container(
            height: 44,
            child: Stack(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                _getNavigatorBtn(0,someTimeList),
                Spacer(),
                _getNavigatorBtn(1,someTimeList),
              ],) ,
             const  Center(child: Text("选择日期",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color:Color(0xFF333333) ),),),
            ],)
        ),
        Container(
          height: 38,
          color: const Color(0xFFF6F7FB),
          child: _getTimeChildWidget(someTimeList),
        ),
        // Expanded(child: _getScrollWidget(someTimeList)),

        Expanded(child: Transform.rotate(angle: 180 * 3.14 / 180,child: ListView.builder(itemBuilder: (context,index) {
          int someIndex = spaceYear!  * 12 + 6 + currentMonth! - 1 - index;
          int year =    nowYear! - spaceYear! + someIndex ~/12;
          int month = someIndex % 12 + 1;
          return Transform.rotate(angle: 180 *3.14/ 180,child: Column(children: [
            SizedBox(height: 32,),
            Container(height: 30,alignment: Alignment.center,child:  Text(year.toString() + "年" + month.toString()+ "月",style: TextStyle(fontSize:18,fontWeight: FontWeight.w600,color: Color(0xFF333333),),),),
            SizedBox(height: 16,),
            Container(height: 30,alignment: Alignment.center,child: _getWeekWidget(),),
            WYMonthItemView(year: year,month: month,timeList: someTimeList,action: (timeStamp) {
              print(timeStamp);

              if(timeList.length == 2) {
                if(timeStamp > someTimeList.last) {
                  timeList.remove(someTimeList.first);
                }
                if(timeStamp < someTimeList.last && someTimeList.first != timeStamp) {
                  timeList.clear();
                }
              }

              if(timeList.contains(timeStamp)) {
                timeList.remove(timeStamp);
              }else {
                if(timeList.length == 2 ) {
                  timeList.removeAt(0);
                  timeList.add(timeStamp);
                }else {
                  timeList.add(timeStamp);
                }
              }
              print(timeList);

              setState(() {

              });
            },),
            if(index == 0)
              SizedBox(height: MediaQuery.of(context).padding.bottom,),

          ],),);

        },itemCount: spaceYear!  * 12 + currentMonth! + 6,padding: EdgeInsets.zero,controller: scrollController,),)),



      ],),
    ),);
  }



  Widget _getTimeChildWidget(List list ) {

    if(list.isEmpty) {
      return Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
        Spacer(),
        Text("请选择时间",style: TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),),
        Spacer(),
      ],);

    }else  {
      DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(list.first);
      String year = dateTime1.year.toString();
      String month = dateTime1.month.toString();
      String day1 = dateTime1.day.toString();
      if(dateTime1.month < 10) {
        month = "0" + month;
      }
      if(dateTime1.day < 10) {
        day1 = "0" + day1;
      }
      if(list.length == 1) {
        ///assets/ico_hyxq_arrived@2x.png
        return Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
          Spacer(),
          Text(year + "-" + month + "-" + day1,style: TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),),
          Spacer(),
        ],);
      }else {
        DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(list.last);
        String year2 = dateTime2.year.toString();
        String day2 = dateTime2.day.toString();
        String month2 = dateTime2.month.toString();
        if(dateTime2.month < 10) {
          month2 = "0" + month2;
        }
        if(dateTime2.day < 10) {
          day2 = "0" + day2;
        }
        print("----------------");
        print(list);

        return Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
          const Spacer(),
          Text("$year-$month-$day1",style: const TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),),
          const SizedBox(width: 28,),
          Image.asset(SourceControl.getPath("assert/images/ico_hyxq_arrived@2x.png"),height: 20,width: 20,),
          const SizedBox(width: 28,),
          Text("$year2-$month2-$day2",style: const TextStyle(fontSize:16,color: Color(0xFFAAAAAA) ),),
          const Spacer(),
        ],);



      }

    }
  }


  Widget _getNavigatorBtn(int index,List someTimeList) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
        if(index == 1 ){
          if(widget.callBack != null && someTimeList.length != 0) {
            DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(someTimeList.first);
            DateTime begin = DateTime(dateTime1.year,dateTime1.month,dateTime1.day,0,0,0);
            DateTime end = DateTime(dateTime1.year,dateTime1.month,dateTime1.day,23,59,59);
            if(someTimeList.length == 2) {
              DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(someTimeList.last);
              end = DateTime(dateTime2.year,dateTime2.month,dateTime2.day,23,59,59);
            }
            widget.callBack!(begin.millisecondsSinceEpoch,end.millisecondsSinceEpoch);
          }
        }
      },
      child: Container(
        height: 44,color: Colors.transparent,alignment: Alignment.center,
        padding: EdgeInsets.only(left: 12,right: 12),
        child: Text(index == 0 ? "取消" : "确定",style: TextStyle(fontSize: 15,color: index == 0 ? Color(0xFF333333) : Color(0xFF01D28E)),),),
    );
  }


  Widget _getWeekWidget() {
    List list = ["一","二","三","四","五","六","日",];
    List<Widget> widgetList = [];
    widgetList.add(SizedBox(width: 10,));
    list.forEach((element) {
      widgetList.add(Expanded(child: Container(
        // height: someSize,
        alignment: Alignment.center,
        child: Text(element,style: TextStyle(fontSize: 13,color: Color(0xFFAAAAAA)),),
      )));
    });

    widgetList.add(SizedBox(width: 10,));
    return Row(crossAxisAlignment: CrossAxisAlignment.center,children: widgetList,);
  }

}



// ignore: must_be_immutable
class WYMonthItemView extends StatelessWidget {
  final int? year ;
  final int? month;
  final Function (int timeStamp)? action;
  final List<int> timeList;

  int beginTimeStamp = 0;


   WYMonthItemView({Key? key, this.year, this.month, this.action, required this.timeList }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double someSize = (MediaQuery.of(context).size.width - 20) / 7.0;
    DateTime now = DateTime.now();
    DateTime current = DateTime(year!,month!,1,0,0,0);
    beginTimeStamp = current.millisecondsSinceEpoch;
    int daysCount = _getDayCount();
    int total = daysCount + current.weekday + 6 - 1;
    int row = total ~/ 7;
    List<Widget> totalList = [];
    for(int i = 0 ; i < row ; i ++ ){
      List<Widget> list = [];
      list.add(SizedBox(width: 10,));
      for(int j = 0 ; j < 7 ; j ++) {
        int location = i * 7 + j - current.weekday + 1 ;
        int type = 2;
        if(j == 6 || location == daysCount - 1) {
          type = 3;
        }
        if(j == 0 || location == 0) {
          type = 1;
        }

        int itemTimeStamp =  beginTimeStamp + location * 60 * 60 * 24 * 1000;

        bool isSelected = false;
        int pointType = 1 ;
        if(timeList.length == 2) {
          if(itemTimeStamp >= timeList.first && itemTimeStamp <= timeList.last) {
            pointType = 2;

            if(itemTimeStamp == timeList.first) {
              isSelected = true;
              type = 1;
              if(j == 6 || location + 1 == daysCount ) {
                type = 4;
              }
            }
            if(itemTimeStamp == timeList.last) {
              isSelected = true;
              type = 3;
              if(j == 0 || location == 0) {
                type = 4;
              }
            }

            if(j == 0 && location + 1 == daysCount) {
              type = 4;
            }
            if(j == 6 && location == 0) {
              type = 4;
            }
          }

        }else if(timeList.length == 1) {
          if(itemTimeStamp == timeList.first) {
            isSelected = true;
          }
        }

        bool isCurrent = false;
        if(year == now.year &&  month == now.month && location + 1 == now.day) {
          isCurrent =  true;
        }
        list.add(Expanded(child: GestureDetector(
          onTap: () {
            if(location >= 0) {
              if(action != null) {
                DateTime dateTime = DateTime(year!,month!,location + 1);
                action!(dateTime.millisecondsSinceEpoch);
              }
            }
          },
          child: location < 0 || location + 1 > _getDayCount() ? Container(
            height: someSize,
            alignment: Alignment.center,
          ) : WYDayItemView(day: location + 1,pointType: pointType,type: type,height: someSize,isCurrent: isCurrent,isSelected: isSelected,),
        )));
      }
      list.add(SizedBox(width: 10,));
      totalList.add(Row(crossAxisAlignment: CrossAxisAlignment.center,children: list,));
      totalList.add(SizedBox(height: 8,));
    }
    return Column(children: totalList,);




  }



  int _getDayCount() {
    switch(month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2 :
        if(year! % 4 == 0  && year! % 100 != 0) {
          return 29;
        }else if(year! % 400 == 0) {
          return 29;
        }else {
          return 28;
        }
        break;
      default :
        return 0 ;
    }
  }

}

class WYDayItemView extends StatelessWidget {
  final double? height ;
  final int? day;
  final int? pointType ; // 1为正常 2 区间内
  final bool isSelected;

  final int? type ;  // 1 为左边 2 为中间 3 // 为右边
  final bool isCurrent;

  const WYDayItemView({Key? key, this.day, this.height, this.type, this.isCurrent = false, this.pointType, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Container(
          height: height,
          decoration: _getBackDecoration(),
          alignment: Alignment.center,
          child: _getChild(),
        );

  }

  Decoration _getBackDecoration() {
    if(pointType == 1) {
      return BoxDecoration(color: Colors.transparent);
    }
    BorderRadius borderRadius = BorderRadius.zero;
    Radius radius = Radius.circular(height!/2.0);
    if(type == 1) {
      borderRadius = BorderRadius.only(topLeft: radius ,bottomLeft: radius);
    }else if(type == 3) {
      borderRadius = BorderRadius.only(topRight: radius ,bottomRight: radius);
    }else if(type == 4) {
      borderRadius = BorderRadius.all(radius);
    }

    return BoxDecoration(
        color: Color(0x3301D28E),
        borderRadius: borderRadius,
    );
  }

  Widget _getChild() {
    Color textColor = Color(0xFF333333);
    if(isCurrent) {
      textColor = Color(0xFFFF6600);
    }
    if(pointType == 2) {
     textColor = Color(0xFF01D28E);
    }
    if(isSelected) {
      textColor = Colors.white;
    }

    return Container(
      height: height,
      width: height,
      decoration: _getSelectColors(),
      alignment: Alignment.center,
      child: isCurrent ? Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center,children: [
        Text(day.toString(),style: TextStyle(fontSize: 16,color: textColor),),
        Text("今天",style: TextStyle(fontSize: 11,color: textColor),),
      ],) : Text(day.toString(),style: TextStyle(fontSize: 16,color: textColor),),
    );
  }

  Decoration _getSelectColors() {
    if(isSelected) {
      return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(height!/2.0)),
        color: Color(0xFF01D28E),
      );
    }
    return BoxDecoration(color: Colors.transparent);
  }

}




