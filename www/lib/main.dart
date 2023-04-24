import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'gen/translations.g.dart';
import 'utils/router/app_router.dart';
import 'utils/router/guards/auth_guard.dart';
import 'utils/router/guards/room_guard.dart';

Future<void> main() async {
  // await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized(); // add this
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: App()));
}

class App extends StatelessWidget {
  App({super.key});
  final _appRouter = AppRouter(roomGuard: RoomGuard(), authGuard: AuthGuard());
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      locale: TranslationProvider.of(context).flutterLocale, // use provider
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
