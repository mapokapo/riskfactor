import 'package:flutter/material.dart';

import 'package:riskfactor/pages/LandingPage.dart';

import 'package:riskfactor/pages/auth/SignInPage.dart';
import 'package:riskfactor/pages/auth/RegisterPage.dart';
import 'package:riskfactor/pages/auth/ForgotPassPage.dart';

import 'package:riskfactor/pages/home/HomePage.dart';

class Routes {
  static const String landing = '/';
  static const String signIn = '/signin';
  static const String register = '/register';
  static const String forgotPass = '/forgotpass';
  static const String home = '/home';

  static Map<String, Widget Function(BuildContext context)> routes() {
    return {
      '/': (_) => LandingPage(),
      '/signin': (_) => SignInPage(),
      '/register': (_) => RegisterPage(),
      '/forgotposs': (_) => ForgotPassPage(),
      '/home': (_) => HomePage(),
    };
  }
}
