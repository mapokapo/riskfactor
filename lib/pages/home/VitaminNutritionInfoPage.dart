import 'package:flutter/material.dart';
import 'package:riskfactor/pages/home/NutritionPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VitaminNutritionInfoPageArguments {
  VitaminData data;

  VitaminNutritionInfoPageArguments(this.data);
}

class VitaminNutritionInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VitaminNutritionInfoPageArguments _args =
        ModalRoute.of(context).settings.arguments;
    VitaminData data = _args.data;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).nutrition),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    AppLocalizations.of(context).nutritionValues,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Image.asset('assets/images/vitamini_hrv.png'),
                  SizedBox(
                    height: 16,
                  ),
                  Image.asset(
                      'assets/images/vitamin_${data.vitamin.toLowerCase()}2.jpg'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
