import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/state/LanguageNotifier.dart';
import 'package:url_launcher/url_launcher.dart';

class Covid19ResultsInfo extends StatelessWidget {
  final int caseNumber;

  Covid19ResultsInfo(this.caseNumber);

  @override
  Widget build(BuildContext context) {
    String case1 = AppLocalizations.of(context).case1RecommendationText;
    String case2 = AppLocalizations.of(context).case2RecommendationText;
    String case3 = AppLocalizations.of(context).case3RecommendationText;
    String chosenCase = caseNumber > 3
        ? case3
        : caseNumber > 1
            ? case2
            : case1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            chosenCase,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            AppLocalizations.of(context).generalRecommendationText1,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            AppLocalizations.of(context).generalRecommendationText2,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        if (Provider.of<LanguageNotifier>(context).currentLocale.languageCode ==
            "bs")
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                child: SimpleDialog(
                  title: Text(
                    AppLocalizations.of(context).callHospital,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        launch("tel:124");
                      },
                      child: Text('Hitna medicinska pomoć'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        launch("https://dzmostar.com/contact/");
                      },
                      child: Text('Dom Zdravlja Mostar'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        launch("http://judzks.ba/kontakti/");
                      },
                      child: Text('Dom Zdravlja Sarajevo'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        launch("http://www.dzgracanica.com/index.php/kontakt");
                      },
                      child: Text('Dom Zdravlja Gračanica'),
                    ),
                  ],
                ),
              );
            },
            child: Text(AppLocalizations.of(context).callHospital),
          ),
        ElevatedButton(
          onPressed: () {
            launch(Provider.of<LanguageNotifier>(context, listen: false)
                        .currentLocale
                        .languageCode ==
                    "bs"
                ? "https://www.hzjz.hr/priopcenja-mediji/koronavirus-najnoviji-podatci/"
                : "https://www.cdc.gov/coronavirus/2019-ncov/downloads/2019-ncov-factsheet.pdf");
          },
          child: Text(AppLocalizations.of(context).viewMoreInfo),
        ),
      ],
    );
  }
}
