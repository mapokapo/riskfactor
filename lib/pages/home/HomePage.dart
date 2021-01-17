import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget informationTile(
      {Widget child, bool checkmarkIcon = false, Widget icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0),
                child: child,
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
      {FirebaseAuth firebaseAuth, FirebaseFirestore firebaseFirestore}) {
    return FutureBuilder(
      future: firebaseUserDataFuture,
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
                  snapshot.data.get('name'),
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 32.0,
                ),
                informationTile(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).healthStatus,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      snapshot.data.data()['health_status'] != null
                          ? LinearProgressIndicator(
                              value: double.tryParse(
                                  snapshot.data.data()['health_status']),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                              minHeight: 8.0,
                            )
                          : Text(
                              AppLocalizations.of(context).unavailable,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Colors.orange,
                                  ),
                            ),
                    ],
                  ),
                  checkmarkIcon: snapshot.data.data()['infection_risk'] != null,
                ),
                informationTile(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).infectionRisk,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Expanded(
                          child: snapshot.data.data()['infection_risk'] != null
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 32.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 64.0,
                                        height: 64.0,
                                        child: CircularProgressIndicator(
                                          value: double.tryParse(snapshot.data
                                              .data()['infection_risk']),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.green,
                                          ),
                                          strokeWidth: 8.0,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          "${snapshot.data.data()['infection_risk']}%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
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
                  checkmarkIcon: snapshot.data.data()['infection_risk'] != null,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError)
          return Text(
            AppLocalizations.of(context).fetchErrorReopenApp,
            style: Theme.of(context).textTheme.bodyText2,
          );
        return CircularProgressIndicator();
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
  Future<DocumentSnapshot> firebaseUserDataFuture;

  @override
  void initState() {
    super.initState();
    firebaseAuth = context.read<FirebaseAuth>();
    firebaseFirestore = context.read<FirebaseFirestore>();
    firebaseUserDataFuture = firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riskfactor",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.white,
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
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
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              polygonBackgroundWidget(),
              Column(
                children: [
                  welcomeWidget(
                    firebaseAuth: firebaseAuth,
                    firebaseFirestore: firebaseFirestore,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 16.0),
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: Column(
                          children: [
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
                            Text(
                              AppLocalizations.of(context).clickHereToStart,
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
                        Navigator.of(context).pushNamed(Routes.covid19test);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
