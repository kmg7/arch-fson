import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/config.dart';
import '../../../gen/translations.g.dart';
import '../../../utils/network/http_content_type.dart';
import '../../../utils/network/http_method.dart';
import '../../../utils/network/network_manager.dart';
import '../../../utils/network/network_request_options.dart';
import '../../../utils/network/network_response.dart';
import '../model/download_file_model.dart';
import '../model/room_model.dart';
import '../model/upload_file_model.dart';
import '../model/upload_task_model.dart';

part 'room_view_model.g.dart';

class RoomViewModel = TransferViewModelBase with _$RoomViewModel;

abstract class TransferViewModelBase with Store {
  @observable
  RoomModel room;

  @observable
  bool isLoading = false;

  @observable
  List<FileToDownload> filesToDownload = [];

  @observable
  List<FileToUpload> filesToUpload = [];

  @observable
  FileDirectory? availableFiles;

  @observable
  int downloadFileCount = 0;

  @observable
  int uploadFileCount = 0;

  @observable
  bool mode = true;

  @observable
  bool hostOnline = false;

  TransferViewModelBase({
    required this.room,
  }) {
    pingHost();

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await pingHost();
    });
  }

  final http = NetworkManager.instance;

  @action
  void changeLoading() {
    isLoading = !isLoading;
  }

  @action
  void changeUploadList(FileToUpload file, bool? op) {
    if (op != null) {
      if (op) {
        filesToUpload.add(file);
      } else {
        filesToUpload.remove(file);
      }
    }
  }

  @action
  void changeDownloadList(FileToDownload file, bool? op) {
    if (op != null) {
      if (op) {
        filesToDownload.add(file);
      } else {
        filesToDownload.remove(file);
      }
    }
  }

  @action
  Future<void> download(String path) async {
    if (!hostOnline) {
      return;
    }
    final url = Uri.parse('http://${room.host}/transfer?file=$path');
    await launchUrl(url);
  }

  @action
  Future<void> downloadSelected() async {
    if (!hostOnline) {
      return;
    }
    for (var element in filesToDownload) {
      await download(element.path);
    }
    await refresh();
  }

  @action
  Future<void> upload(FileToUpload file, Function(double) uploaded) async {
    try {
      if (!hostOnline) {
        return;
      }
      NetworkResponse taskResponse;
      taskResponse = await http.request(
        'http://${room.host}/task',
        options: NetworkRequestOptions(HttpMethod.post, userAgent: 'Transfer/0.0.1', contentType: HttpContentType.json),
        data: jsonEncode({"name": file.name, "size": file.size, "totalChunk": file.totalChunks}),
      );
      if (taskResponse.statusCode == 201) {
        file.task = UploadTask.fromJson(taskResponse.data);
      } else {
        return;
      }
      bool isCompleted = false;
      bool errorHappened = false;
      int currentChunk = 1;

      while (!isCompleted && !errorHappened && (currentChunk <= file.task!.totalChunk!)) {
        uploaded(((currentChunk) / (file.task!.totalChunk!)));
        NetworkResponse response;
        String address = 'http://${room.host}/transfer/${file.task!.id!}?chunk=$currentChunk';
        response = await http.request(
          address,
          options: NetworkRequestOptions(
            HttpMethod.post,
            userAgent: 'Transfer/0.0.1',
          ),
          data: http.multipartFormFromStream(file.getChunkStream(currentChunk), file.size),
        );
        // print('currentChunk:$currentChunk | ${file.task!.totalChunk!} response:${response.statusCode}');
        file.task!.lastChunk = currentChunk;
        currentChunk++;
      }
    } catch (e) {
      print(e);
    }
  }

  @action
  Future<void> refresh() async {
    changeLoading();
    filesToDownload.clear();
    filesToUpload.clear();
    try {
      NetworkResponse response;
      response = await http.request(
        '${AppConfig.apiUrl}/room/${room.id}',
        options: NetworkRequestOptions(
          HttpMethod.get,
          userAgent: 'Transfer/0.0.1',
        ),
      );
      if (response.statusCode == 200) {
        room.code = response.data['code'];
        room.host = response.data['host'];
        if (room.host != null) {
          await getFiles(room.host!);
        }
      } else {
        var message = t.message.common.unexpected;
        if (response.data != null) {
          if (response.data['kind'] == 'notFound') {
            message = t.message.common.not_found;
          } else if (response.data['kind'] == 'badRequest' && response.data['msg'] != null) {
            message = response.data['msg'];
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    changeLoading();
  }

  @action
  Future<void> pingHost() async {
    try {
      NetworkResponse response;
      response = await http.request(
        'http://${room.host}/status',
        options: NetworkRequestOptions(
          HttpMethod.get,
          userAgent: 'Transfer/0.0.1',
        ),
      );
      if (response.statusCode == 200) {
        hostOnline = true;
      } else {
        hostOnline = false;
      }
    } catch (e) {}
  }

  Future<void> getFiles(String host) async {
    changeLoading();
    try {
      NetworkResponse response;
      response = await http.request(
        'http://${room.host}/files',
        options: NetworkRequestOptions(
          HttpMethod.get,
          userAgent: 'Transfer/0.0.1',
        ),
      );
      if (response.statusCode == 200) {
        availableFiles = FileDirectory.fromJson(response.data);
      } else {
        var message = t.message.common.unexpected;
        if (response.data != null) {
          if (response.data['kind'] == 'notFound') {
            message = t.message.common.not_found;
          } else if (response.data['kind'] == 'badRequest' && response.data['msg'] != null) {
            message = response.data['msg'];
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    changeLoading();
  }
}
