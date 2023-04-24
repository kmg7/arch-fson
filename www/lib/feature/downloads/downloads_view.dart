import 'package:flutter/material.dart';

import '../../utils/widget/app_bar.dart';

class DownloadsView extends StatelessWidget {
  const DownloadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.appbar(context),
      body: const Center(child: Text('Downloads page')),
    );
  }
}
