import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../auth/auth_manager.dart';
import '../router/app_router.dart';

abstract class CommonWidgets {
  static Widget get progressIndicator => const Center(child: SizedBox.square(dimension: 64, child: CircularProgressIndicator()));

  static AppBar appbar(BuildContext context) => AppBar(
        backgroundColor: const Color(0xff4D455D),
        title: TextButton(
          child: const Text('File Transfer App'),
          onPressed: () {
            context.router.replace(const MainRoute());
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                context.router.replace(const TransferRoute());
              },
              child: const Text('Transfer')),
          TextButton(
              onPressed: () {
                context.router.replace(const DownloadsRoute());
              },
              child: const Text('Downloads')),
          if (AuthManager.instance.room != null)
            TextButton(
                onPressed: () async {
                  await AuthManager.instance.disconnect();
                  if (context.mounted) {
                    context.router.replace(const TransferRoute());
                  }
                },
                child: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ))
        ],
        automaticallyImplyLeading: false,
      );
}
