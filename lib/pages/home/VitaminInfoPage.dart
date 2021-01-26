import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/pages/home/NutritionPage.dart';
import 'package:riskfactor/pages/home/VitaminNutritionInfoPage.dart';
import 'package:riskfactor/state/LanguageNotifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VitaminInfoPageArguments {
  VitaminData data;

  VitaminInfoPageArguments(this.data);
}

class VitaminInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VitaminInfoPageArguments _args = ModalRoute.of(context).settings.arguments;
    VitaminData data = _args.data;

    return Scaffold(
      appBar: AppBar(
        title: Text("Vitamin " + data.vitamin),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Material(
                elevation: 8.0,
                child: Image.asset(data.thumbnail),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  data.body,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (Provider.of<LanguageNotifier>(context, listen: false)
                            .currentLocale
                            .languageCode ==
                        "en")
                      launch(data.vitaminUrl);
                    else
                      Navigator.of(context).pushNamed(
                          Routes.vitaminNutritionInfo,
                          arguments: VitaminNutritionInfoPageArguments(data));
                  },
                  child: Text(
                    AppLocalizations.of(context).viewMoreInfo,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
