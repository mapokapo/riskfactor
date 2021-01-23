import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/constants/language.dart';
import 'package:riskfactor/pages/auth/RegisterPage.dart';
import 'package:riskfactor/state/LanguageNotifier.dart';
import 'package:riskfactor/widgets/AuthButton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<int> _casesFuture;

  @override
  void initState() {
    super.initState();
    _casesFuture = _getCovid19Cases(context);
  }

  Future<int> _getCovid19Cases(BuildContext context) async {
    SharedPreferences prefs = context.read<SharedPreferences>();
    String timestamp = prefs.get('covid19cases_lastupdate');
    DateTime time;
    if (timestamp != null) {
      time = DateTime.parse(timestamp);
    }
    if (time == null ||
        DateTime.now().difference(time).compareTo(Duration(hours: 1)) > 0) {
      return http
          .get('https://corona.lmao.ninja/v3/covid-19/all')
          .then((value) {
        int cases = json.decode(value.body)['todayCases'] as int;
        prefs.setInt('covid19cases_value', cases);
        prefs.setString(
            'covid19cases_lastupdate', DateTime.now().toIso8601String());
        return cases;
      });
    }
    return prefs.getInt('covid19cases_value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.5, 1.0),
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.blueGrey.shade800
                          : Colors.white,
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.blueGrey.shade800
                          : Colors.white,
                      Theme.of(context).primaryColor,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: DropdownButton(
                        hint: Text(
                          Language.languageList()
                              .where((element) =>
                                  element.languageCode ==
                                  Provider.of<LanguageNotifier>(context)
                                      .currentLocale
                                      .languageCode)
                              .first
                              .name,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        icon: Icon(
                          Icons.language,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (Language lang) {
                          context
                              .read<LanguageNotifier>()
                              .changeLanguage(Locale(lang.languageCode));
                        },
                        items: Language.languageList()
                            .map((lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Row(
                                    children: [
                                      Text(lang.name),
                                      Text(lang.flag),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Theme.of(context).brightness == Brightness.dark
                                ? Image.asset('assets/images/logo_dark.png')
                                : Image.asset('assets/images/logo.png'),
                            SizedBox(height: 8.0),
                            FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                String text = AppLocalizations.of(context)
                                        .worldwideCovid19Cases +
                                    ": ";
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Text(
                                      text +
                                          AppLocalizations.of(context).loading,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    );
                                  default:
                                    if (snapshot.hasError)
                                      return Text(' ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2);
                                    else
                                      return Text(
                                        text + snapshot.data.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        textAlign: TextAlign.center,
                                      );
                                }
                              },
                              future: _casesFuture,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: AuthButton(
                              title: AppLocalizations.of(context).signIn,
                              onClick: () {
                                Navigator.of(context).pushNamed(Routes.signIn);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: AuthButton(
                              title: AppLocalizations.of(context).register,
                              onClick: () {
                                Navigator.of(context).pushNamed(Routes.register,
                                    arguments: RegisterPageArguments());
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
