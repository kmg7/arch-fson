import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../gen/translations.g.dart';
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
      body: Center(
        child: SizedBox(
          width: 800,
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text(t.pages.main.about),
              const SizedBox(height: 80),
              Text(t.pages.main.project_page),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse('https://github.com/kmlgkcy/fson'));
                  },
                  child: const Text('GitHub'))
            ],
          ),
        ),
      ),
    );
  }
}
