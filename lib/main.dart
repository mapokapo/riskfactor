import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:riskfactor/constants/language.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/constants/theme_data.dart';
import 'package:riskfactor/state/LanguageNotifier.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'constants/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Have to do this in order to use Firebase
  await Firebase.initializeApp();

  /* Begin Provider instances */
  SharedPreferences _sharedPreferencesInstance =
      await SharedPreferences.getInstance();
  FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance;
  // App config
  Config _appConfig = Config(devMode: false, initialRoute: Routes.landing);
  if (_firebaseAuthInstance.currentUser != null) {
    _appConfig.initialRoute = Routes.home;
  }
  /* End Provider instances */
  List<SingleChildWidget> providers = [
    Provider(create: (context) => _firebaseAuthInstance),
    Provider(create: (context) => _firebaseFirestoreInstance),
    Provider(create: (context) => _sharedPreferencesInstance),
    Provider(create: (context) => _appConfig),
    ChangeNotifierProvider(create: (context) => ThemeNotifier()),
    ChangeNotifierProvider(create: (context) => LanguageNotifier(context))
  ];

  runApp(MyApp(_appConfig, providers));
}

class MyApp extends StatelessWidget {
  final Config _appConfig;
  final List<SingleChildWidget> _providers;
  MyApp(this._appConfig, this._providers, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      builder: (BuildContext context, _) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Provider.of<LanguageNotifier>(context).currentLocale,
          debugShowCheckedModeBanner: _appConfig.devMode,
          title: 'RiskFactor',
          theme: Provider.of<ThemeNotifier>(context).darkTheme
              ? darkTheme
              : lightTheme,
          initialRoute: _appConfig.initialRoute,
          routes: Routes.routes(),
        );
      },
    );
  }
}
