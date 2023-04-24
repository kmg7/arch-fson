import 'package:flutter/material.dart';

import '../../../utils/widget/app_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.appbar(context),
      body: const Center(
        child: Text('Main Page'),
      ),
    );
  }
}
