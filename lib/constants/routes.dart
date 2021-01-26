import 'package:flutter/material.dart';

import 'package:riskfactor/pages/LandingPage.dart';

import 'package:riskfactor/pages/auth/SignInPage.dart';
import 'package:riskfactor/pages/auth/RegisterPage.dart';
import 'package:riskfactor/pages/auth/ForgotPassPage.dart';
import 'package:riskfactor/pages/home/Covid19TestPage.dart';
import 'package:riskfactor/pages/home/Covid19TestResultsInfoPage.dart';
import 'package:riskfactor/pages/home/Covid19TestResultsPage.dart';
import 'package:riskfactor/pages/home/HelpPage.dart';

import 'package:riskfactor/pages/home/HomePage.dart';
import 'package:riskfactor/pages/home/NutritionPage.dart';
import 'package:riskfactor/pages/home/SettingsPage.dart';
import 'package:riskfactor/pages/home/VitaminInFoodsPage.dart';
import 'package:riskfactor/pages/home/VitaminInfoPage.dart';
import 'package:riskfactor/pages/home/VitaminNutritionInfoPage.dart';

class Routes {
  static const String landing = '/landing';
  static const String signIn = '/signin';
  static const String register = '/register';
  static const String forgotPass = '/forgotpass';
  static const String home = '/home';
  static const String covid19test = '/covid19test';
  static const String covid19testResults = '/covid19testresults';
  static const String covid19testResultsInfo = '/covid19testResultsInfo';
  static const String settings = '/settings';
  static const String nutrition = '/nutrition';
  static const String vitaminInfo = '/vitaminInfo';
  static const String vitaminNutritionInfo = '/vitaminNutritionInfo';
  static const String help = '/help';
  static const String vitaminInFoods = '/vitaminInFoods';

  static Map<String, Widget Function(BuildContext context)> routes() {
    return {
      '/landing': (_) => LandingPage(),
      '/signin': (_) => SignInPage(),
      '/register': (_) => RegisterPage(),
      '/forgotposs': (_) => ForgotPassPage(),
      '/home': (_) => HomePage(),
      '/covid19test': (_) => Covid19TestPage(),
      '/covid19testresults': (_) => Covid19TestResultsPage(),
      '/covid19testResultsInfo': (_) => Covid19TestResultsInfoPage(),
      '/settings': (_) => SettingsPage(),
      '/nutrition': (_) => NutritionPage(),
      '/vitaminInfo': (_) => VitaminInfoPage(),
      '/vitaminNutritionInfo': (_) => VitaminNutritionInfoPage(),
      '/help': (_) => HelpPage(),
      '/vitaminInFoods': (_) => VitaminInFoodsPage(),
    };
  }
}
