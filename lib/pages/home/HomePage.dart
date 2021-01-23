import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/pages/home/Covid19TestResultsPage.dart';
import 'package:riskfactor/state/LanguageNotifier.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget informationTile(
      {Widget child,
      Function onClick,
      bool checkmarkIcon = false,
      Widget icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            child: InkWell(
              onTap: () {
                onClick();
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  child: child,
                ),
              ),
            ),
          ),
          checkmarkIcon
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.0),
                      bottomRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(4.0),
                    ),
                  ),
                )
              : (icon ?? SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget welcomeWidget(
      {FirebaseAuth firebaseAuth,
      FirebaseFirestore firebaseFirestore,
      Future<DocumentSnapshot> firebaseFirestoreFutureDoc}) {
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
    return FutureBuilder(
      future: firebaseFirestoreFutureDoc,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).welcome,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  snapshot.data.data()['name'],
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16.0),
                  child: Text(
                    AppLocalizations.of(context).homePageText,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                informationTile(
                  onClick: () {
                    if (snapshot.data.data()['infection_status'] != null)
                      Navigator.of(context).pushNamed(Routes.covid19testResults,
                          arguments: Covid19TestResultsPageArguments(
                              previousCaseNumber:
                                  snapshot.data.data()['infection_status']));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).healthStatus,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Expanded(
                          child: snapshot.data.data()['infection_status'] !=
                                  null
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 32.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 64.0,
                                        height: 64.0,
                                        child: CircularProgressIndicator(
                                          value: snapshot.data
                                              .data()['infection_status']
                                              .toDouble(),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            colorPairs[snapshot.data.data()[
                                                    'infection_status'] -
                                                1][0],
                                          ),
                                          backgroundColor: colorPairs[snapshot
                                                  .data
                                                  .data()['infection_status'] -
                                              1][1],
                                          strokeWidth: 8.0,
                                        ),
                                      ),
                                      Text(
                                        "${snapshot.data.data()['infection_status']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    AppLocalizations.of(context).unavailable,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                          color: Colors.orange,
                                        ),
                                  ),
                                )),
                    ],
                  ),
                  checkmarkIcon: snapshot.data.data()['infection_status'] == 5,
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor.withOpacity(0.5)),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    launch(Provider.of<LanguageNotifier>(context, listen: false)
                                .currentLocale
                                .languageCode ==
                            "bs"
                        ? "https://www.hzjz.hr/priopcenja-mediji/koronavirus-najnoviji-podatci/"
                        : "https://www.cdc.gov/coronavirus/2019-ncov/downloads/2019-ncov-factsheet.pdf");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context).viewMoreInfo,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError)
          return Text(
            AppLocalizations.of(context).fetchErrorReopenApp,
            style: Theme.of(context).textTheme.bodyText2,
          );
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget polygonBackgroundWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background.png'),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: Provider.of<ThemeNotifier>(context).darkTheme
                    ? [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.9),
                      ]
                    : [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.9),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  Future<DocumentSnapshot> firebaseFirestoreFutureDoc;

  @override
  void initState() {
    super.initState();
    firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);
    firebaseFirestore = Provider.of<FirebaseFirestore>(context, listen: false);
    firebaseFirestoreFutureDoc = firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              SwitchListTile(
                value: Provider.of<ThemeNotifier>(context).darkTheme,
                secondary: Icon(Icons.brightness_4),
                title: Text(AppLocalizations.of(context).darkMode),
                onChanged: (_) {
                  Provider.of<ThemeNotifier>(context, listen: false)
                      .toggleTheme();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(AppLocalizations.of(context).settings),
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.settings);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(AppLocalizations.of(context).signOut),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            AppLocalizations.of(context).signOutConfirmation,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                AppLocalizations.of(context).yes,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.red),
                              ),
                              onPressed: () {
                                firebaseAuth.signOut().then((_) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      Routes.landing, (_) => false);
                                });
                              },
                            ),
                            TextButton(
                              child: Text(
                                AppLocalizations.of(context).no,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Riskfactor",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.white,
              ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              polygonBackgroundWidget(),
              Column(
                children: [
                  welcomeWidget(
                    firebaseAuth: firebaseAuth,
                    firebaseFirestore: firebaseFirestore,
                    firebaseFirestoreFutureDoc: firebaseFirestoreFutureDoc,
                  ),
                  Spacer(),
                  FutureBuilder<DocumentSnapshot>(
                      future: firebaseFirestoreFutureDoc,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32.0, horizontal: 16.0),
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Column(
                                children: [
                                  if (snapshot.hasError)
                                    Text(
                                      AppLocalizations.of(context)
                                          .fetchErrorReopenApp,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data
                                              .data()['infection_status'] ==
                                          null)
                                    Text(
                                      AppLocalizations.of(context)
                                          .covid19TestNotCompleted,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data
                                              .data()['infection_status'] ==
                                          null)
                                    Text(
                                      AppLocalizations.of(context)
                                          .clickHereToStart,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Colors.grey.shade200,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data
                                              .data()['infection_status'] !=
                                          null)
                                    Text(
                                      AppLocalizations.of(context).covid19Test,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Colors.grey.shade200,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              if (snapshot.data.data()['infection_status'] ==
                                  null)
                                Navigator.of(context)
                                    .pushNamed(Routes.covid19test);
                              else
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .covid19Test,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .retakeOrView,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .retake,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pushNamed(
                                                  Routes.covid19test);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              AppLocalizations.of(context).view,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(color: Colors.blue),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pushNamed(
                                                  Routes.covid19testResults,
                                                  arguments:
                                                      Covid19TestResultsPageArguments(
                                                          previousCaseNumber:
                                                              snapshot.data
                                                                      .data()[
                                                                  'infection_status']));
                                            },
                                          ),
                                        ],
                                      );
                                    });
                            },
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
