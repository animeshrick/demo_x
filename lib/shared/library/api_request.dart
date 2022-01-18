import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiRequest {
  final String url;
  final String authKey;
  final Map data;

  ApiRequest({
    @required this.url,
    @required this.authKey,
    this.data,
  });

  Dio _dio() {
    // Put your authorization token here
    return Dio(BaseOptions(headers: {
      'Authorization': 'B ....',
    }));
  }

  void get({
    Function() beforeSend,
    Function(dynamic data) onSuccess,
    Function(dynamic error) onError,
  }) {
    if(beforeSend!=null)
      beforeSend();
    if(authKey==null){
      _dio().get(this.url, queryParameters: this.data).then((res) {
        if (onSuccess != null) onSuccess(res.data);
      }).catchError((error) {
        if (onError != null) onError(error);
      });
    }
    else {
      _dio().get(this.url, queryParameters: this.data, options: Options(
        headers: {
          "Authorization": "Token ${authKey}", // set content-length
        },
      ),).then((res) {
        if (onSuccess != null) onSuccess(res.data);
      }).catchError((error) {
        if (onError != null) onError(error);
      });
    }
  }
}