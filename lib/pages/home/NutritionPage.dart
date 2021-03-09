import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/pages/home/VitaminInfoPage.dart';
import 'package:riskfactor/state/LanguageNotifier.dart';

class VitaminData {
  String vitamin;
  String shortDescription;
  String body;
  String thumbnail;
  String vitaminUrl;
  Color themeColor;
  Color textColor;

  VitaminData({
    this.vitamin,
    this.shortDescription,
    this.body,
    this.thumbnail,
    this.vitaminUrl,
    this.themeColor,
    this.textColor = Colors.white,
  });
}

class NutritionPage extends StatelessWidget {
  Widget vitaminCard(BuildContext context, VitaminData vitaminData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      vitaminData.vitamin,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: vitaminData.textColor,
                          ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: vitaminData.themeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  "Vitamin " + vitaminData.vitamin,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0),
                child: Text(
                  vitaminData.shortDescription,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.vitaminInfo,
                          arguments: VitaminInfoPageArguments(vitaminData));
                    },
                    child: Text(AppLocalizations.of(context).viewMoreInfo),
                  ),
                ],
              ),
              Image.asset(vitaminData.thumbnail),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<VitaminData> data = [
      VitaminData(
        vitamin: "A",
        shortDescription: AppLocalizations.of(context).vitaminAShortDesc,
        body: AppLocalizations.of(context).vitaminAContent,
        thumbnail: 'assets/images/vitamin_a.png',
        vitaminUrl:
            "https://${Provider.of<LanguageNotifier>(context).currentLocale.languageCode == "bs" ? "hr" : "en"}.wikipedia.org/wiki/Vitamin_A",
        themeColor: Colors.purple,
      ),
      VitaminData(
        vitamin: "B6",
        shortDescription: AppLocalizations.of(context).vitaminB6ShortDesc,
        body: AppLocalizations.of(context).vitaminB6Content,
        thumbnail: 'assets/images/vitamin_b6.jpg',
        vitaminUrl:
            "https://${Provider.of<LanguageNotifier>(context).currentLocale.languageCode == "bs" ? "hr" : "en"}.wikipedia.org/wiki/Vitamin_B6",
        themeColor: Colors.green,
      ),
      VitaminData(
        vitamin: "B12",
        shortDescription: AppLocalizations.of(context).vitaminB12ShortDesc,
        body: AppLocalizations.of(context).vitaminB12Content,
        thumbnail: 'assets/images/vitamin_b12.png',
        vitaminUrl:
            "https://${Provider.of<LanguageNotifier>(context).currentLocale.languageCode == "bs" ? "hr" : "en"}.wikipedia.org/wiki/Vitamin_B12",
        themeColor: Colors.yellow,
        textColor: Colors.black,
      ),
      VitaminData(
        vitamin: "C",
        shortDescription: AppLocalizations.of(context).vitaminCShortDesc,
        body: AppLocalizations.of(context).vitaminCContent,
        thumbnail: 'assets/images/vitamin_c.jpg',
        vitaminUrl:
            "https://${Provider.of<LanguageNotifier>(context).currentLocale.languageCode == "bs" ? "hr" : "en"}.wikipedia.org/wiki/Vitamin_C",
        themeColor: Colors.red,
      ),
      VitaminData(
        vitamin: "D",
        shortDescription: AppLocalizations.of(context).vitaminDShortDesc,
        body: AppLocalizations.of(context).vitaminDContent,
        thumbnail: 'assets/images/vitamin_d.jpg',
        vitaminUrl:
            "https://${Provider.of<LanguageNotifier>(context).currentLocale.languageCode == "bs" ? "hr" : "en"}.wikipedia.org/wiki/Vitamin_D",
        themeColor: Colors.orange,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).nutrition),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context).foodVitamins),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.vitaminInFoods);
                      },
                      child: Text(
                        AppLocalizations.of(context).viewMoreInfo,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              ...data.map((e) => vitaminCard(context, e)),
            ],
          ),
        ),
      ),
    );
  }
}
