// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:network_logger/network_logger.dart';

final showLoadingProvider = StateProvider<bool>((ref) {
  return false;
});
String baseUrl = 'https://pmifapi.tigerdigital.tech/api/';

extension ImagePathExtension on String {
  String get convertedImageUrl {
    const baseUrl = 'https://pmifapi.tigerdigital.tech/public/storage/';
    return baseUrl + this;
  }
}

class ApiManager {
  late String baseUrl;
  WidgetRef ref;
  BuildContext context;
  var dio = Dio();

  ApiManager(this.context, this.ref) {
    baseUrl = 'https://pmifapi.tigerdigital.tech/api';
    dio.interceptors.add(DioNetworkLogger());
  }
  // Post data to server
  Future<Map?> postData(String url,
      {required Map body,
      String? token,
      bool useDefaultBaseUrl = true,
      bool useEcommBaseUrl = false,
      Map<String, dynamic>? customHeader,
      bool? showLoading}) async {
    debugPrint('Post data from $url');
    Map<String, dynamic>? headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null) {
      headers['Authorization'] = token;
    }
    Map? responseJson;
    try {
      ref.watch(showLoadingProvider.notifier).state = true;
      final Response response = await dio.post(
        useDefaultBaseUrl ? '$baseUrl}/$url' : url,
        options: Options(
          headers: (customHeader == null) ? headers : customHeader,
          validateStatus: (status) => true,
        ),
        data: body,
      );
      responseJson = response.data;
      ref.watch(showLoadingProvider.notifier).state = false;
    } on DioError {
      debugPrint('Dio Error');
      // Get.snackbar(
      //   'noInternet'.tr,
      //   'pleaseCheckYourInternetConnection'.tr,
      //   snackPosition: SnackPosition.TOP,
      // );
    } catch (e) {
      ref.watch(showLoadingProvider.notifier).state = false;
      showSnackbar(context);
    }
    debugPrint('Request body : $body');
    debugPrint('Server response : $responseJson');
    return responseJson;
  }

  // Update data from server

  Future<Map?> updateData(String url, {required Map body, String? token}) async {
    debugPrint('Post data from $url');

    Map? responseJson;
    try {
      final Response response = await dio.put(
        '$baseUrl/$url',
        data: body,
      );
      responseJson = response.data;
    } catch (e) {
      showSnackbar(context);
    }
    debugPrint('Request body : $body');
    debugPrint('Server response : $responseJson');
    return responseJson;
  }

  // Get data from server
  Future<dynamic> getData(String url,
      {String? token,
      bool useDefaultBaseUrl = true,
      bool useEcommBaseUrl = false,
      Map<String, dynamic>? queryParameters}) async {
    debugPrint('Get data from $url');
    // token = token ?? StorageService().read(AppConstants.accessToken);

    dynamic responseJson;
    try {
      final Response response = await dio.get(
        '$baseUrl/$url',
        // queryParameters: queryParameters,
      );
      responseJson = response.data;
    } on DioError {
      debugPrint('Dio Error');
    } catch (e) {
      showSnackbar(context);
    }
    debugPrint('Server response : $responseJson');
    return responseJson;
  }

  // upload file to server using dio multipart
  Future<Map?> uploadFile(String url, {File? file, String? token, bool? isSended}) async {
    debugPrint('Upload file from $url');

    Map? responseJson;
    debugPrint('The token is $token');
    debugPrint('The file is $file');
    if (file != null) {
      try {
        final Response response = await dio.post(
          '$baseUrl/$url',
          onSendProgress: (int sent, int total) {
            debugPrint('Top 1 $sent/$total');
          },
          onReceiveProgress: (int received, int total) {
            debugPrint('Top 2 $received/$total');
            if (received / total == 1) {
              isSended = true;
              debugPrint('File sent');
            }
          },
          data: FormData.fromMap({
            'file': await MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last, contentType: getMediaType(file.path))
          }),
        );
        responseJson = response.data;
      } catch (e) {
        showSnackbar(context);
      }
    }
    debugPrint('Server response : $responseJson');
    return responseJson;
  }

  // delete data from server with body
  Future<Map?> deleteData(String url, {required Map body, String? defaultUrl, String? token}) async {
    debugPrint('Delete data from $url');

    Map? responseJson;
    try {
      final Response response = await dio.delete(
        '$baseUrl/$url',
        data: body,
      );
      responseJson = response.data;
    } catch (e) {
      showSnackbar(context);
    }
    debugPrint('Request body : $body');
    debugPrint('Server response : $responseJson');
    return responseJson;
  }

  // Post data to server
  Future<Map?> putData(String url,
      {required Map body,
      String? token,
      bool useDefaultBaseUrl = true,
      bool useEcommBaseUrl = false,
      Map<String, dynamic>? customHeader}) async {
    debugPrint('Put data from $url');

    Map? responseJson;
    try {
      final Response response = await dio.put(
        useDefaultBaseUrl ? '$baseUrl}/$url' : url,
        data: body,
      );
      responseJson = response.data;
    } catch (e) {
      showSnackbar(context);
    }
    debugPrint('Request body : $body');
    debugPrint('Server response : $responseJson');
    return responseJson;
  }
}

MediaType getMediaType(String path) {
  var mimeType = lookupMimeType(path);

  if (mimeType == null) {
    return MediaType("application", "octet-stream");
  }
  return MediaType(mimeType.split('/')[0], mimeType.split('/')[1]);
}

void showSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please check your network and try again'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}
