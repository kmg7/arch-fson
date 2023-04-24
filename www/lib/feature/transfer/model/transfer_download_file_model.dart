class TFile {
  String name;
  String size;
  String path;
  bool selected = false;

  TFile({
    required this.name,
    required this.size,
    required this.path,
  });

  factory TFile.fromJson(Map<String, dynamic> json) {
    return TFile(
      name: json['name'] as String,
      size: json['size'] as String,
      path: json['path'] as String,
    );
  }
}

class TFSubDirectory {
  String? name;
  List<TFile>? files;
  List<TFSubDirectory>? subdirs;
  bool isMain = false;
  bool selected = false;

  void selectAll(bool val, {Function(TFile, bool)? func}) {
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

  TFSubDirectory({this.name, this.files, this.subdirs});

  TFSubDirectory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['files'] != null) {
      files = <TFile>[];
      json['files'].forEach((v) {
        files!.add(TFile.fromJson(v));
      });
    }
    if (json['subdirs'] != null) {
      subdirs = <TFSubDirectory>[];
      json['subdirs'].forEach((v) {
        subdirs!.add(TFSubDirectory.fromJson(v));
      });
    }
  }
}
