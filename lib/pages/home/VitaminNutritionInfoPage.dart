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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).nutrition),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFFebd2c4),
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
              Image.asset('assets/images/vitamini_hrv.png'),
            ],
          ),
        ),
      ),
    );
  }
}
