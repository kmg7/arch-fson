import 'dart:math';

class FileToUpload {
  String name;
  int size;
  List<int>? bytes;

  FileToUpload({
    required this.name,
    required this.size,
    required this.bytes,
  });

  String get readableSize => readableFileSize(size);
}

String readableFileSize(int byte) {
  final units = ["B", "kB", "MB", "GB", "TB"];
  if (byte <= 0) return "0";

  int digitGroups = (log(byte) / log(1024)).round();
  String size = (byte / pow(1024, digitGroups)).toString().substring(0, (byte / pow(1024, digitGroups)).toString().indexOf(".") + 3);

  return "$size ${units[digitGroups]}";
}
