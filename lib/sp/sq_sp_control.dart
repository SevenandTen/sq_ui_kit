


import 'package:shared_preferences/shared_preferences.dart';

class SQSqControl {

  static final  SQSqControl _control = SQSqControl();

  SharedPreferences? sp;

  static ready() async {
    _control.sp = await SharedPreferences.getInstance();
  }

  static SharedPreferences? getSp() {
    return _control.sp;
  }

}