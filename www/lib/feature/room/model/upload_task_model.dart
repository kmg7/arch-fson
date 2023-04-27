class UploadTask {
  String? id;
  int? totalChunk;
  int? lastChunk;

  UploadTask({this.id, this.totalChunk, this.lastChunk});

  UploadTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalChunk = json['totalChunk'];
    lastChunk = json['lastChunk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['totalChunk'] = totalChunk;
    data['lastChunk'] = lastChunk;
    return data;
  }
}
