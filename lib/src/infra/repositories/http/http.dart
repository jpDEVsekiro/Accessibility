import 'dart:io';

import 'package:dio/dio.dart';

enum Method { post, get, put, delete, patch }

class Http {
  Dio? _dio;

  Future<bool> init({String? newBaseUrl}) async {
    //var baseUrl = 'http://10.100.0.68:5004';
    //var baseUrl = 'http://192.168.15.3:5004';

    var baseUrl = newBaseUrl ?? 'https://maps.googleapis.com/maps/api/place';

    //logger.w('[API URL] => $baseUrl');

    Map<String, dynamic> header = {
      'Content-Type': 'application/json',
    };

    _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: header,
        connectTimeout: 60000,
        receiveTimeout: 120000));
    initInterceptors();
    return true;
  }

  void initInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          // logger.w(
          //     // "REQUEST[${requestOptions.method}] => PATH: ${requestOptions.path}"
          //     // "=> REQUEST VALUES: ${requestOptions.queryParameters} => HEADERS: ${requestOptions.headers}");
          //     "REQUEST[${requestOptions.method}] => PATH: ${requestOptions.path}"
          //     "=> REQUEST VALUES: ${requestOptions.queryParameters}");
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) {
          // logger
          //     .w("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (err, handler) {
          //logger.w("Error[${err.response?.statusCode}]");
          return handler.next(err);
        },
      ),
    );
  }

  Future<dynamic> request(
      {required String url,
      required Method method,
      dynamic params,
      String? newBaseUrl}) async {
    Response response;

    if (await init(newBaseUrl: newBaseUrl) == false) {
      throw CustomException("Token expired");
    }

    try {
      if (method == Method.post) {
        response = await _dio!.post(
          url,
          data: params,
        );
        // .timeout(const Duration(minutes: 2));
      } else if (method == Method.delete) {
        response = await _dio!.delete(url);
      } else if (method == Method.patch) {
        response = await _dio!.patch(url);
      } else {
        response = await _dio!.get(url, queryParameters: params);
        // .timeout(const Duration(minutes: 2));
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response;
      } else if (response.statusCode == 401) {
        throw CustomException("Unauthorized");
      } else if (response.statusCode == 500) {
        throw CustomException("Server Error");
      } else {
        throw CustomException("Something does wen't wrong");
      }
    } on SocketException catch (error) {
      //logger.e(e);
      throw CustomException("${error.message}Not Internet Connection");
    } on FormatException catch (error) {
      //logger.e(e);
      throw CustomException("${error.message}Bad response format");
    } on DioError catch (error) {
      //logger.e(e);
      throw CustomException(error.message);
    } catch (error) {
      throw CustomException("Something wen't wrong");
    }
  }
}

class CustomException implements Exception {
  String errorMessage;

  CustomException(this.errorMessage);
}
