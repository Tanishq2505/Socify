import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:socify/constants.dart';
import 'package:socify/model/apis/app_exception.dart';

class MediaService {
  late final Dio _dio;

  MediaService() {
    _dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "app-id": const String.fromEnvironment(
            "API_ID",
          )
        },
        baseUrl: apiUrl,
        followRedirects: false,
        validateStatus: (status) {
          return (status ?? 200) < 500;
        },
      ),
    );
  }

  Future<dynamic> get(String url) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(
        url,
      );
      responseJson = returnResponse(response);
    } on DioError {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await _dio.post(
        url,
        data: body,
      );
      responseJson = returnResponse(response);
    } on DioError {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> update(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await _dio.put(
        url,
        data: body,
      );
      responseJson = returnResponse(response);
    } on DioError {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    dynamic responseJson;
    try {
      final response = await _dio.delete(
        url,
      );
      responseJson = returnResponse(response);
    } on DioError {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @visibleForTesting
  dynamic returnResponse(Response response) {
    if (response.statusCode! > 199 && response.statusCode! < 300) {
      dynamic responseJson = response.data;
      return responseJson;
    } else if (response.statusCode! > 399 && response.statusCode! < 500) {
      if (response.statusCode == 404) {
        throw UnauthorisedException(response.data.toString());
      } else {
        throw BadRequestException(response.data.toString());
      }
    } else {
      throw FetchDataException('Error occured while communication with server' +
          ' with status code : ${response.statusCode}');
    }
    // switch (response.statusCode) {
    //   case 200:
    //   case 201:
    //     dynamic responseJson = response.data;
    //     return responseJson;
    //   case 400:
    //     throw BadRequestException(response.data.toString());
    //   case 401:
    //   case 403:
    //   case 404:
    //     throw UnauthorisedException(response.data.toString());
    //   case 500:
    //   default:
    //     throw FetchDataException(
    //         'Error occured while communication with server' +
    //             ' with status code : ${response.statusCode}');
    // }
  }
}
