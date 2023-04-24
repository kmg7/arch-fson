import 'package:auto_route/auto_route.dart';

import '../../cache/cache_manager.dart';
import '../app_router.dart';

class AuthGuard extends AutoRouteGuard {
  final _cacheMan = CacheManager.instance;

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final String? code = await _cacheMan.readString('room_code');
    final String? password = await _cacheMan.readString('room_pwd');

    if (code == null || password == null) {
      resolver.next(true);
      return;
    }
    router.replace(const MainRoute());
  }
}
