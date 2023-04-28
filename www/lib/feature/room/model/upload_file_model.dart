import 'dart:html';
import 'dart:math';

import 'package:intl/intl.dart';

import 'package:fson/feature/room/model/upload_task_model.dart';

class FileToUpload {
  dynamic file;
  String name;
  int size;
  UploadTask? task;
  UploadStatus status = UploadStatus.notStarted;
  double uploaded = 0;

  FileToUpload({
    required this.file,
    required this.name,
    required this.size,
    this.task,
  });

  String get fixedName {
    if (name.length > 20) {
      return '${name.substring(0, 17)}...';
    } else {
      return name;
    }
  }

  bool get isLarge => _chunkSize * 2 < _chunkSize;

  String get readableSize => readableFileSize(size);
  int get totalChunks => (size / _chunkSize).ceil();
  int get _chunkSize => 1024 * 1024 * 1;

  Stream<List<int>> getChunkStream(int number) async* {
    number--;
    final int start = _chunkSize * (number);
    final int end = min(start + _chunkSize, size);
    final reader = FileReader();
    final blob = file.slice(start, end);

    reader.readAsArrayBuffer(blob);
    await reader.onLoad.first;
    yield reader.result as List<int>;
  }

  String readableFileSize(int byte) {
    final units = ["B", "KB", "MB", "GB", "TB"];
    if (byte <= 0) return "0 B";

    int digitGroups = (log(byte) / log(1024)).floor();
    if (digitGroups >= units.length) digitGroups = units.length - 1;

    return "${NumberFormat("#,##0.#").format(byte / pow(1024, digitGroups))} ${units[digitGroups]}";
  }
}

enum UploadStatus { notStarted, started, paused, cancelled, finished }
