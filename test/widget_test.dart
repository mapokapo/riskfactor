// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:riskfactor/constants/config.dart';
import 'package:riskfactor/constants/routes.dart';

import 'package:riskfactor/main.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    SharedPreferences _sharedPreferencesInstance =
        await SharedPreferences.getInstance();
    FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;
    FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance;
    // App config
    Config _appConfig = Config(devMode: false, initialRoute: Routes.landing);
    if (_firebaseAuthInstance.currentUser != null) {
      _appConfig.initialRoute = Routes.home;
    }
    /* End Provider instances */
    List<SingleChildWidget> providers = [
      Provider(create: (context) => _firebaseAuthInstance),
      Provider(create: (context) => _firebaseFirestoreInstance),
      Provider(create: (context) => _sharedPreferencesInstance),
      Provider(create: (context) => _appConfig),
      ChangeNotifierProvider(create: (context) => ThemeNotifier()),
    ];
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      Config(),
      providers,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
