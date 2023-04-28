class FileToDownload {
  String name;
  String size;
  String path;
  bool selected = false;

  FileToDownload({
    required this.name,
    required this.size,
    required this.path,
  });

  String get fixedName {
    if (name.length > 20) {
      return '${name.substring(0, 17)}...';
    } else {
      return name;
    }
  }

  factory FileToDownload.fromJson(Map<String, dynamic> json) {
    return FileToDownload(
      name: json['name'] as String,
      size: json['size'] as String,
      path: json['path'] as String,
    );
  }
}

class FileDirectory {
  String? name;
  List<FileToDownload>? files;
  List<FileDirectory>? subdirs;
  bool isMain = false;
  bool selected = false;

  void selectAll(bool val, {Function(FileToDownload, bool)? func}) {
    if (files != null) {
      for (var f in files!) {
        if (func != null) {
          func(f, val);
        }
        f.selected = val;
      }
    }
    if (name != null) {
      if (subdirs != null) {
        for (var sd in subdirs!) {
          if (sd.name != null) {
            if (func != null) {
              sd.selectAll(val, func: func);
            }
          }
        }
      }
    }
    selected = val;
  }

  FileDirectory({this.name, this.files, this.subdirs});

  FileDirectory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['files'] != null) {
      files = <FileToDownload>[];
      json['files'].forEach((v) {
        files!.add(FileToDownload.fromJson(v));
      });
    }
    if (json['subdirs'] != null) {
      subdirs = <FileDirectory>[];
      json['subdirs'].forEach((v) {
        subdirs!.add(FileDirectory.fromJson(v));
      });
    }
  }
}
