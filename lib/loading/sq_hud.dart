
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SQHud  {
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return EasyLoading.init(builder: builder);
  }
  
  static Future<void>  show({
    String? status,
    Widget? indicator,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
}) async {
   await  EasyLoading.show(status: status,indicator: indicator,maskType: maskType,dismissOnTap: dismissOnTap);
  }
  
  static Future<void> dismiss({
    bool animation = true,
  }) async {
    await EasyLoading.dismiss(animation: animation);
  }
  
  static Future<void> toast({
    String msg = "",
    Duration? duration,
    EasyLoadingToastPosition? toastPosition,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,}) async {
    await EasyLoading.showToast(msg,duration: duration,toastPosition: toastPosition,maskType: maskType,dismissOnTap: dismissOnTap);
  }
}