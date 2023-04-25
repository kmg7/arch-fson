class RoomModel {
  String id;
  String code;
  String? host;
  RoomModel({
    required this.id,
    required this.code,
    this.host,
  });
}
