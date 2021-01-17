import 'package:flutter/material.dart';

import 'package:riskfactor/pages/LandingPage.dart';

import 'package:riskfactor/pages/auth/SignInPage.dart';
import 'package:riskfactor/pages/auth/RegisterPage.dart';
import 'package:riskfactor/pages/auth/ForgotPassPage.dart';
import 'package:riskfactor/pages/home/Covid19TestPage.dart';

import 'package:riskfactor/pages/home/HomePage.dart';

class Routes {
  static const String landing = '/landing';
  static const String signIn = '/signin';
  static const String register = '/register';
  static const String forgotPass = '/forgotpass';
  static const String home = '/home';
  static const String covid19test = '/covid19test';

  static Map<String, Widget Function(BuildContext context)> routes() {
    return {
      '/landing': (_) => LandingPage(),
      '/signin': (_) => SignInPage(),
      '/register': (_) => RegisterPage(),
      '/forgotposs': (_) => ForgotPassPage(),
      '/home': (_) => HomePage(),
      '/covid19test': (_) => Covid19TestPage(),
    };
  }
}
