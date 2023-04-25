import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fson/gen/translations.g.dart';
import 'package:restart_app/restart_app.dart';

import '../auth/auth_manager.dart';
import '../cache/cache_manager.dart';
import '../router/app_router.dart';

abstract class CommonWidgets {
  static Widget get progressIndicator => const Center(child: SizedBox.square(dimension: 64, child: CircularProgressIndicator()));

  static AppBar appbar(BuildContext context) => AppBar(
        backgroundColor: const Color(0xff4D455D),
        title: TextButton(
          child: Text(t.title.common.fson),
          onPressed: () {
            context.router.replace(const MainRoute());
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                context.router.replace(const RoomRoute());
              },
              child: Text(t.title.common.room)),
          TextButton(
              onPressed: () {
                context.router.replace(const DownloadsRoute());
              },
              child: Text(t.title.common.downloads)),
          PopupMenuButton(
              position: PopupMenuPosition.under,
              constraints: const BoxConstraints(maxWidth: 200),
              tooltip: t.title.common.settings,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        height: 10,
                        child: PopupMenuButton(
                          child: ListTile(
                            leading: const Icon(
                              Icons.translate_rounded,
                              color: Colors.black,
                            ),
                            title: Text(t.title.common.language.change),
                          ),
                          onSelected: (value) async {
                            await CacheManager.instance.writeString('locale', value);
                            await Restart.restartApp();
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 'en',
                                child: ListTile(
                                  title: Text(t.title.common.language.english),
                                )),
                            PopupMenuItem(
                                value: 'tr',
                                child: ListTile(
                                  title: Text(t.title.common.language.turkish),
                                ))
                          ],
                        )),
                    if (AuthManager.instance.room != null)
                      PopupMenuItem(
                          child: TextButton.icon(
                        onPressed: () async {
                          await AuthManager.instance.disconnect();
                          if (context.mounted) {
                            context.router.replace(const RoomRoute());
                          }
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        label: Text(t.action.common.log_out),
                      ))
                  ]),
          // if (AuthManager.instance.room != null)
          //   TextButton(
          //       onPressed: () async {
          //         await AuthManager.instance.disconnect();
          //         if (context.mounted) {
          //           context.router.replace(const RoomRoute());
          //         }
          //       },
          //       child: const Icon(
          //         Icons.logout,
          //         color: Colors.red,
          //       ))
        ],
        automaticallyImplyLeading: false,
      );
}
