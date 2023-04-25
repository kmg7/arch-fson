import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'network_request_options.dart';
import 'network_response.dart';

class NetworkManager {
  final Dio _dio = Dio();
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  NetworkManager._init();

  Future<NetworkResponse> request(String path,
      {dynamic data, required NetworkRequestOptions options, String? receieveProgress, String? sendProgress}) async {
    try {
      final response = await _dio.request(path,
          data: data,
          queryParameters: options.queryParams,
          onSendProgress: (count, total) => {if (sendProgress != null) sendProgress = (count / total * 100).toStringAsFixed(0)},
          onReceiveProgress: (count, total) => {if (receieveProgress != null) receieveProgress = (count / total * 100).toStringAsFixed(0)},
          options: Options(method: options.method, headers: options.headers));
      return NetworkResponse(data: response.data, statusCode: response.statusCode);
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (e.response != null) {
        return NetworkResponse(data: e.response!.data, statusCode: e.response!.statusCode);
      } else {
        return NetworkResponse(data: null, statusCode: 400);
      }
    }
  }

  Future<FormData> multipartForm(List<Map<String, List<int>>> files) async {
    var formData = FormData();
    for (var element in files) {
      for (var file in element.entries) {
        formData.files.addAll([
          MapEntry("files", MultipartFile.fromBytes(file.value, filename: file.key)),
        ]);
      }
    }
    return formData;
  }
}
