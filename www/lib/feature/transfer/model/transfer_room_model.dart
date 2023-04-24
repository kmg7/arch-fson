class TransferRoomModel {
  String id;
  String code;
  String? host;
  TransferRoomModel({
    required this.id,
    required this.code,
    this.host,
  });
}
