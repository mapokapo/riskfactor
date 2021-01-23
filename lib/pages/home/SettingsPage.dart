import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/language.dart';
import 'package:riskfactor/state/LanguageNotifier.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.brightness_4),
                  value: Provider.of<ThemeNotifier>(context).darkTheme,
                  title: Text(
                    AppLocalizations.of(context).darkMode,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onChanged: (bool newValue) {
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .toggleTheme();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  trailing: Text(
                    Language.languageList()
                        .where((e) =>
                            e.languageCode ==
                            Provider.of<LanguageNotifier>(context)
                                .currentLocale
                                .languageCode)
                        .first
                        .name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.grey),
                  ),
                  title: Text(
                    AppLocalizations.of(context).chooseLanguage,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      child: SimpleDialog(
                        title: Text(
                          AppLocalizations.of(context).chooseLanguage,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        children: [
                          ...Language.languageList()
                              .map((e) => SimpleDialogOption(
                                    child: Text(e.flag + " " + e.name),
                                    onPressed: () {
                                      Provider.of<LanguageNotifier>(context,
                                              listen: false)
                                          .changeLanguage(
                                              Locale(e.languageCode));
                                      Navigator.of(context).pop();
                                    },
                                  )),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    AppLocalizations.of(context).about,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onTap: () {
                    debugPrint("${Theme.of(context).accentColor}");
                    showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset(
                        'assets/images/app_icon_512.png',
                        scale: 2.5,
                      ),
                      applicationName: "RiskFactor",
                      applicationVersion: "1.0.6",
                      children: [
                        Text(
                          AppLocalizations.of(context).appLegalese,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        TextButton(
                          onPressed: () {
                            launch(
                                "https://www.app-privacy-policy.com/live.php?token=usX2ZKQk6CIYrHSxedNyVPI2kJXUAcA6");
                          },
                          child: Text(
                            AppLocalizations.of(context).viewPrivacyPolicy,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Spacer(),
                Text("RiskFactor Team"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
