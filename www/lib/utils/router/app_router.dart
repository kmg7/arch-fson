import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../feature/authentication/view/auth_view.dart';
import '../../feature/downloads/downloads_view.dart';
import '../../feature/main/view/main_view.dart';
import '../../feature/room/view/room_view.dart';
import 'guards/auth_guard.dart';
import 'guards/room_guard.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'View,Route',
  routes: <AutoRoute>[
    AutoRoute(page: MainView, path: '/'),
    AutoRoute(page: AuthView, path: '/auth', guards: [AuthGuard]),
    AutoRoute(page: RoomView, path: '/transfer', guards: [RoomGuard]),
    AutoRoute(page: DownloadsView, path: '/downloads'),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter {
  AppRouter({required super.roomGuard, required super.authGuard});
}
