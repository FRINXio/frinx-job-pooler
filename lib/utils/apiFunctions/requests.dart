import 'dart:io';
import 'package:dio/dio.dart';

const DOMAIN = "https://147.175.163.219:8443";

Future<Response> postRequest(String url, Map<String, String> body, String token) async {
  Dio dio = new Dio();
  var _headers;
  if (token != null) {
    _headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "*/*"
    };
  } else {
    _headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "*/*"
    };
  }
  return await dio.post(DOMAIN + url, data: body, options: Options(headers: _headers));
}

Future<Response> getRequest(String url, Map<String, String> queryParameters, String token) async {
  Dio dio = new Dio();
  final _headers = {
    HttpHeaders.authorizationHeader: token,
  };
  return await dio.get(DOMAIN + url, queryParameters: queryParameters, options: Options(headers: _headers));
}