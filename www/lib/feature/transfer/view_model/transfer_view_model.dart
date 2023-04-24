import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/config.dart';
import '../../../gen/translations.g.dart';
import '../../../utils/network/http_method.dart';
import '../../../utils/network/network_manager.dart';
import '../../../utils/network/network_request_options.dart';
import '../../../utils/network/network_response.dart';
import '../model/transfer_download_file_model.dart';
import '../model/transfer_room_model.dart';
import '../model/transfer_upload_file_model.dart';

part 'transfer_view_model.g.dart';

class TransferViewModel = TransferViewModelBase with _$TransferViewModel;

abstract class TransferViewModelBase with Store {
  @observable
  TransferRoomModel room;

  @observable
  bool isLoading = false;

  @observable
  List<TFile> filesToDownload = [];

  @observable
  List<FileToUpload> filesToUpload = [];

  @observable
  TFSubDirectory? availableFiles;

  @observable
  int downloadFileCount = 0;

  @observable
  int uploadFileCount = 0;

  @observable
  bool mode = true;

  TransferViewModelBase({
    required this.room,
  });

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
  void changeDownloadList(TFile file, bool? op) {
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
    final url = Uri.parse('http://${room.host}/transfer?file=$path');
    await launchUrl(url);
  }

  @action
  Future<void> downloadSelected() async {
    for (var element in filesToDownload) {
      await download(element.path);
    }
    await refresh();
  }

  @action
  Future<void> upload() async {
    try {
      if (filesToUpload.isEmpty) {
        print('No Files Selected');
        return;
      }
      changeLoading();
      NetworkResponse response;
      response = await http.request(
        'http://${room.host}/transfer',
        options: NetworkRequestOptions(
          HttpMethod.post,
          userAgent: 'Transfer/0.0.1',
        ),
        data: await http.multipartForm(filesToUpload.map((e) => {e.name: e.bytes!}).toList()),
      );
      if (response.statusCode == 200) {
        print('Files Uploaded Succesfully');
      } else {
        print('Something went wrong on uploading files host error');
      }
      uploadFileCount = 0;
      filesToUpload.clear();
      changeLoading();
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
      // print(response.statusCode);
      // print(response.data);
      if (response.statusCode == 200) {
        availableFiles = TFSubDirectory.fromJson(response.data);
        // availableFiles!.isMain = true;
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
