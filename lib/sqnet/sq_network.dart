
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class SQNetWork {
  static final Dio _dio = Dio();

  static ready({String ip = ""}) async {

    if (_dio.httpClientAdapter is DefaultHttpClientAdapter) {
      DefaultHttpClientAdapter adapter =
      _dio.httpClientAdapter as DefaultHttpClientAdapter;
      adapter.onHttpClientCreate = (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
        if (ip.isNotEmpty) {
          client.findProxy = (uri) {
            return "PROXY $ip";
          };
        }
      };
    }
  }


}


class SQResponse {

}