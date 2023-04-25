import 'package:flutter/foundation.dart';

import '../../config/config.dart';
import '../../feature/room/model/room_model.dart';
import '../cache/cache_manager.dart';
import '../network/http_method.dart';
import '../network/network_manager.dart';
import '../network/network_request_options.dart';
import '../network/network_response.dart';

class AuthResponse {
  AuthResponseCode code;
  String? message;
  AuthResponse({
    required this.code,
    this.message,
  });
}

enum AuthResponseCode { success, notFound, badRequest, internal, unknown }

class AuthManager {
  static AuthManager? _instance;
  static AuthManager get instance {
    _instance ??= AuthManager._init();
    return _instance!;
  }

  final http = NetworkManager.instance;
  final cache = CacheManager.instance;
  RoomModel? room;

  AuthManager._init();

  Future<AuthResponse> connect(String code, String password) async {
    try {
      NetworkResponse res = await http.request(
        '${AppConfig.apiUrl}/room',
        options: NetworkRequestOptions(
          HttpMethod.get,
          queryParams: {"code": code, "password": password},
          userAgent: 'Transfer/0.0.1',
        ),
      );
      if (res.statusCode == 200) {
        await cache.writeString('room_code', code);
        await cache.writeString('room_pwd', password);
        room = RoomModel(id: res.data['id'], code: res.data['code'], host: res.data['host']);
        return AuthResponse(code: AuthResponseCode.success);
      } else {
        AuthResponse response = AuthResponse(code: AuthResponseCode.unknown);
        if (res.data != null) {
          if (res.data['kind'] == 'notFound') {
            response = AuthResponse(code: AuthResponseCode.notFound);
          } else if (res.data['kind'] == 'badRequest') {
            response = AuthResponse(code: AuthResponseCode.badRequest, message: res.data['msg']);
          }
        }
        return response;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return AuthResponse(code: AuthResponseCode.internal);
    }
  }

  Future<void> disconnect() async {
    await cache.removeString('room_code');
    await cache.removeString('room_pwd');
    room = null;
  }

  Future<AuthResponse> create(String code, String password) async {
    try {
      NetworkResponse res = await http.request(
        '${AppConfig.apiUrl}/room',
        options: NetworkRequestOptions(
          HttpMethod.post,
          queryParams: {"code": code, "password": password},
          userAgent: 'Transfer/0.0.1',
        ),
      );
      if (res.statusCode == 200) {
        await cache.writeString('room_code', code);
        await cache.writeString('room_pwd', password);
        room = RoomModel(id: res.data['id'], code: res.data['code'], host: res.data['host']);
        return AuthResponse(code: AuthResponseCode.success);
      } else {
        AuthResponse response = AuthResponse(code: AuthResponseCode.unknown);
        if (res.data != null) {
          if (res.data['kind'] == 'notFound') {
            response = AuthResponse(code: AuthResponseCode.notFound);
          } else if (res.data['kind'] == 'badRequest') {
            response = AuthResponse(code: AuthResponseCode.badRequest, message: res.data['msg']);
          }
        }
        return response;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return AuthResponse(code: AuthResponseCode.internal);
    }
  }
}
