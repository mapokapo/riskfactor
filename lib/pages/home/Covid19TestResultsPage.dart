import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/covid19_result_calculator.dart';
import 'package:riskfactor/pages/home/Covid19TestPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:riskfactor/widgets/Covid19ResultsInfo.dart';

class Covid19TestResultsPageArguments {
  List<TestQuestion> questions;
  int previousCaseNumber;

  Covid19TestResultsPageArguments({this.questions, this.previousCaseNumber});
}

class Covid19TestResultsPage extends StatelessWidget {
  Widget _dailyVitaminIntake(BuildContext context, DocumentSnapshot userData) {
    final data = userData.data();
    final int age = int.parse(data['age']);
    final bool isMale = data['gender'] == "male" ? true : false;
    final Map<String, double> intake = {
      'A': isMale ? 0.9 : 0.7,
      'B6': isMale ? (age > 50 ? 1.7 : 1.3) : (age > 50 ? 1.5 : 1.3),
      'C': isMale ? 90 : 75,
      'D': age > 70 ? 0.015 : 0.02,
      'B12': isMale ? 0.0024 : 0.0018,
    };

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Material(
        color: Theme.of(context).primaryColor.withAlpha(75),
        child: Column(
          children: [
            ...intake.entries.map((e) {
              String vitamin = e.key;
              double mg = e.value;
              int index = intake.values.toList().indexOf(mg);
              return Container(
                color: index % 2 == 1
                    ? Theme.of(context).primaryColor.withAlpha(50)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Vitamin " + vitamin),
                      Text(mg.toString() + "mg"),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget informationTile(
      BuildContext context, int caseNumber, DocumentSnapshot userData) {
    return Material(
      color: Provider.of<ThemeNotifier>(context).darkTheme
          ? Colors.grey.shade900
          : Theme.of(context).primaryColorLight,
      elevation: 4.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              caseNumber <= 2
                  ? AppLocalizations.of(context).shouldGetTested
                  : caseNumber <= 4
                      ? AppLocalizations.of(context).shouldTakePrecautions
                      : AppLocalizations.of(context).notAtRisk,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            height: 1.0,
            color: Colors.black,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              AppLocalizations.of(context).vitaminRecommendation,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          _dailyVitaminIntake(context, userData),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              AppLocalizations.of(context).ourRecommendations,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Covid19ResultsInfo(caseNumber),
          ),
        ],
      ),
    );
  }

  Widget _showResults(
      BuildContext context,
      DocumentSnapshot userData,
      DocumentReference docRef,
      List<TestQuestion> questions,
      int previousCaseNumber) {
    List<List<Color>> colorPairs = [
      [
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColorLight,
      ],
      [
        Colors.orange,
        Colors.orange.shade100,
      ],
      [
        Colors.orange,
        Colors.orange.shade100,
      ],
      [
        Colors.yellow.shade600,
        Colors.yellow.shade50,
      ],
      [
        Colors.green,
        Colors.green.shade100,
      ]
    ];
    final int caseNumber = previousCaseNumber > 0
        ? previousCaseNumber
        : calculateCovid19TestResults(questions);
    return FutureBuilder(
        future: docRef.update({
          "infection_status": caseNumber,
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context).infectionRisk,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        "$caseNumber",
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              color: colorPairs[caseNumber - 1][0],
                            ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 5,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.14),
                        ),
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.12),
                        ),
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: -1,
                          color: Color.fromRGBO(0, 0, 0, 0.20),
                        ),
                      ],
                      color: colorPairs[caseNumber - 1][1],
                      border: Border.all(
                        color: colorPairs[caseNumber - 1][0],
                        width: 4.0,
                      ),
                    ),
                  ),
                  informationTile(context, caseNumber, userData),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/background.png'),
                ),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).fetchErrorReopenApp,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(AppLocalizations.of(context).loading),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<FirebaseAuth>(context).currentUser;
    var currentUserDoc = Provider.of<FirebaseFirestore>(context, listen: false)
        .collection('users')
        .doc(currentUser.uid);
    Covid19TestResultsPageArguments _args =
        ModalRoute.of(context).settings.arguments;
    List<TestQuestion> questions = _args.questions ?? [];
    int previousCaseNumber = _args.previousCaseNumber ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).covid19Test),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            FutureBuilder(
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/background.png'),
                      ),
                    ),
                    child: _showResults(context, snapshot.data, currentUserDoc,
                        questions, previousCaseNumber),
                  );
                } else if (snapshot.hasError) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/background.png'),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).fetchErrorReopenApp,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/background.png'),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text(AppLocalizations.of(context).loading),
                    ],
                  ),
                );
              },
              future: Future.delayed(Duration(seconds: 1))
                  .then((_) => currentUserDoc.get()),
            ),
          ],
        ),
      ),
    );
  }
}
