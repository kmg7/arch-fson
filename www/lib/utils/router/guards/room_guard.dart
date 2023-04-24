import 'package:auto_route/auto_route.dart';

import '../../auth/auth_manager.dart';
import '../../cache/cache_manager.dart';
import '../app_router.dart';

class RoomGuard extends AutoRouteGuard {
  final _authMan = AuthManager.instance;
  final _cacheMan = CacheManager.instance;

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final String? code = await _cacheMan.readString('room_code');
    final String? password = await _cacheMan.readString('room_pwd');

    if (code == null || password == null) {
      router.replace(const AuthRoute());
      return;
    }
    await _authMan.connect(code, password);
    if (_authMan.room != null) {
      resolver.next(true);
    } else {
      router.replace(const AuthRoute());
    }
  }
}
