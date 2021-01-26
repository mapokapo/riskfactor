import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodData {
  String name;
  Map<String, int> nutrients;
  String imagePath;

  FoodData({this.name, this.nutrients, this.imagePath});
}

class VitaminInFoodsPage extends StatelessWidget {
  Widget _nutrientInfo(BuildContext context, FoodData food) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 4.0,
          child: ExpandablePanel(
            header: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    food.imagePath,
                    width: 48.0,
                  ),
                ),
                Text(
                  food.name,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            collapsed: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).foodNutrients,
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            expanded: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      AppLocalizations.of(context).foodNutrients,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...food.nutrients.entries.map((e) {
                    String vitamin = e.key;
                    int percentage = e.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          )),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vitamin " + vitamin,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              percentage.toString() + "%",
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
    Pyridoxine = B6
    Cobalamin = B12
  */

  @override
  Widget build(BuildContext context) {
    final List<FoodData> data = [
      FoodData(nutrients: {
        'A': 1,
        'B6': 0,
        'B12': 0,
        'C': 7,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 38,
        'B6': 5,
        'B12': 0,
        'C': 16,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 2,
        'B6': 15,
        'B12': 0,
        'C': 16,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 1,
        'B6': 20,
        'B12': 0,
        'C': 14,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 334,
        'B6': 5,
        'B12': 0,
        'C': 9,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 10,
        'B6': 5,
        'B12': 18,
        'C': 0,
        'D': 21,
      }),
      FoodData(nutrients: {
        'A': 21,
        'B6': 5,
        'B12': 0,
        'C': 60,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 0,
        'B6': 35,
        'B12': 10,
        'C': 0,
        'D': 2,
      }),
      FoodData(nutrients: {
        'A': 0,
        'B6': 0,
        'B12': 8,
        'C': 0,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 62,
        'B6': 15,
        'B12': 0,
        'C': 212,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 0,
        'B6': 5,
        'B12': 0,
        'C': 17,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 0,
        'B6': 15,
        'B12': 0,
        'C': 32,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 170,
        'B6': 5,
        'B12': 0,
        'C': 15,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 0,
        'B6': 5,
        'B12': 0,
        'C': 3,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 0,
        'B6': 0,
        'B12': 0,
        'C': 97,
        'D': 0,
      }),
      FoodData(nutrients: {
        'A': 1,
        'B6': 50,
        'B12': 36,
        'C': 1,
        'D': 0,
      }),
    ];
    final String fruitNames =
        "Apple_Apricot_Avocado_Banana_Carrot_Eggs_Mango_Meat_Milk_Pepper_Pomegranate_Potato_Pumpkin_Seeds_Strawberry_Tuna";
    for (int i = 0; i < data.length; i++) {
      data[i].name = AppLocalizations.of(context).fruitNames.split("_")[i];
      data[i].imagePath =
          "assets/icons/${fruitNames.split("_")[i].toLowerCase()}.png";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).nutrition),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              children: [...data.map((e) => _nutrientInfo(context, e))],
            ),
          ),
        ),
      ),
    );
  }
}
