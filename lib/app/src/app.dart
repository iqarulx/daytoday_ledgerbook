// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import '/app/app.dart';
import '/services/services.dart';
import '/ui/ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AuthProvider()..checkLoginStatus()),
        ChangeNotifierProvider(
            create: (context) => ThemeProvider()..getTheme()),
        ChangeNotifierProvider(
            create: (context) => LocaleProvider()..getLocale()),
      ],
      child: Consumer3<AuthProvider, ThemeProvider, LocaleProvider>(
        builder: (context, authProvider, themeProvider, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // localizationsDelegates: AppLocalizations.localizationsDelegates,
            // supportedLocales: AppLocalizations.supportedLocales,
            locale: localeProvider.locale,
            title: "Daybook Ledgerbook",
            theme: themeProvider.appTheme ?? AppTheme.appTheme,
            home: authProvider.isLoggedIn
                ? authProvider.homeWidget ?? Container()
                : futureWaitingLoading(context),
          );
        },
      ),
    );
  }
}
